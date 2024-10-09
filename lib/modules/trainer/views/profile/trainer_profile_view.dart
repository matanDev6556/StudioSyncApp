import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/shared/widgets/custom_image.dart';
import 'package:studiosync/shared/widgets/custom_text_field.dart';
import 'package:studiosync/shared/widgets/custome_bttn.dart';
import 'package:studiosync/shared/widgets/custome_dropdown.dart';
import 'package:studiosync/core/theme/app_style.dart';
import 'package:studiosync/core/utils/const.dart';
import 'package:studiosync/core/utils/validations.dart';
import 'package:studiosync/modules/trainer/contollers/trainer_controller.dart';
import 'package:studiosync/modules/trainer/models/price_tier_model.dart';
import 'package:studiosync/modules/trainer/views/profile/widgets/expanded_list.dart';

class TrainerEditProfile extends StatelessWidget {
  TrainerEditProfile({Key? key}) : super(key: key);

  final TrainerController controller = Get.find<TrainerController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      controller.saveTrainerToDb();
    } else {
      Validations.showValidationSnackBar(
          'Fill the requierd fields!', AppStyle.backGrey3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10),
          children: [
            _buildSectionTitle('About me'),
            SizedBox(height: 16.h),
            _buildTextField(
              icon: Icons.person,
              hintText: "Name",
              initialValue: controller.trainer.value!.userFullName,
              onChanged: (newVal) => controller.updateLocalTrainer(
                  controller.trainer.value!.copyWith(userFullName: newVal)),
              validator: (val) => Validations.validateEmptey(val, 'Name'),
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              icon: Icons.email,
              hintText: "Email",
              initialValue: controller.trainer.value!.userEmail,
              onChanged: (newVal) => controller.updateLocalTrainer(
                  controller.trainer.value!.copyWith(userEmail: newVal)),
              validator: (val) => Validations.validateEmail(val),
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              icon: Icons.person,
              hintText: "Age",
              initialValue: controller.trainer.value!.userAge.toString(),
              onChanged: (newVal) => controller.updateLocalTrainer(controller
                  .trainer.value!
                  .copyWith(userAge: int.parse(newVal))),
              validator: (val) => Validations.validateEmptey(val, 'Age'),
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              icon: Icons.email,
              hintText: controller.trainer.value!.instagramLink.isEmpty
                  ? 'Add your Instagram link'
                  : controller.trainer.value!.instagramLink,
              initialValue: controller.trainer.value!.userEmail,
              onChanged: (newVal) => controller.updateLocalTrainer(
                  controller.trainer.value!.copyWith(instagramLink: newVal)),
              validator: null,
            ),
            AppStyle.h(16.h),
            Obx(
              () => CustomDropDown<String>(
                icon: Icon(
                  Icons.location_on_sharp,
                  color: AppStyle.softOrange,
                ),
                color: AppStyle.softOrange.withOpacity(0.1),
                textColor: AppStyle.softBrown,
                initialValue: controller.trainer.value!.userCity,
                onChanged: (newVal) => controller.updateLocalTrainer(
                    controller.trainer.value!.copyWith(userCity: newVal)),
                items: Const.cities,
                itemLabelBuilder: (city) => city,
              ),
            ),
            AppStyle.h(16.h),
            _buildTextField(
              icon: Icons.email,
              hintText: 'About',
              maxLines: 5,
              initialValue: controller.trainer.value!.userEmail,
              onChanged: (newVal) => controller.updateLocalTrainer(
                  controller.trainer.value!.copyWith(about: newVal)),
              validator: (val) => Validations.validateEmptey(val, 'About'),
            ),
            AppStyle.h(16.h),
            CustomButton(
              text: 'Save',
              fill: true,
              color: AppStyle.deepOrange,
              width: Get.width * 0.85,
              onTap: _handleSave,
              isLoading: controller.isLoading.value,
            ),
            AppStyle.h(16.h),
            _buildDivider(),
            _buildSectionTitle('Studio detailes'),
            Obx(() => _buildExpandableList<String>(
                  icon: Icons.location_on_sharp,
                  title: 'Locations',
                  list: controller.trainer.value!.locationsList,
                  itemBuilder: (item) => Text(item),
                  onAddItem: (newItem) => controller.addItemToList(
                      (trainer) => trainer.locationsList, newItem),
                  onRemoveItem: (item) => controller.removeItemFromList(
                      (trainer) => trainer.locationsList, item),
                )),
            Obx(
              () => _buildExpandableList<String>(
                icon: Icons.fitness_center,
                title: 'Services',
                list: controller.trainer.value!.lessonsTypeList,
                itemBuilder: (item) => Text(item),
                onAddItem: (newItem) => controller.addItemToList(
                    (trainer) => trainer.lessonsTypeList, newItem),
                onRemoveItem: (item) => controller.removeItemFromList(
                    (trainer) => trainer.lessonsTypeList, item),
              ),
            ),
            Obx(
              () => _buildExpandableList<String>(
                  icon: Icons.group,
                  title: 'Trainers',
                  list: controller.trainer.value!.coachesList,
                  itemBuilder: (item) => Text(item),
                  onAddItem: (newItem) => controller.addItemToList(
                      (trainer) => trainer.coachesList, newItem),
                  onRemoveItem: (item) => controller.removeItemFromList(
                      (trainer) => trainer.coachesList, item)),
            ),
            Obx(
              () => ExpandableList(
                iconData: Icons.image,
                title: 'Images',
                list: controller.trainer.value!.imageUrls ?? [],
                itemBuilder: (img) => CustomImageWidget(
                  imageUrl: img,
                  width: 60.w,
                  height: 60.w,
                ),
                onAddItem: () => controller.addImage(),
                onRemoveItem: (img) => controller.removeItemFromList(
                    (trainer) => trainer.imageUrls ?? [], img),
              ),
            ),
            Obx(() => _buildExpandableList<PriceTier>(
                  icon: Icons.price_change,
                  title: 'Prices',
                  list: controller.trainer.value!.priceList,
                  itemBuilder: (item) => Row(
                    children: [
                      Text("${item.description} - "),
                      Text("${item.price}₪"),
                    ],
                  ),
                  onAddItem: (newItem) => controller.addItemToList(
                      (trainer) => trainer.priceList, newItem),
                  onRemoveItem: (item) => controller.removeItemFromList(
                      (trainer) => trainer.priceList, item),
                )),
            AppStyle.h(10.h),
            _buildDivider(),
            _buildLogoutButton(),
          ],
        ),
      );
    });
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppStyle.deepBlackOrange,
        fontWeight: FontWeight.bold,
        fontSize: 18.sp,
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    required String initialValue,
    required Function(String) onChanged,
    required String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return CustomTextField(
      icon: Icon(icon, color: AppStyle.softOrange),
      initialValue: initialValue,
      hintText: hintText,
      hintColor: AppStyle.softBrown.withOpacity(0.6),
      fill: true,
      color: AppStyle.softOrange.withOpacity(0.1),
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      textStyle: TextStyle(fontSize: 16.sp, color: AppStyle.softBrown),
    );
  }

  Widget _buildDivider() {
    return Divider(
      thickness: 1,
      color: AppStyle.backGrey2,
    );
  }

  Widget _buildLogoutButton() {
    return TextButton.icon(
      onPressed: () => controller.logout(),
      icon: Icon(Icons.logout, color: Colors.redAccent, size: 24.sp),
      label: Text(
        'Logout',
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildExpandableList<T>({
    IconData? icon,
    required String title,
    required List<T> list,
    required Widget Function(T item) itemBuilder,
    required Function(T newItem) onAddItem,
    required Function(T item) onRemoveItem,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ExpandableList<T>(
        iconData: icon,
        title: title,
        list: list,
        itemBuilder: itemBuilder,
        onAddItem: () async {
          if (T == String) {
            _showAddItemBottomSheet('string', (newItem) {
              onAddItem(newItem as T);
            });
          } else if (T == PriceTier) {
            _showAddItemBottomSheet('prices', (newItem) {
              onAddItem(newItem as T);
            });
          }
        },
        onRemoveItem: (item) {
          onRemoveItem(item);
        },
      ),
    );
  }

  void _showAddItemBottomSheet(String listType, Function(dynamic) onAdd) {
    String inputText = '';
    double inputPrice = 0.0;

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
            // Dynamic title
            Text(
              listType == 'string' ? 'Add New Item' : 'Add New Price',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppStyle.deepOrange,
              ),
            ),
            const SizedBox(height: 16),

            // Input fields
            if (listType == 'string') ...[
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
              const SizedBox(height: 15), // Spacing between fields
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
            // Submit button
            CustomButton(
              text: 'Add',
              fill: true,
              color: AppStyle.deepOrange,
              onTap: () {
                if (listType == 'string') {
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
}
