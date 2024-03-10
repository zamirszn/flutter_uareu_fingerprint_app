import 'dart:typed_data';

class FingerprintModel {
  int? id;
  DateTime dateCreated;
  String fingerprintPath;

  FingerprintModel({
    this.id,
    required this.dateCreated,
    required this.fingerprintPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateCreated': dateCreated.toIso8601String(),
      'fingerprintPath': fingerprintPath,
    };
  }

  factory FingerprintModel.fromMap(Map<String, dynamic> map) {
    return FingerprintModel(
      id: map['id'],
      dateCreated: DateTime.parse(map['dateCreated']),
      fingerprintPath: map['fingerprintPath'],
    );
  }
}
