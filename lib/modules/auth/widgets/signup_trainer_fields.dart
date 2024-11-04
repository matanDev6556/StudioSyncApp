import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/auth/controllers/signup_trainer_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/consts_lessons.dart';
import 'package:studiosync/shared/widgets/custom_text_field.dart';
import 'package:studiosync/shared/widgets/custom_dropdown.dart';
import 'package:studiosync/shared/widgets/list_of_strings.dart';
import 'package:studiosync/shared/widgets/title_with_bttn.dart';
import 'package:studiosync/modules/trainer/models/price_tier_model.dart';

class SignUpTrainerFields extends StatelessWidget {
  final controller = Get.find<SignUpTrainerController>();
  SignUpTrainerFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ABOUT ME FIELD
              CustomTextField(
                icon: const Icon(Icons.abc),
                hintText: 'About me',
                hintColor: AppStyle.backGrey3,
                fill: true,
                color: AppStyle.backGrey2,
                maxLines: 5,
                onChanged: (val) => controller.updateAbout(val),
                validator: (valid) {
                  return Validations.validateEmptey(valid, 'About Me');
                },
              ),
              AppStyle.h(15.h),

              CustomTextField(
                icon: const Icon(Icons.link),
                hintText: 'instagram link',
                hintColor: AppStyle.backGrey3,
                fill: true,
                color: AppStyle.backGrey2,
                maxLines: 1,
                onChanged: (val) => controller.updateInstegramLing(val),
                validator: (val) => null,
              ),
              AppStyle.h(15.h),
              Divider(thickness: 1, color: AppStyle.backGrey2),

              // PRICES SECTION
              TitleWithAddBttn(
                title: 'Prices',
                addBttn: () {
                  controller.addPrice();
                },
              ),
              const PriceFields(),
              controller.priceList.isNotEmpty
                  ? PriceListContainer(
                      list: controller.priceList,
                    )
                  : const SizedBox(),

              AppStyle.h(15.h),
              Divider(thickness: 2, color: AppStyle.backGrey2),

              // LOCATIONS SECTION
              TitleWithAddBttn(
                title: 'Location',
                addBttn: () {
                  if (controller.location.isNotEmpty) {
                    controller.addLocation(controller.location.value);
                  } else {
                    Validations.showValidationSnackBar(
                      'Location is emptey',
                      Colors.red,
                    );
                  }
                },
              ),
              CustomTextField(
                icon: const Icon(Icons.location_on),
                hintText: 'Location',
                hintColor: AppStyle.backGrey3,
                fill: true,
                color: AppStyle.backGrey2,
                maxLines: 1,
                onChanged: (val) => controller.location.value = val,
                validator: (val) => null,
              ),
              AppStyle.h(6.h),

              controller.locationsList.isNotEmpty
                  ? ListOfStrings(
                      list: controller.locationsList,
                      onTapDelete: (index) {
                        controller.deleteLocation(index);
                      },
                    )
                  : const SizedBox(),
              AppStyle.h(15.h),
              Divider(
                thickness: 2,
                color: AppStyle.backGrey2,
              ),

              //BTTN ADD TYPE LESSON
              TitleWithAddBttn(
                title: 'Services',
                addBttn: () {
                  if (controller.service.isNotEmpty) {
                    controller.addService();
                  }
                },
              ),
              CustomDropDown<String>(
                icon: const Icon(Icons.settings_accessibility),
                hintText: 'Yuga for example',
                color: AppStyle.backGrey2,
                items: ConstsLessons.lessonsType,
                itemLabelBuilder: (item) => item,
                onChanged: (val) {
                  controller.service.value = val!;
                },
              ),
              AppStyle.h(6.h),
              controller.lessonsTypeList.isNotEmpty
                  ? ListOfStrings(
                      onTapDelete: (index) => controller.deleteService(index),
                      list: controller.lessonsTypeList,
                    )
                  : const SizedBox(),

              //BTTN ADD SUB TRAINER
              TitleWithAddBttn(
                title: 'Trainers',
                addBttn: () {
                  if (controller.subTrainerName.isNotEmpty) {
                    controller.addSubTrainer();
                  }
                },
              ),
              //TEXTFIELD SUBTRAinER
              CustomTextField(
                icon: const Icon(Icons.settings_accessibility),
                hintText: 'Full Name',
                hintColor: AppStyle.backGrey3,
                fill: true,
                color: AppStyle.backGrey2,
                maxLines: 1,
                onChanged: (val) {
                  controller.subTrainerName.value = val;
                },
              ),
              AppStyle.h(6.h),

              //LIST SUB TRAINERS
              controller.coachesList.isNotEmpty
                  ? ListOfStrings(
                      onTapDelete: (index) =>
                          controller.deleteSubTrainer(index),
                      list: controller.coachesList,
                    )
                  : const SizedBox(),

              // ***********************
              AppStyle.h(15.h),
              Divider(
                thickness: 2,
                color: AppStyle.backGrey2,
              ),
              AppStyle.h(15.h),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceFields extends StatelessWidget {
  const PriceFields({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignUpTrainerController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          AppStyle.w(8.w),
          Expanded(
            child: CustomTextField(
              icon: const Icon(Icons.description),
              hintText: 'Description',
              hintColor: AppStyle.backGrey3,
              fill: true,
              color: AppStyle.backGrey2,
              maxLines: 1,
              onChanged: (newVal) {
                controller.description.value = newVal;
              },
              validator: (valid) {
                return Validations.validateEmptey(valid, 'Description');
              },
            ),
          ),
          AppStyle.w(15.w),
          Expanded(
            child: CustomTextField(
              icon: const Icon(Icons.price_change),
              hintText: 'Price',
              hintColor: AppStyle.backGrey3,
              fill: true,
              color: AppStyle.backGrey2,
              maxLines: 1,
              onChanged: (val) =>
                  controller.price.value = double.tryParse(val) ?? 0.0,
              validator: (valid) {
                return Validations.validOnlyNumbers(valid!, 'Price');
              },
            ),
          ),
        ],
      ),
    );
  }
}

// LIST OF PRICES , DELETE BTTN
class PriceListContainer extends StatelessWidget {
  final controller = Get.find<SignUpTrainerController>();
  PriceListContainer({super.key, required this.list});

  final List<PriceTier> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppStyle.backGrey2,
        borderRadius: BorderRadius.circular(15),
      ),
      height: 100,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: list.length,
        itemBuilder: (context, index) {
          PriceTier p = list[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                p.description,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.backGrey3,
                ),
              ),
              Text(
                p.price.toString(),
                style: TextStyle(
                  fontSize: 17.sp,
                  color: AppStyle.backGrey3,
                ),
              ),
              GestureDetector(
                onTap: () => controller.deletePrice(p),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
