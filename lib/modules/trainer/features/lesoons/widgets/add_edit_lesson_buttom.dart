import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_lessons_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/model/lesson_model.dart';
import 'package:studiosync/core/presentation/widgets/custom_container.dart';
import 'package:studiosync/core/presentation/widgets/custom_dropdown.dart';
import 'package:studiosync/core/presentation/widgets/custom_text_field.dart';
import 'package:studiosync/core/presentation/widgets/custome_bttn.dart';

class LessonEditBottomSheet extends StatefulWidget {
  final LessonModel? lesson;
  final Function(LessonModel) onSave;
  final String title;

  const LessonEditBottomSheet({
    Key? key,
    this.lesson,
    required this.onSave,
    required this.title,
  }) : super(key: key);

  @override
  _LessonEditBottomSheetState createState() => _LessonEditBottomSheetState();
}

class _LessonEditBottomSheetState extends State<LessonEditBottomSheet> {
  late LessonModel _editingLesson;
  final _formKey = GlobalKey<FormState>();
  final controler = Get.find<TrainerLessonsController>();

  @override
  void initState() {
    super.initState();
    _editingLesson = widget.lesson?.copyWith() ?? LessonModel.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.85,
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: AppStyle.deepBlackOrange,
                  fontSize: 23.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AppStyle.h(20.h),
            _titleText('Lesson type'),
            AppStyle.h(5.h),
            CustomDropDown(
              color: AppStyle.softOrange.withOpacity(0.2),
              textColor: AppStyle.softBrown.withOpacity(0.6),
              initialValue: controler
                      .trainerController.trainer.value!.lessonsTypeList
                      .contains(_editingLesson.typeLesson)
                  ? _editingLesson.typeLesson
                  : null,
              items: controler.trainerController.trainer.value!.lessonsTypeList,
              onChanged: (val) =>
                  _editingLesson = _editingLesson.copyWith(typeLesson: val),
              itemLabelBuilder: (item) => item,
            ),
            AppStyle.h(10.h),
            _titleText('Trainer'),
            AppStyle.h(5.h),
            CustomDropDown(
              color: AppStyle.softOrange.withOpacity(0.2),
              textColor: AppStyle.softBrown.withOpacity(0.6),
              initialValue: controler
                      .trainerController.trainer.value!.coachesList
                      .contains(_editingLesson.trainerName)
                  ? _editingLesson.trainerName
                  : null,
              onChanged: (val) =>
                  _editingLesson = _editingLesson.copyWith(trainerName: val),
              items: controler.trainerController.trainer.value!.coachesList,
              itemLabelBuilder: (item) => item,
            ),
            AppStyle.h(10.h),
            _titleText('Location'),
            AppStyle.h(5),
            CustomDropDown(
              color: AppStyle.softOrange.withOpacity(0.2),
              textColor: AppStyle.softBrown.withOpacity(0.6),
              initialValue: controler
                      .trainerController.trainer.value!.locationsList
                      .contains(_editingLesson.location)
                  ? _editingLesson.location
                  : null,
              onChanged: (val) =>
                  _editingLesson = _editingLesson.copyWith(location: val),
              items: controler.trainerController.trainer.value!.locationsList,
              itemLabelBuilder: (item) => item,
            ),
            AppStyle.h(10.h),
            _titleText('Limit'),
            AppStyle.h(5),
            CustomTextField(
              initialValue: widget.lesson != null
                  ? _editingLesson.limitPeople.toString()
                  : null,
              hintText: 'Trainees limit',
              hintColor: AppStyle.softBrown.withOpacity(0.6),
              fill: true,
              color: AppStyle.softOrange.withOpacity(0.2),
              onChanged: (val) => _editingLesson =
                  _editingLesson.copyWith(limitPeople: int.tryParse(val)),
              keyboardType: TextInputType.number,
              validator: (p0) => Validations.validOnlyNumbers(p0, 'limit'),
            ),
            AppStyle.h(10.h),
            _titleText('Date and time'),
            AppStyle.h(5),
            CustomContainer(
              child: ListTile(
                title: Text(
                  'Start: ${DateFormat('dd/MM/yyyy HH:mm').format(_editingLesson.startDateTime)}',
                  style: TextStyle(
                    color: AppStyle.softBrown,
                  ),
                ),
                onTap: () => _selectDateAndTimes(context),
              ),
            ),
            AppStyle.h(5),
            CustomContainer(
              child: ListTile(
                title: Text(
                  'Finish: ${DateFormat('dd/MM/yyyy HH:mm ').format(_editingLesson.endDateTime)}',
                  style: TextStyle(
                    color: AppStyle.softBrown,
                  ),
                ),
                onTap: () => _selectDateAndTimes(context),
              ),
            ),
            AppStyle.h(30.h),
            CustomButton(
              text: widget.lesson == null ? 'Add' : 'Save',
              fill: true,
              color: AppStyle.deepBlackOrange,
              width: Get.width * 0.6,
              onTap: () => _saveLesson(),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateAndTimes(BuildContext context) async {
    // שלב 1: בחר תאריך
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _editingLesson.startDateTime, // או תאריך אחר לפי הצורך
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // שלב 2: בחר שעת התחלה
      final TimeOfDay? pickedStartTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_editingLesson.startDateTime),
      );

      if (pickedStartTime != null) {
        // שלב 3: בחר שעת סיום
        final TimeOfDay? pickedEndTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_editingLesson.endDateTime),
        );

        if (pickedEndTime != null) {
          setState(() {
            // עדכן את התאריך והשעות במודל
            _editingLesson = _editingLesson.copyWith(
              startDateTime: DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedStartTime.hour,
                pickedStartTime.minute,
              ),
              endDateTime: DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedEndTime.hour,
                pickedEndTime.minute,
              ),
            );
          });
        }
      }
    }
  }

  String validateLesson(LessonModel? lesson) {
    if (lesson == null) return 'Error!';

    if (lesson.typeLesson.isEmpty) {
      return 'Pick type!';
    }
    if (lesson.location.isEmpty) {
      return 'Pick location!';
    }
    if (lesson.trainerName.isEmpty) {
      return 'Pick trainer!';
    }
    return '';
  }

  void _saveLesson() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String validMsg = validateLesson(_editingLesson);
      if (validMsg == '') {
        widget.onSave(_editingLesson);
      } else {
        Validations.showValidationSnackBar(validMsg, Colors.red);
      }

      Get.back();
    }
  }
}

Align _titleText(String text) {
  return Align(
    alignment: Alignment.topLeft,
    child: Text(
      text,
      style: TextStyle(
        fontSize: 17,
        color: AppStyle.softBrown,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
