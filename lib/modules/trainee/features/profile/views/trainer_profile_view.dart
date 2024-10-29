import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/modules/trainer/models/trainer_model.dart';
import 'package:studiosync/shared/widgets/app_bar_profile.dart';
import 'package:studiosync/shared/widgets/custom_container.dart';
import 'package:studiosync/shared/widgets/custom_image.dart';
import 'package:studiosync/shared/widgets/custome_bttn.dart';

class TrainerProfileView extends StatelessWidget {
  final TrainerModel trainerModel;

  const TrainerProfileView({Key? key, required this.trainerModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backGrey2,
      body: Column(
        children: [
          AppBarProfileWidget(
            rectangleHeight: 120.h,
            imageUrl: trainerModel.imgUrl ?? '',
            borderColor: AppStyle.softOrange,
          ),
          _buildTrainerInfo(),
          Expanded(
            child: _buildProfileContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.phone, color: AppStyle.softBrown),
              ),
              Text(
                trainerModel.userFullName,
                style: TextStyle(
                  color: AppStyle.softBrown,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppStyle.softBrown),
              Text(
                trainerModel.userCity,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppStyle.softBrown,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
                'About',
                Icons.info_outline,
                CustomContainer(
                  padding: const EdgeInsets.all(10),
                  width: Get.width,
                  text: trainerModel.about,
                )),
            _buildSection('Services', Icons.fitness_center,
                _buildListContainer(trainerModel.lessonsTypeList)),
            _buildSection('Trainers', Icons.people,
                _buildListContainer(trainerModel.coachesList)),
            _buildSection('Prices', Icons.payment, _buildPriceListContainer()),
            _buildSection('Images', Icons.image, _buildImagesContainer()),
            SizedBox(height: 20.h),
            CustomButton(
              text: 'Join',
              fill: true,
              color: AppStyle.deepOrange,
              width: Get.width,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppStyle.softOrange),
            SizedBox(width: 10.w),
            Text(
              title,
              style: TextStyle(
                color: AppStyle.deepBlackOrange,
                fontWeight: FontWeight.bold,
                fontSize: 17.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        content,
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget _buildListContainer(List<String> items) {
    return CustomContainer(
      padding: const EdgeInsets.all(10),
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) => _buildListItem(item)).toList(),
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: AppStyle.deepBlackOrange,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppStyle.softBrown,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceListContainer() {
    return CustomContainer(
      padding: const EdgeInsets.all(10),
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: trainerModel.priceList
            .map((item) =>
                _buildListItem('${item.description} - ${item.price}₪'))
            .toList(),
      ),
    );
  }

  Widget _buildImagesContainer() {
    return CustomContainer(
      padding: const EdgeInsets.all(10),
      width: Get.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: trainerModel.imageUrls
                  ?.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: CustomImageWidget(
                          imageUrl: item,
                          height: 100,
                          width: 100,
                          borderColor: AppStyle.deepBlackOrange,
                        ),
                      ))
                  .toList() ??
              [],
        ),
      ),
    );
  }
}
