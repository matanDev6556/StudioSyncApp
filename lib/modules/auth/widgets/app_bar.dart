import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/modules/auth/widgets/logo.dart';

class AppBarAuth extends StatelessWidget {
  final BuildContext context;
  final double toolBarHeight;
  final bool back;
  final double? widthLogo;

  const AppBarAuth({
    super.key,
    this.widthLogo,
    required this.context,
    required this.toolBarHeight,
    required this.back,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Align(
        alignment: Alignment.topLeft,
        child: Visibility(
          visible: back ? true : false,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      toolbarHeight: toolBarHeight,
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(65),
          bottomRight: Radius.circular(65),
        ),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/image_login.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 4.0,
              sigmaY: 4.0,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
      title: Center(
        widthFactor: 0.9.w,
        child: Logo(
          widht: widthLogo?.w ?? 250.w,
        ),
      )
          .animate()
          .moveY(begin: -300, duration: const Duration(seconds: 1))
          .flip()
          .fade(),
    );
  }
}
