import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_web/core/utils/app_util.dart';
import 'package:ebook_web/core/utils/strings.dart';
import 'package:ebook_web/core/utils/styles.dart';
import 'package:ebook_web/features/admin_panel/view_model/panel_cubit.dart';
import 'package:ebook_web/features/admin_panel/view_model/panel_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

// Assuming other imports are correctly placed based on your project structure.

class BooksView extends StatelessWidget {
  const BooksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PanelCubit, PanelState>(
      listener: (context, state) {
        // TODO: implement listener

        if (state is ActivateUserState && PanelCubit.get(context).currentUser?['status'] != null) {
          AppUtil.showToast(message: 'Activation Request Sent');
        }
      },
      builder: (context, state) {
        PanelCubit panelCubit = PanelCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Books'),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('books').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
              if (snap.hasError) {
                return Text('Error: ${snap.error}');
              }

              switch (snap.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snap.error}');
                      }

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        default:
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              int gridCount = constraints.maxWidth > 600
                                  ? 4
                                  : 2; // Responsive grid layout

                              return Column(
                                children: [
                                  if ((panelCubit.currentUser?['status'] == null||
                                      panelCubit.currentUser?['status'] == 'Inactive')&&
                                      panelCubit.isBannerVisible)
                                    Container(
                                      color: Colors.amberAccent,
                                      // Banner background color
                                      width: double.infinity,
                                      // Banner takes full width of the screen
                                      padding: const EdgeInsets.all(16),
                                      // Padding for the banner content
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        // Fit content in the smallest space possible
                                        children: [
                                          const Text(
                                            'Your account is not activated!',
                                            style: Styles.textStyle24,
                                          ),
                                          const SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () async {
                                              panelCubit.closeBanner();
                                              await panelCubit.addRequest();
                                              await panelCubit.updateUserStatus(
                                                userId: uId,
                                                status: 'Requested',
                                              );
                                            },
                                            child: const Text(
                                              'Activate Account',
                                              style: Styles.textStyle16,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .green, // Button background color
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (panelCubit.currentUser?['status'] ==
                                          'Rejected' &&
                                      panelCubit.isBannerVisible)
                                    Container(
                                      color: Colors.redAccent,
                                      // Banner background color
                                      width: double.infinity,
                                      // Banner takes full width of the screen
                                      padding: const EdgeInsets.all(16),
                                      // Padding for the banner content
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        // Fit content in the smallest space possible
                                        children: [
                                          const Text(
                                            'Your Account Is Rejected Make Request again!',
                                            style: Styles.textStyle24,
                                          ),
                                          const SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () async {
                                              panelCubit.closeBanner();
                                              await panelCubit.addRequest();
                                              await panelCubit.updateUserStatus(
                                                userId: uId,
                                                status: 'Requested',
                                              );
                                            },
                                            child: const Text(
                                              'Activate Account',
                                              style: Styles.textStyle16,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .green, // Button background color
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Expanded(
                                    child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: gridCount,
                                        crossAxisSpacing: 20.0,
                                        mainAxisSpacing: 20.0,
                                      ),
                                      itemCount: snap.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        var book = snap.data!.docs[index].data()
                                            as Map<String,
                                                dynamic>; // Safe typecasting

                                        return Card(
                                          elevation: 5,
                                          // Optional: Adds a shadow to the card
                                          margin: const EdgeInsets.all(10),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                CustomBookImage(
                                                  imageUrl: book['imageUrl'] ??
                                                      "https://via.placeholder.com/150", // Placeholder in case the URL is null
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          book['author'] ??
                                                              "No Author",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline6),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                          'Category: ${book['category'] ?? "No Category"}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1),
                                                      const SizedBox(
                                                          height: 16),
                                                      InkWell(
                                                        onTap: () async {
                                                          var status =
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(uId)
                                                                  .get();

                                                          if (status.data()?[
                                                                  'status'] ==
                                                              'Accepted') {
                                                            launchUrlSafe(
                                                              book['pdfLink'],
                                                            );
                                                          }
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                                Icons
                                                                    .picture_as_pdf,
                                                                color:
                                                                    Colors.red),
                                                            const SizedBox(
                                                                width: 8),
                                                            Text(
                                                              'PDF',
                                                              style: Styles.textStyle14.copyWith(
                                                                  color: panelCubit.currentUser?[
                                                                              'status'] !=
                                                                          'Accepted'
                                                                      ? Colors.grey[
                                                                          400]
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      InkWell(
                                                        onTap: () async {
                                                          var status =
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(uId)
                                                                  .get();

                                                          if (status.data()![
                                                                  'status'] ==
                                                              'Accepted') {
                                                            launchUrlSafe(book[
                                                                'audioLink']);
                                                          }
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Icon(
                                                                Icons
                                                                    .audiotrack,
                                                                color: Colors
                                                                    .green),
                                                            const SizedBox(
                                                                width: 8),
                                                            Text(
                                                              'Audio',
                                                              style: Styles.textStyle14.copyWith(
                                                                  color: panelCubit.currentUser?[
                                                                              'status'] !=
                                                                          'Accepted'
                                                                      ? Colors.grey[
                                                                          400]
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                      }
                    },
                  );
              }
            },
          ),
        );
      },
    );
  }

  void launchUrlSafe(String? urlString) async {
    if (urlString == null) return;

    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $urlString');
    }
  }
}

class CustomBookImage extends StatelessWidget {
  final String imageUrl;

  const CustomBookImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5 / 3,
      child: Container(
        decoration: BoxDecoration(
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
