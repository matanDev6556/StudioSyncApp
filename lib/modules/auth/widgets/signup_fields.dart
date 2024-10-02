import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/auth/widgets/app_bar.dart';
import 'package:studiosync/modules/auth/widgets/shared_fields.dart';
import 'package:studiosync/core/shared/widgets/custome_bttn.dart';

class GeneralSignUpForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  // IMAGE PROP
  final Function onTapSelectImg;
  final bool isImgLoading;
  final String imgPath;

  // FIELDS PROP
  final Function(String) onChangeEmail;
  final Function(String) onChangePass;
  final Function(String) onChangeFullName;
  final Function(String) onChangePhone;
  final Function(String) onChangeCity;
  final Function(double) onChangeAge;
  final Function onTapNext;

  // Add the trainer form to general only for trainer sign up
  final Widget? trainerForm;

  // Determine if the user is a trainer
  final bool isTrainer;

  const GeneralSignUpForm({
    super.key,
    required this.formKey,
    required this.onTapSelectImg,
    required this.isImgLoading,
    required this.imgPath,
    required this.onChangeEmail,
    required this.onChangePass,
    required this.onChangeFullName,
    required this.onChangePhone,
    required this.onChangeCity,
    required this.onChangeAge,
    required this.trainerForm,
    required this.isTrainer,
    required this.onTapNext,
  });

  @override
  _GeneralSignUpFormState createState() => _GeneralSignUpFormState();
}

class _GeneralSignUpFormState extends State<GeneralSignUpForm> {
  bool showTrainerForm = false;
  String title = 'Sign up';

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // APP BAR
        SizedBox(
          height: 0.6.sh,
          child: AppBarAuth(
            context: context,
            toolBarHeight: 0.15.sh,
            back: true,
            widthLogo: 150.w,
          ),
        ),

        // Center the container
        Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            height: MediaQuery.of(context).size.height * 0.68,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 27),
              child: SingleChildScrollView(
                child: Form(
                  key: widget.formKey,
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.sp,
                          color: AppStyle.deepBlackOrange,
                        ),
                      ),
                      if (showTrainerForm)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //show back if we in the trainer form
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: AppStyle.backGrey3,
                              ),
                              onPressed: () {
                                setState(() {
                                  showTrainerForm = false;
                                  title = 'Sign Up';
                                });
                              },
                            ),
                          ],
                        ),

                      // Show basic fields only if not in trainer form mode
                      if (!showTrainerForm) ...[
                        SharedSignUpFields(
                          imgPath: widget.imgPath,
                          isImgLoading: widget.isImgLoading,
                          onTapSelectImg: widget.onTapSelectImg,
                          onChangeEmail: widget.onChangeEmail,
                          onChangePass: widget.onChangePass,
                          onChangeFullName: widget.onChangeFullName,
                          onChangePhone: widget.onChangePhone,
                          onChangeCity: widget.onChangeCity,
                          onChangeAge: widget.onChangeAge,
                        )
                      ],

                      // Show trainer form only if user is a trainer and clicked "Next"
                      if (widget.isTrainer && showTrainerForm) ...[
                        widget.trainerForm!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // BUTTON POSITIONED
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.05,
          left: MediaQuery.of(context).size.width * 0.25,
          child: !widget.isImgLoading
              ? CustomButton(
                  text: showTrainerForm ? 'Submit' : 'Next',
                  fill: true,
                  color: AppStyle.deepOrange,
                  height: 48.h,
                  width: MediaQuery.of(context).size.width * 0.5,
                  onTap: () {
                    if (widget.isTrainer &&
                        widget.formKey.currentState != null &&
                        widget.formKey.currentState!.validate()) {
                      if (!showTrainerForm) {
                        setState(() {
                          showTrainerForm = true; // Show the trainer form
                          title = 'Trainer Info';
                        });
                      } else {
                        // Handle trainer form submission
                        widget.onTapNext();
                      }
                    } else if (!widget.isTrainer &&
                        widget.formKey.currentState != null &&
                        widget.formKey.currentState!.validate()) {
                      // Submit for trainee
                      widget.onTapNext();
                    }
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ],
    );
  }
}
