import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_web/core/utils/app_ui.dart';
import 'package:ebook_web/features/admin_panel/view_model/model/book_model.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

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
            title: const Text('Books'),
          ),
          drawer: const CustomDrawer(),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('books').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
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
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomBookImage(
                                imageUrl: book['imageUrl'] ?? "",
                              ),

                              Text(book['author'] ?? ""), // Author name

                              const SizedBox(height: 20),

                              Text('Category: ${book['category'] ?? ""}'),
                              const SizedBox(height: 20),

                              InkWell(
                                onTap: () async {
                                  if (await canLaunchUrl(
                                      Uri.parse(book['pdfLink']))) {
                                    await launchUrl(Uri.parse(book['pdfLink']));
                                  } else {
                                    throw 'Could not launch ${book['pdfLink']}';
                                  }
                                }, // Link to open PDF
                                child: Text('PDF'),
                              ),
                              const SizedBox(height: 20),

                              InkWell(
                                onTap: () async {
                                  if (await canLaunch(book['audioLink'])) {
                                    await launch(book['audioLink']);
                                  } else {
                                    throw 'Could not launch ${book['audioLink']}';
                                  }
                                }, // Link to play audio
                                child: Text('Audio'),
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
                                                            hintText: "Author"),
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
                                                    child: const Text('Image'),
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
                                                          .pdfFile!['name'],
                                                      fileBytes: panelCubit
                                                          .pdfFile!['bytes'],
                                                      contentType:
                                                          'application/pdf',
                                                    );
                                                    print('ddfdfd');
                                                  }
                                                  if (panelCubit.audioFile !=
                                                      null) {
                                                    audioUrl = await panelCubit
                                                        .uploadFile(
                                                      dirName: 'audio',
                                                      fileName: panelCubit
                                                          .audioFile!['name'],
                                                      fileBytes: panelCubit
                                                          .audioFile!['bytes'],
                                                      contentType: 'audio/mpeg',
                                                    );
                                                  }
                                                  if (panelCubit.imageFile !=
                                                      null) {
                                                    imageUrl = await panelCubit
                                                        .uploadFile(
                                                      dirName: 'images',
                                                      fileName: panelCubit
                                                          .imageFile!['name'],
                                                      fileBytes: panelCubit
                                                          .imageFile!['bytes'],
                                                      contentType: 'image/jpeg',
                                                    );
                                                  }

                                                  panelCubit.updateBook(
                                                    bookId: snapshot
                                                        .data!.docs[index].id,
                                                    newAuthor: panelCubit
                                                            .authorNameController
                                                            .text
                                                            .isEmpty
                                                        ? book['author']
                                                        : panelCubit
                                                            .authorNameController
                                                            .text,
                                                    newImage: imageUrl ??
                                                        book['imageUrl'],
                                                    newPdf: pdfUrl ??
                                                        book['pdfLink'],
                                                    newAudio: audioUrl ??
                                                        book['audioLink'],
                                                    newCat: panelCubit
                                                            .categoryController
                                                            .text
                                                            .isEmpty
                                                        ? book['category']
                                                        : panelCubit
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
            },
          ),
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
                                fileBytes: panelCubit.pdfFile!['bytes'],
                                contentType: 'application/pdf');
                            print('ddfdfd');
                          }
                          if (panelCubit.audioFile != null) {
                            audioUrl = await panelCubit.uploadFile(
                              dirName: 'audio',
                              fileName: panelCubit.audioFile!['name'],
                              fileBytes: panelCubit.audioFile!['bytes'],
                              contentType: 'audio/mpeg',
                            );
                          }
                          if (panelCubit.imageFile != null) {
                            imageUrl = await panelCubit.uploadFile(
                                dirName: 'images',
                                fileName: panelCubit.imageFile!['name'],
                                fileBytes: panelCubit.imageFile!['bytes'],
                                contentType: 'image/jpeg');
                          }

                          panelCubit.addBook(
                            Book(
                              author: panelCubit.authorNameController.text,
                              category: panelCubit.categoryController.text,
                              imageUrl: imageUrl,
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
    return InkWell(
      onTap: () {
        // PanelCubit.get(context).fetchNetworkImage('https://firebasestorage.googleapis.com/v0/b/book-c20bd.appspot.com/o/images%2F165417849-dc4db28e-827a-4071-afaf-c3614c1ffb49.png?alt=media&token=f76f7337-c703-42ad-baac-d0f4da060ecd');
      },
      child: AspectRatio(
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
      ),
    );
  }
}
