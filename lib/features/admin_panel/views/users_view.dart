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
        PanelCubit authCubit = PanelCubit.get(context);
        return  Scaffold(
          appBar: AppBar(
            title: const Text('Admin Panel'),
          ),
          drawer: CustomDrawer(),

          body: Center(
            child: Text('Users'),
          ),
        );
      },
    );
  }
}
