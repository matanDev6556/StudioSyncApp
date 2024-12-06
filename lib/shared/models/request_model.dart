import 'package:uuid/uuid.dart';

class RequestModel {
  final String id;
  final String traineeID;
  final String trainerID;
  

  RequestModel({
    String? id,
    required this.traineeID,
    required this.trainerID,
   
  }) : id = id ?? const Uuid().v4();

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'],
      traineeID: map['traineeID'] ?? '',
      trainerID: map['trainerID'] ?? '',
     
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'traineeID': traineeID,
        'trainerID': trainerID,
        
      };

  RequestModel copyWith({
    String? traineeID,
    String? trainerID,
    String? status,
    String? id,
  }) {
    return RequestModel(
      id: id ?? this.id,
      traineeID: traineeID ?? this.traineeID,
      trainerID: trainerID ?? this.trainerID,
      
    );
  }
}
