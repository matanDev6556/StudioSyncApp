import 'package:studiosync/core/data/models/user_model.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:studiosync/modules/trainer/features/profile/data/models/price_tier_model.dart';


class TrainerModel extends UserModel {
  List<String>? imageUrls;
  List<PriceTier> priceList;
  List<String> coachesList;
  List<String> locationsList;
  List<String> lessonsTypeList;
  String about;
  String instagramLink;

  TrainerModel({
    super.id,
    super.imgUrl,
    required super.userFullName,
    required super.isTrainer,
    required super.userEmail,
    required super.userAge,
    required super.userCity,
    required super.userPhone,
    required this.priceList,
    this.imageUrls = const <String>[],
    this.coachesList = const <String>[],
    this.locationsList = const <String>[],
    this.lessonsTypeList = const <String>[],
    this.instagramLink = '',
    required this.about,
  });

  @override
  TrainerModel copyWith({
    String? id,
    String? imgUrl,
    String? userFullName,
    bool? isTrainer,
    String? userEmail,
    String? userPass,
    int? userAge,
    String? userCity,
    String? userPhone,
    List<String>? imageUrls,
    List<PriceTier>? priceList,
    List<TraineeModel>? traineeList,
    List<String>? coachesList,
    List<String>? locationsList,
    List<String>? lessonsTypeList,
    String? about,
    bool? isLessonsAvailable,
    String? instagramLink,
  }) {
    return TrainerModel(
      id: id ?? super.userId,
      imgUrl: imgUrl ?? this.imgUrl,
      userFullName: userFullName ?? this.userFullName,
      isTrainer: isTrainer ?? this.isTrainer,
      userEmail: userEmail ?? this.userEmail,
      userAge: userAge ?? this.userAge,
      userCity: userCity ?? this.userCity,
      userPhone: userPhone ?? this.userPhone,
      imageUrls: imageUrls ?? this.imageUrls,
      priceList: priceList ?? this.priceList,
      coachesList: coachesList ?? this.coachesList,
      about: about ?? this.about,
      
      locationsList: locationsList ?? this.locationsList,
      lessonsTypeList: lessonsTypeList ?? this.lessonsTypeList,
      instagramLink: instagramLink ?? this.instagramLink,
    );
  }

  factory TrainerModel.fromJson(Map<String, dynamic> json) {
    final userFullName = json['userFullName'] ?? '';
    final isTrainer = json['isTrainer'] ?? false;
    final userEmail = json['userEmail'] ?? '';
    final userAge = json['userAge'] ?? 0;
    final userCity = json['userCity'] ?? '';
    final userPhone = json['userPhone'] ?? '';
    final about = json['about'] ?? '';
    final imgUrl = json['imgUrl'] ?? '';
    final id = json['id'] ?? '';
    

    final priceListMapList = json['priceList'] as List<dynamic>? ?? [];
    final priceList = priceListMapList
        .map((priceTier) => PriceTier.fromJson(priceTier))
        .toList();

    final imageUrlsList = json['imageUrls'] as List<dynamic>? ?? [];
    final imageUrls = imageUrlsList.map((url) => url.toString()).toList();

    final coachesListJson = json['coachesList'] as List<dynamic>? ?? [];
    final coachesList =
        coachesListJson.map((coach) => coach.toString()).toList();

    final locationsListJson = json['locationsList'] as List<dynamic>? ?? [];
    final locationsList =
        locationsListJson.map((location) => location.toString()).toList();

    final lessonsTypeListJson = json['lessonsTypeList'] as List<dynamic>? ?? [];
    final lessonsTypeList =
        lessonsTypeListJson.map((type) => type.toString()).toList();

    return TrainerModel(
      userFullName: userFullName,
      isTrainer: isTrainer,
      userEmail: userEmail,
      userAge: userAge,
      userCity: userCity,
      userPhone: userPhone,
      about: about,
      imgUrl: imgUrl,
      id: id,
      priceList: priceList,
      
      imageUrls: imageUrls,
      coachesList: coachesList,
      locationsList: locationsList,
      lessonsTypeList: lessonsTypeList,
      instagramLink: json['instagramLink'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
       'id': userId,
      'imgUrl': imgUrl,
      'userFullName': userFullName,
      'isTrainer': isTrainer,
      'userEmail': userEmail,
      'userAge': userAge,
      'userCity': userCity,
      'userPhone': userPhone,
      'priceList': priceList.map((p) => p.toMap()).toList(),
      'about': about,
      'imageUrls': imageUrls,
      'coachesList': coachesList,
      'locationsList': locationsList,
      'lessonsTypeList': lessonsTypeList,
      'instagramLink': instagramLink,
    };
  }

 

  @override
  String toString() {
    return 'id : $userId\n'
        'name : $userFullName \n email: $userEmail \n,city: $userCity \n';
  }
}
