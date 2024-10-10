import 'package:uuid/uuid.dart';

abstract class UserModel {
  String userId;
  String userFullName;
  bool isTrainer;
  String userEmail;
  String userCity;
  String userPhone;
  int userAge;
  String? imgUrl;

  UserModel({
    String? id,
    this.imgUrl,
    required this.userFullName,
    required this.isTrainer,
    required this.userEmail,
    required this.userAge,
    required this.userCity,
    required this.userPhone,
  }) : userId = id ?? const Uuid().v4();

  @override
  String toString() {
    return 'UserModel {'
        ' userId: $userId,'
        ' userFullName: $userFullName,'
        ' isTrainer: $isTrainer,'
        ' userEmail: $userEmail,'
        ' userAge: $userAge,'
        ' userCity: $userCity,'
        ' userPhone: $userPhone,'
        ' imgUrl: $imgUrl'
        ' }';
  }

  bool get isTrainerUser => isTrainer == true ? true : false;
  

  UserModel copyWith();

  Map<String, dynamic> toMap();
}
