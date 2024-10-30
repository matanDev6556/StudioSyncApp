import 'package:uuid/uuid.dart';

class RequestStatus {
  static const String pending = 'Pending';
  static const String approved = 'Approved';
  static const String rejected = 'Rejected';

  // Optional: Add a method to get all possible statuses
  static List<String> get values => [pending, approved, rejected];
}

class RequestModel {
  final String id;
  final String traineeID;
  final String trainerID;
  final String status;

  RequestModel({
    String? id,
    required this.traineeID,
    required this.trainerID,
    this.status = RequestStatus.pending,
  }) : id = id ?? const Uuid().v4();

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'],
      traineeID: map['traineeID'] ?? '',
      trainerID: map['trainerID'] ?? '',
      status: map['status'] ?? RequestStatus.pending,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'traineeID': traineeID,
        'trainerID': trainerID,
        'status': status,
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
      status: status ?? this.status,
    );
  }
}
