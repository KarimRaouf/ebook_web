import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:ebook_web/core/utils/strings.dart';
import 'package:ebook_web/features/admin_panel/view_model/panel_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_launcher_icons/utils.dart';

import 'model/book_model.dart';

class PanelCubit extends Cubit<PanelState> {
  PanelCubit() : super(PanelInitial()) {
    getCurrentUser();
  }

  static PanelCubit get(context) => BlocProvider.of(context);

  TextEditingController authorNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController PDFController = TextEditingController();
  TextEditingController audioController = TextEditingController();

  Future<void> addBook(Book book) async {
    CollectionReference books = FirebaseFirestore.instance.collection('books');
    return books.add({
      'imageUrl': book.imageUrl,
      'author': book.author,
      'category': book.category,
      'pdfLink': book.pdfLink,
      'audioLink': book.audioLink,
    }).then((value) {
      print(value.id);
      print("Book Added");
    }).catchError((error) => print("Failed to add book: $error"));
  }

  Future<void> addRequest() async {
    CollectionReference request =
        FirebaseFirestore.instance.collection('requests');
    var mail =
        await FirebaseFirestore.instance.collection('users').doc(uId).get();

    final CollectionReference collection =
        FirebaseFirestore.instance.collection('users');

   await request.doc(uId).set({
      'uId': uId,
      'email': mail.data()?['email'],
    });
    collection.doc(uId).set(
      {
        'status': 'Requested',
      },
      SetOptions(
        merge: true,
      ),
    ).then((value) {
      print("request Added");
    }).catchError((error) {
      print("Failed to add request:$error");
    }); // Use merge option to update the document if it exists
  }

  //
  //
  // Future<void> uploadFile(String filePath, String fileName) async {
  //   File file = File(filePath);
  //
  //   try {
  //     await FirebaseStorage.instance.ref('uploads/$fileName').putFile(file);
  //   } on FirebaseException catch (e) {
  //     // Handle any errors.
  //   }
  // }

  // File? file;
  // File? pdfFile;
  // File? audioFile;
  //
  // Future<void> selectFile(BuildContext context, String fileType) async {
  //   String? extension;
  //   if (fileType == 'pdf') {
  //     extension = 'pdf';
  //   } else if (fileType == 'audio') {
  //     extension = 'mp3';
  //   }
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: [extension!],
  //   );
  //
  //   if (result != null) {
  //     final path = result.files.single.path!;
  //       if (fileType == 'pdf') {
  //         pdfFile = File(path);
  //       } else if (fileType == 'audio') {
  //        audioFile = File(path);
  //       }
  //   }
  // }

  Future<String?> uploadFile({
    required Uint8List fileBytes,
    required String fileName,
    required String dirName,
    required String contentType,
  }) async {
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      Reference ref = FirebaseStorage.instance.ref('$dirName/$fileName');

      SettableMetadata metadata = SettableMetadata(
        contentType: contentType,
        customMetadata: {'picked': 'true'},
      );

      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putData(fileBytes, metadata);

      // Wait until the file is uploaded then return the download URL
      // TaskSnapshot snapshot = await uploadTask;

      await uploadTask.whenComplete(() => null);
      String downloadUrl = await ref.getDownloadURL();

      print(downloadUrl);
      return downloadUrl;
    } on FirebaseException catch (e) {
      // Handle any errors
      print('KarimError');
      print(e);
      return null;
    }
  }

  // UploadTask? uploadTask;
  //
  // Future uploadFile() async {
  //   if (file == null) return;
  //
  //   final fileName = file!.path.split('/').last;
  //   final destination = 'pdfs/$fileName';
  //
  //   uploadTask = FirebaseStorage.instance.ref(destination).putFile(file!);
  //
  //   final snapshot = await uploadTask!.whenComplete(() {});
  //   final urlDownload = await snapshot.ref.getDownloadURL();
  //
  //   await FirebaseFirestore.instance.collection('books').add({
  //     'pdf': urlDownload,
  //     'author': 'Author Name', // Replace with actual data
  //     'title': 'Book Title', // Replace with actual data
  //   });
  //
  //   uploadTask = null;
  // }

  Map<String, dynamic>? pdfFile;
  Map<String, dynamic>? audioFile;
  Map<String, dynamic>? imageFile;

  Future<Map<String, dynamic>?> pickFile(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      Uint8List? fileBytes = file.bytes;
      String fileName = file.name; // Get the file name

      emit(PickFileState());
      return {
        'bytes': fileBytes,
        'name': fileName,
      };
    }
    return null;
  }

  void setBookData() {
    pdfFile = null;
    audioFile = null;
    imageFile = null;

    categoryController.clear();
    authorNameController.clear();
  }

  Future<void> deleteItem(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('books')
          .doc(documentId)
          .delete();
      print('Document successfully deleted!');
    } catch (e) {
      print('Error while deleting document: $e');
    }
  }

  Future<void> updateBook({
    String? bookId,
    String? newAuthor,
    String? newImage,
    String? newAudio,
    String? newPdf,
    String? newCat,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('books').doc(bookId).update({
        'author': newAuthor,
        'audioLink': newAudio,
        'category': newCat,
        'pdfLink': newPdf,
        'imageUrl': newImage,
      });
      print("Book successfully updated!");
    } catch (e) {
      print("Error updating book: $e");
    }
  }

  bool isBannerVisible = true;

  void closeBanner() {
    isBannerVisible = false;
    emit(state);
  }

  Map<String, dynamic>? currentUser;

  Future<void> getCurrentUser() async {
    var status =
        await FirebaseFirestore.instance.collection('users').doc(uId).get();

    currentUser = status.data();
    emit(state);
  }

  Future<void> updateUserStatus({
    String? userId,
    String? status,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'status': status,
      });

      emit(ActivateUserState());
      print("user successfully updated!");
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  Future<dynamic> fetchNetworkImage(imageUrl) async {
    try {
      final response = await Dio().get(imageUrl);
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      }
      return null; // Image not downloaded properly
    } catch (e) {
      print(e);
      return null; // An error occurred
    }
  }
}
