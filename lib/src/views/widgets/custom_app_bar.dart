import 'package:flutter/material.dart';
import 'package:personal_project/src/views/widgets/custom_back_button.dart';
import 'package:personal_project/src/views/widgets/text.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? elevation;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final TextStyle? titleStyle;
  final double? titleSpacing;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.backgroundColor,
    this.titleColor,
    this.elevation,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.titleStyle,
    this.titleSpacing,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      child: AppBar(
    backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.onSecondary,
    centerTitle: centerTitle,
    elevation: elevation ?? 0,
    titleSpacing: titleSpacing,
    automaticallyImplyLeading: automaticallyImplyLeading,

    title: CustomTextBody(
      text: title,
      isBold: true,
    ),

    leading: leading ??
        (automaticallyImplyLeading
            ? CustomBackButtonWidget(
                color: Theme.of(context).colorScheme.shadow,
              )
            : null),

    actions: actions,

    iconTheme: IconThemeData(
      color: titleColor ?? Colors.white,
    ),
  )
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
