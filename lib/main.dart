import 'package:dio/dio.dart';
import 'package:ebook_web/features/admin_panel/view_model/panel_cubit.dart';
import 'package:ebook_web/features/admin_panel/views/books_view.dart';
import 'package:ebook_web/features/admin_panel/views/panel_view.dart';
import 'package:ebook_web/features/auth/views/login_view.dart';
import 'package:ebook_web/features/auth/views/register_view.dart';
import 'package:ebook_web/shared/cache_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/view_model/auth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyDCCZkFbvyhZkXJrB_12cKuiH3tMxVcvTw",
    authDomain: "book-c20bd.firebaseapp.com",
    projectId: "book-c20bd",
    storageBucket: "book-c20bd.appspot.com",
    messagingSenderId: "671786009475",
    appId: "1:671786009475:web:a652c626993d0068cd2cb6",
    measurementId: "G-JCPJG3JY4K",
  ));

  String? uId =await  CacheHelper.getData(key: 'uId');
  Widget startView = PanelView();
  if (uId != null) {
    startView = PanelView();
  } else {
    startView = RegisterView();
  }
  runApp(MyApp(startWidget: startView));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.startWidget});

  final startWidget;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),

        BlocProvider(
          create: (context) => PanelCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          // scaffoldBackgroundColor: AppUI.whiteColor,
        ),
        home: BooksView(),
      ),
    );
  }
}
