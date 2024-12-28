import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainer/features/lesoons/consts_lessons.dart';
import 'package:studiosync/modules/trainer/models/price_tier_model.dart';
import 'package:studiosync/core/presentation/widgets/custom_dropdown.dart';
import 'package:studiosync/core/presentation/widgets/custom_text_field.dart';
import 'package:studiosync/core/presentation/widgets/custome_bttn.dart';

void showAddItemBottomSheet(String listType, Function(dynamic) onAdd) {
  String inputText = '';
  double inputPrice = 0.0;
  String selectedService = ConstsLessons.lessonsType[0];

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            listType == 'services'
                ? 'Add New Service'
                : listType == 'string'
                    ? 'Add New Item'
                    : 'Add New Price',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppStyle.deepOrange,
            ),
          ),
          const SizedBox(height: 16),
          if (listType == 'services') ...[
            CustomDropDown<String>(
              icon: Icon(
                Icons.fitness_center,
                color: AppStyle.softOrange,
              ),
              color: AppStyle.backGrey,
              textColor: AppStyle.softBrown,
              initialValue: selectedService,
              onChanged: (newVal) {
                if (newVal != null) {
                  selectedService = newVal;
                }
              },
              items: ConstsLessons.lessonsType,
              itemLabelBuilder: (service) => service,
            ),
          ] else if (listType == 'string') ...[
            CustomTextField(
              icon: Icon(Icons.text_fields, color: AppStyle.backGrey3),
              hintText: 'Enter Item',
              hintColor: AppStyle.softBrown.withOpacity(0.6),
              fill: true,
              color: AppStyle.backGrey,
              onChanged: (value) {
                inputText = value;
              },
            ),
          ] else if (listType == 'prices') ...[
            CustomTextField(
              icon: Icon(Icons.description, color: AppStyle.backGrey3),
              hintText: 'Description',
              hintColor: AppStyle.softBrown.withOpacity(0.6),
              fill: true,
              color: AppStyle.backGrey,
              onChanged: (value) {
                inputText = value;
              },
            ),
            const SizedBox(height: 12), // Spacing between fields
            CustomTextField(
              icon: Icon(Icons.attach_money, color: AppStyle.backGrey3),
              hintText: 'Price',
              hintColor: AppStyle.softBrown.withOpacity(0.6),
              fill: true,
              color: AppStyle.backGrey,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                inputPrice = double.tryParse(value) ?? 0.0;
              },
            ),
          ],
          const SizedBox(height: 20),
          CustomButton(
            text: 'Add',
            fill: true,
            color: AppStyle.deepOrange,
            onTap: () {
              if (listType == 'services') {
                
                onAdd(selectedService);
              } else if (listType == 'string') {
                onAdd(inputText);
              } else {
                onAdd(PriceTier(description: inputText, price: inputPrice));
              }
              Get.back();
            },
            width: Get.width * 0.5,
          ),
        ],
      ),
    ),
  );
}
