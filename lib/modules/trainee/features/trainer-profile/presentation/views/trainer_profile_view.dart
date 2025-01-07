import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/my_trainer_controller.dart';
import 'package:studiosync/modules/trainee/features/profile/presentation/controllers/trainee_controller.dart';
import 'package:studiosync/modules/trainee/features/trainer-profile/presentation/controllers/trainer_profile_controller.dart';
import 'package:studiosync/core/presentation/widgets/general/app_bar_profile.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_container.dart';
import 'package:studiosync/core/presentation/widgets/general/custom_image.dart';
import 'package:studiosync/core/presentation/widgets/general/custome_bttn.dart';
import 'package:studiosync/modules/trainer/features/profile/data/models/trainer_model.dart';

class TrainerProfileView extends GetView<TrainerProfileController> {
  final TrainerModel trainerModel;
  final MyTrainerController myTrainerController = Get.find();
  final TraineeController traineeController = Get.find();

  TrainerProfileView({super.key, required this.trainerModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backGrey2,
      body: Stack(
        children: [
          Column(
            children: [
              AppBarProfileWidget(
                rectangleHeight: 120.h,
                imageUrl: trainerModel.imgUrl ?? '',
                borderColor: AppStyle.softOrange,
              ),
              AppStyle.h(10.h),
              _buildTrainerInfo(),
              AppStyle.h(20.h),
              Expanded(
                child: _buildProfileContent(),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              bool isMyTrainer = traineeController.trainee.value?.trainerID ==
                      trainerModel.userId ||
                  myTrainerController.myTrainer.value != null;
              print('isMyTrainer $isMyTrainer');
              return Padding(
                padding: EdgeInsets.all(20.w),
                child: CustomButton(
                  text: isMyTrainer ? 'Disconnect' : 'Join',
                  fill: true,
                  color: isMyTrainer ? Colors.red : AppStyle.deepOrange,
                  width: Get.width,
                  onTap: () {
                    if (isMyTrainer) {
                      myTrainerController
                          .disconnectTrainer(traineeController.trainee.value!);
                      traineeController.trainee.value!.trainerID = '';
                      traineeController.trainee.refresh();
                    } else {
                      controller.sendRequest(trainerModel.userId,
                          traineeController.trainee.value!);
                    }
                  },
                  isLoading: controller.isLoading.value,
                ),
              );
            }),
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
              SizedBox(
                width: 120.w,
                child: Text(
                  '${trainerModel.userFullName}  |  ${trainerModel.userAge}',
                  style: TextStyle(
                    color: AppStyle.softBrown,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
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
      padding: EdgeInsets.all(20.w),
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
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppStyle.deepBlackOrange.withOpacity(0.7),
                ),
                AppStyle.w(10.w),
                Text(
                  'About',
                  style: TextStyle(
                    color: AppStyle.deepBlackOrange.withOpacity(0.7),
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () =>
                      controller.openUrl(trainerModel.instagramLink),
                  icon: Icon(
                    Icons.facebook,
                    color: AppStyle.deepBlackOrange.withOpacity(0.7),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.phone,
                    color: AppStyle.deepBlackOrange.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            AppStyle.h(15.h),
            CustomContainer(
              text: trainerModel.about,
            ),
            AppStyle.h(15.h),
            _buildSection(
              'Trainees',
              Icons.emoji_people_outlined,
              CustomContainer(
                padding: const EdgeInsets.all(10),
                width: Get.width,
                child: FutureBuilder<int>(
                  future:
                      controller.countTraineesOfTrainer(trainerModel.userId),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // הצגת Loader בזמן שממתינים לתוצאה
                      return const LinearProgressIndicator();
                    } else if (snapshot.hasError) {
                      // הצגת הודעת שגיאה אם משהו השתבש
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // הצגת המספר שחזר מהפונקציה
                      return Text(
                        '${snapshot.data?.toString()} trainees in this studio',
                        style: TextStyle(
                            fontSize: 16.sp, color: AppStyle.softBrown),
                      );
                    }
                  },
                ),
              ),
            ),
            trainerModel.lessonsTypeList.isNotEmpty
                ? _buildSection(
                    'Services',
                    Icons.fitness_center,
                    _buildListContainer(trainerModel.lessonsTypeList),
                  )
                : const SizedBox(),
            trainerModel.coachesList.isNotEmpty
                ? _buildSection(
                    'Trainers',
                    Icons.people,
                    _buildListContainer(trainerModel.coachesList),
                  )
                : const SizedBox(),
            trainerModel.priceList.isNotEmpty
                ? _buildSection(
                    'Prices',
                    Icons.payment,
                    _buildPriceListContainer(),
                  )
                : const SizedBox(),
            trainerModel.imageUrls!.isNotEmpty
                ? _buildSection(
                    'Images',
                    Icons.image,
                    _buildImagesContainer(),
                  )
                : const SizedBox(),
            SizedBox(height: 20.h),
            Obx(() {
              return CustomButton(
                text: traineeController.trainee.value!.trainerID ==
                        trainerModel.userId
                    ? 'Disconnect'
                    : 'Join',
                fill: true,
                color: traineeController.trainee.value!.trainerID ==
                        trainerModel.userId
                    ? Colors.red
                    : AppStyle.deepOrange.withOpacity(0.8),
                width: Get.width,
                onTap: () {
                  if (traineeController.trainee.value!.trainerID ==
                      trainerModel.userId) {
                    myTrainerController
                        .disconnectTrainer(traineeController.trainee.value!);
                  } else {
                    controller.sendRequest(
                        trainerModel.userId, traineeController.trainee.value!);
                  }
                },
                isLoading: Get.find<TraineeController>().isLoading.value,
              );
            }),
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
            Icon(icon, color: AppStyle.deepBlackOrange),
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
