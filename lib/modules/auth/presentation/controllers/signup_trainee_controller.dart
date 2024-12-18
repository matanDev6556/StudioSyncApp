
import 'package:studiosync/core/domain/usecases/pick_image_usecase.dart';
import 'package:studiosync/core/router/app_router.dart';
import 'package:studiosync/core/router/routes.dart';
import 'package:studiosync/modules/auth/domain/usecases/signup_trainee_usecase.dart';
import 'package:studiosync/modules/auth/presentation/controllers/shared_signup_controller.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';


class SignUpTraineeController extends AbstractSignUpController {
  final SignUpTraineeUseCase _signUpTraineeUseCase;

  SignUpTraineeController({
    required PickImageUseCase pickImageUseCase,
    required SignUpTraineeUseCase signUpTraineeUseCase,
  })  : _signUpTraineeUseCase = signUpTraineeUseCase,
        super(pickImageUseCase: pickImageUseCase);

  @override
  void submit() async {
    if (validateForm()) {
      final newTrainee = TraineeModel(
        id: userId,
        userFullName: fullName.value,
        userEmail: email.value,
        userPhone: phone.value,
        userCity: city.value,
        userAge: age.value.toInt(),
        imgUrl: imgPath.value,
        isTrainer: false,
      );

      await _signUpTraineeUseCase.execute(newTrainee, password.value);
      AppRouter.navigateTo(Routes.widgetTree);
    }
  }
}