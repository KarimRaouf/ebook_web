import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_web/core/utils/app_ui.dart';
import 'package:ebook_web/features/admin_panel/view_model/model/book_model.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/utils/app_util.dart';
import '../../../core/utils/styles.dart';
import '../../../shared/cache_helper.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_drawer.dart';
import '../../../widgets/custom_textfield.dart';
import '../view_model/panel_cubit.dart';
import '../view_model/panel_state.dart';

class BooksView extends StatelessWidget {
  const BooksView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PanelCubit, PanelState>(
      listener: (context, state) {
        if (state is PickFileState) {
          AppUtil.showToast(message: 'File Uploaded Succussfully');
        }
      },
      builder: (context, state) {
        PanelCubit panelCubit = PanelCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Admin Panel'),
          ),
          drawer: const CustomDrawer(),
          body: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('books').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading');
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
                    int gridCount = constraints.maxWidth > 600 ? 4 : 2;

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridCount,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 100.0,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // Build each book item
                        // Book book = books[index];

                        var book = snapshot.data!.docs[index];

                        return Card(
                          margin: const EdgeInsetsDirectional.all(10),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                CustomBookImage(
                                  imageUrl: book['imageUrl'] ?? "",
                                ),

                                Text(book['author'] ?? ""), // Author name
                                Text(book['category'] ?? ""), // Category
                                InkWell(
                                  onTap: () => {}, // Link to open PDF
                                  child: Text('${book['pdfLink'] ?? ""}'),
                                ),
                                InkWell(
                                  onTap: () => {}, // Link to play audio
                                  child:
                                      Text('Audio: ${book['audioLink'] ?? ""}'),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        // panelCubit.addBook(Book(author: 'KarimRaouf' , category: 'Programming', imageUrl: 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1663889444i/62691480.jpg' , audioLink: 'audio',pdfLink: 'pdf'));
                                        panelCubit.setBookData();
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: false,
                                          // User must tap button to dismiss dialog
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Update Book'),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    TextField(
                                                      controller: panelCubit
                                                          .authorNameController,
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  "Author"),
                                                    ),
                                                    TextField(
                                                      controller: panelCubit
                                                          .categoryController,
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  "Category"),
                                                    ),

                                                    const SizedBox(height: 20),

                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        panelCubit.imageFile =
                                                            await panelCubit
                                                                .pickFile(
                                                                    context);
                                                      },
                                                      child:
                                                          const Text('Image'),
                                                    ),

                                                    const SizedBox(height: 20),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        panelCubit.pdfFile =
                                                            await panelCubit
                                                                .pickFile(
                                                                    context);
                                                      },
                                                      child: const Text('PDF'),
                                                    ),

                                                    const SizedBox(height: 20),

                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        panelCubit.audioFile =
                                                            await panelCubit
                                                                .pickFile(
                                                                    context);
                                                      },
                                                      child:
                                                          const Text('Audio'),
                                                    ),

                                                    // const SizedBox(height: 20),
                                                    // Text(panelCubit.fileName ?? 'No file selected'),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text(
                                                      'Upload and Save'),
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();

                                                    String? pdfUrl;
                                                    String? audioUrl;
                                                    String? imageUrl;
                                                    if (panelCubit.pdfFile !=
                                                        null) {
                                                      pdfUrl = await panelCubit
                                                          .uploadFile(
                                                              dirName: 'pdf',
                                                              fileName: panelCubit
                                                                      .pdfFile![
                                                                  'name'],
                                                              fileBytes: panelCubit
                                                                      .pdfFile![
                                                                  'bytes']);
                                                      print('ddfdfd');
                                                    }
                                                    if (panelCubit.audioFile !=
                                                        null) {
                                                      audioUrl = await panelCubit
                                                          .uploadFile(
                                                              dirName: 'audio',
                                                              fileName: panelCubit
                                                                      .audioFile![
                                                                  'name'],
                                                              fileBytes: panelCubit
                                                                      .audioFile![
                                                                  'bytes']);
                                                    }
                                                    if (panelCubit.imageFile !=
                                                        null) {
                                                      imageUrl = await panelCubit
                                                          .uploadFile(
                                                              dirName: 'audio',
                                                              fileName: panelCubit
                                                                      .imageFile![
                                                                  'name'],
                                                              fileBytes: panelCubit
                                                                      .imageFile![
                                                                  'bytes']);
                                                    }

                                                    panelCubit.updateBook(
                                                      bookId: snapshot
                                                          .data!.docs[index].id,
                                                      newAuthor: panelCubit
                                                          .authorNameController
                                                          .text.isEmpty ?book['author']:panelCubit
                                                          .authorNameController
                                                          .text ,
                                                      newImage: imageUrl??book['imageUrl'],
                                                      newPdf: pdfUrl??book['pdfLink'],
                                                      newAudio: audioUrl??book['audioLink'],
                                                      newCat: panelCubit
                                                          .categoryController
                                                          .text.isEmpty ?book['category']:panelCubit
                                                          .categoryController
                                                          .text,
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        panelCubit.deleteItem(
                                            snapshot.data!.docs[index].id);
                                        // Implement delete functionality
                                        // setState(() {
                                        //   books.removeAt(index);
                                        // });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppUI.navyBlue,
            child: const Icon(
              Icons.add,
              color: AppUI.whiteColor,
            ),
            onPressed: () {
              // panelCubit.addBook(Book(author: 'KarimRaouf' , category: 'Programming', imageUrl: 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1663889444i/62691480.jpg' , audioLink: 'audio',pdfLink: 'pdf'));
              panelCubit.setBookData();
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                // User must tap button to dismiss dialog
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Add a new book'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          TextField(
                            controller: panelCubit.authorNameController,
                            decoration:
                                const InputDecoration(hintText: "Author"),
                          ),
                          TextField(
                            controller: panelCubit.categoryController,
                            decoration:
                                const InputDecoration(hintText: "Category"),
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () async {
                              panelCubit.imageFile =
                                  await panelCubit.pickFile(context);
                            },
                            child: const Text('Image'),
                          ),

                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              panelCubit.pdfFile =
                                  await panelCubit.pickFile(context);
                            },
                            child: const Text('PDF'),
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () async {
                              panelCubit.audioFile =
                                  await panelCubit.pickFile(context);
                            },
                            child: const Text('Audio'),
                          ),

                          // const SizedBox(height: 20),
                          // Text(panelCubit.fileName ?? 'No file selected'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Upload and Save'),
                        onPressed: () async {
                          Navigator.of(context).pop();

                          String? pdfUrl;
                          String? audioUrl;
                          String? imageUrl;
                          if (panelCubit.pdfFile != null) {
                            pdfUrl = await panelCubit.uploadFile(
                                dirName: 'pdf',
                                fileName: panelCubit.pdfFile!['name'],
                                fileBytes: panelCubit.pdfFile!['bytes']);
                            print('ddfdfd');
                          }
                          if (panelCubit.audioFile != null) {
                            audioUrl = await panelCubit.uploadFile(
                                dirName: 'audio',
                                fileName: panelCubit.audioFile!['name'],
                                fileBytes: panelCubit.audioFile!['bytes']);
                          }
                          if (panelCubit.imageFile != null) {
                            imageUrl = await panelCubit.uploadFile(
                                dirName: 'audio',
                                fileName: panelCubit.imageFile!['name'],
                                fileBytes: panelCubit.imageFile!['bytes']);
                          }

                          panelCubit.addBook(
                            Book(
                              author: panelCubit.authorNameController.text,
                              category: panelCubit.categoryController.text,
                              imageUrl: panelCubit.imageFile?['bytes'] ?? " ",
                              pdfLink: pdfUrl,
                              audioLink: audioUrl,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class CustomBookImage extends StatelessWidget {
  const CustomBookImage({super.key, this.imageUrl});

  final imageUrl;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5 / 2.5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(imageUrl),
          ),
        ),
      ),
    );
  }
}
