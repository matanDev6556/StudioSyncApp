import 'package:studiosync/core/data/data_source/mongo_service.dart';
import 'package:studiosync/modules/auth/domain/repositories/i_signup_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/profile/data/models/trainer_model.dart';

class SignUpMongoRepository implements ISignUpRepository {
  final MongoService _mongoService;

  SignUpMongoRepository(this._mongoService);

  @override
  Future<void> createTrainee(TraineeModel trainee, {String? token}) async {
    if (token == null) throw Exception('No token available');
    final img = trainee.imgUrl!.isEmpty
        ? 'https://example.com/profile.jpg'
        : trainee.imgUrl;
    await _mongoService.createTrainee(
        token, trainee.copyWith(imgUrl: img).toMap());
  }

  @override
  Future<void> createTrainer(TrainerModel trainer) async {
    throw UnimplementedError('Trainer creation not implemented yet');
  }
}
