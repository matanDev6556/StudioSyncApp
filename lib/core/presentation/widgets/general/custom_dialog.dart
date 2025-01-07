import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:studiosync/core/presentation/router/app_router.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

void showCustomDialog({
  required BuildContext context,
  required String animationPath,
  required String title,
  required String msg,
  required String doActionMsg,
  required String cancelActionMsg,
  required VoidCallback onConfirm,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black45,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (BuildContext buildContext, Animation animation,
        Animation secondaryAnimation) {
      return ScaleTransition(
        scale: animation as Animation<double>,
        child: CustomDialog(
          animationPath: animationPath,
          title: title,
          doActionMsg: doActionMsg,
          cancleActionMsg: cancelActionMsg,
          msg: msg,
          onConfirm: onConfirm,
        ),
      );
    },
  );
}


class CustomDialog extends StatelessWidget {
  final String animationPath;
  final String title;
  final String msg;
  final String doActionMsg;
  final String cancleActionMsg;
  final VoidCallback onConfirm;

  const CustomDialog({
    Key? key,
    required this.animationPath,
    required this.doActionMsg,
    required this.cancleActionMsg,
    required this.title,
    required this.msg,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ContentBox(
        animationPath: animationPath,
        title: title,
        msg: msg,
        doActionMsg: doActionMsg,
        cancleActionMsg: cancleActionMsg,
        onConfirm: onConfirm,
      ),
    );
  }
}

class ContentBox extends StatelessWidget {
  final String animationPath;
  final String title;
  final String msg;
  final String doActionMsg;
  final String cancleActionMsg;
  final VoidCallback onConfirm;

  const ContentBox({
    Key? key,
    required this.animationPath,
    required this.doActionMsg,
    required this.cancleActionMsg,
    required this.title,
    required this.msg,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: 20.w, top: 65.h + 20.h, right: 20.w, bottom: 20.h),
          margin: EdgeInsets.only(top: 45.h),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15.h),
              Text(
                msg,
                style: TextStyle(fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 22.h),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        AppRouter.navigateBack();
                      },
                      child: Text(
                        cancleActionMsg,
                        style: TextStyle(
                            fontSize: 18.sp, color: AppStyle.softOrange),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    ElevatedButton(
                      onPressed: () {
                        onConfirm();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: Text(
                        doActionMsg,
                        style: TextStyle(fontSize: 18.sp, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20.w,
          right: 20.w,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45.r,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(45.r)),
              child: Lottie.asset(
                animationPath,
                width: 90.w,
                height: 90.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
