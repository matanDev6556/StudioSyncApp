import 'package:get/get.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/subscription/data/repositories/firestore_subscription_repository.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/subscription/domain/repositories/i_subscription_repository.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/subscription/domain/usecases/cancle_sub_usecase.dart';
import 'package:studiosync/modules/trainer/features/trainee-sections/subscription/domain/usecases/save_sub_usecase.dart';

class SubscriptionBindings implements Bindings {
  @override
  void dependencies() {
    // cocnrete repo
    Get.put<ISubscriptionRepository>(
        FirestoreSubscriptionRepository(firestoreService: Get.find()));

    // usecases
    Get.lazyPut(
        () => SaveSubscriptionUseCase(iSubscriptionRepository: Get.find()));
    Get.lazyPut(
        () => CancleSubscriptionUseCase(iSubscriptionRepository: Get.find()));
  }
}
