import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:personal_project/src/views/widgets/text.dart';

import '../../utils/values/app_assets.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({super.key, this.message});

  final String? message;
    @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      //  mainAxisSize: MainAxisSize.min,
      // spacing: defaultPadding / 4,
      children: [
        Lottie.asset(
          AppAssets.noDataLottie,),
        CustomTextBody(text: message ?? 'No Data Found'),
      ],
    );
  }
}
