import 'package:gnu_mot_t/component/basic_text.dart';
import 'package:gnu_mot_t/component/common/asset_widget.dart';
import 'package:flutter/material.dart';
import 'package:gnu_mot_t/constant/assets.dart';
import 'package:gnu_mot_t/constant/colors.dart';

class Navigation extends StatefulWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final String title;
  final bool isBack;
  final Function? backButtonAction;
  final Widget? singleActionWidget;
  final Widget? doubleActionWidget;
  final double? opacity;
  final Widget? bottom;
  final double? bottomHeight;

  const Navigation({
    super.key,
    this.backgroundColor,
    this.title = "",
    this.isBack = true,
    this.backButtonAction,
    this.singleActionWidget,
    this.doubleActionWidget,
    this.opacity,
    this.bottom,
    this.bottomHeight,
  });

  @override
  State<Navigation> createState() => _NavigationState();

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class _NavigationState extends State<Navigation> {

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = widget.backgroundColor ?? AppColors.transparent;
    Widget singleActionWidget = widget.singleActionWidget ?? const SizedBox();
    Widget doubleActionWidget = widget.doubleActionWidget ?? const SizedBox();

    return SafeArea(
      child: AppBar(
        surfaceTintColor: widget.opacity != null
            ? backgroundColor.withOpacity(widget.opacity!)
            : backgroundColor,
        leadingWidth: 36,
        leading: widget.isBack
            ? GestureDetector(
          onTap: () async {
            if (widget.backButtonAction != null) {
              await widget.backButtonAction!(context);
              return;
            }
            Navigator.pop(context);
          },
          child: Container(
              color: AppColors.transparent,
              child: Container(margin: const EdgeInsets.only(left: 12), child: const Icon(Icons.arrow_back, size: 24, color: Color(0xff292D32)))),
        )
            : const SizedBox(),
        centerTitle: true,
        title: BasicText(widget.title, 23, 28, FontWeight.w700),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              doubleActionWidget,
              const SizedBox(
                width: 24,
              ),
              singleActionWidget,
              const SizedBox(width: 20),
            ].whereType<Widget>().toList(),
          )
        ],
        bottom: widget.bottom != null
            ? widget.bottom is PreferredSizeWidget
            ? widget.bottom as PreferredSizeWidget?
            : PreferredSize(
          preferredSize: Size.fromHeight(
            widget.bottomHeight ?? 60,
          ),
          child: widget.bottom!,
        )
            : null,
        backgroundColor: widget.opacity != null
            ? backgroundColor.withOpacity(widget.opacity!)
            : backgroundColor,
        elevation: 0.0,
      ),
    );
  }
}