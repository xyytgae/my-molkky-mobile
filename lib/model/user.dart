import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String iconImageUrl;
  final Timestamp createdAt;
  final String name;
  final int stars;

  UserModel({
    required this.id,
    required this.iconImageUrl,
    required this.createdAt,
    required this.name,
    required this.stars,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot snapshot,
  ) {
    final data = snapshot.data() as Map<dynamic, dynamic>;
    return UserModel(
      id: snapshot.id,
      iconImageUrl: data['iconImageUrl'],
      createdAt: data['createdAt'],
      name: data['name'],
      stars: data['stars'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'iconImageUrl': iconImageUrl,
        'createdAt': createdAt,
        'name': name,
        'stars': stars,
      };
}
