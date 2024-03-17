import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_web/core/utils/app_ui.dart';
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
import 'books_view.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PanelCubit, PanelState>(
      listener: (context, state) {},
      builder: (context, state) {
        PanelCubit panelCubit = PanelCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Users'),
          ),
          drawer: CustomDrawer(),
          body: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
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
                    final bool isDesktop = constraints.maxWidth > 800;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          columnSpacing: isDesktop ? 100 : 40,
                          // Adjust the spacing based on the screen width
                          columns: const <DataColumn>[
                            DataColumn(
                                label: Text('Email',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Status',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('Actions',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: List<DataRow>.generate(
                            snapshot.data!.docs.length,
                            // Number of registrations
                            (index) {
                              // var users = snapshot.data!.docs[index];

                              return DataRow(
                                cells: <DataCell>[
                                  if (snapshot.data!.docs[index]['status'] ==
                                      'Requested') ...[
                                    DataCell(
                                      Text(
                                          '${index + 1}. ${snapshot.data!.docs[index]['email']}'),
                                    ),

                                    // const DataCell(Text('Pending')),
                                    DataCell(Text(
                                      snapshot.data!.docs[index]['status'],
                                      style: Styles.textStyle14.copyWith(
                                          color: snapshot.data!.docs[index]
                                                      ['status'] ==
                                                  'Accepted'
                                              ? Colors.green
                                              : Colors.redAccent,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    DataCell(
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.check,
                                                color: Colors.green),
                                            onPressed: () {
                                              panelCubit.updateUserStatus(
                                                  userId: snapshot
                                                      .data!.docs[index]['uId'],
                                                  status: 'Accepted');
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.close,
                                                color: Colors.red),
                                            onPressed: () {
                                              panelCubit.updateUserStatus(
                                                  userId: snapshot
                                                      .data!.docs[index]['uId'],
                                                  status: 'Rejected');
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ] else ...[
                                    DataCell(
                                      Text(
                                        'No Requests',
                                        style: Styles.textStyle14.copyWith(
                                            color: AppUI.blackColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
        );
      },
    );
  }
}
