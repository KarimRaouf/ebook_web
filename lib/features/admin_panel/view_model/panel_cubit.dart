import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebook_web/features/admin_panel/view_model/panel_state.dart';
import 'package:ebook_web/features/auth/view_model/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_util.dart';


class PanelCubit extends Cubit<PanelState> {
  PanelCubit() : super(PanelInitial());


  static PanelCubit get(context) => BlocProvider.of(context);




}
