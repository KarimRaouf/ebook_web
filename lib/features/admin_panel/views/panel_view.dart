import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/utils/app_util.dart';
import '../../../core/utils/styles.dart';
import '../../../shared/cache_helper.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../view_model/panel_cubit.dart';
import '../view_model/panel_state.dart';

class PanelView extends StatelessWidget {
  const PanelView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PanelCubit, PanelState>(
      listener: (context, state) {},
      builder: (context, state) {
        PanelCubit authCubit = PanelCubit.get(context);
        return Scaffold(
          body: Center(child: Text('Panel' , style: Styles.textStyle24,)),
        );
      },
    );
  }
}
