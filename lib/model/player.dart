import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String id;
  final int order;
  final bool elimination;
  final String iconImageUrl;
  final int firstHalfScore;
  final int secondHalfScore;
  final List<dynamic> scores;
  final Timestamp createdAt;
  final String name;
  final int stars;

  Player({
    required this.id,
    required this.order,
    required this.elimination,
    required this.iconImageUrl,
    required this.firstHalfScore,
    required this.secondHalfScore,
    required this.scores,
    required this.createdAt,
    required this.name,
    required this.stars,
  });

  factory Player.fromDocument(DocumentSnapshot document) {
    return Player(
      id: document.id,
      order: document['order'],
      elimination: document['elimination'],
      iconImageUrl: document['iconImageUrl'],
      firstHalfScore: document['firstHalfScore'],
      secondHalfScore: document['secondHalfScore'],
      scores: document['scores'],
      createdAt: document['createdAt'],
      name: document['name'],
      stars: document['stars'],
    );
  }

  factory Player.fromFirestore(
    DocumentSnapshot snapshot,
  ) {
    final data = snapshot.data() as Map<dynamic, dynamic>;
    return Player(
      id: snapshot.id,
      order: data['order'],
      elimination: data['elimination'],
      iconImageUrl: data['iconImageUrl'],
      firstHalfScore: data['firstHalfScore'],
      secondHalfScore: data['secondHalfScore'],
      scores: data['scores'],
      createdAt: data['createdAt'],
      name: data['name'],
      stars: data['stars'],
    );
  }

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        id: json['id'] as String,
        order: json['order'] as int,
        elimination: json['elimination'] as bool,
        iconImageUrl: json['iconImageUrl'] as String,
        firstHalfScore: json['firstHalfScore'] as int,
        secondHalfScore: json['secondHalfScore'] as int,
        scores: json['scores'] as List<int>,
        createdAt: json['createdAt'] as Timestamp,
        name: json['name'] as String,
        stars: json['stars'] as int,
      );

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'order': order,
      'elimination': elimination,
      'iconImageUrl': iconImageUrl,
      'firstHalfScore': firstHalfScore,
      'secondHalfScore': secondHalfScore,
      'scores': scores,
      'createdAt': createdAt,
      'name': name,
      'stars': stars,
    };
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order': order,
        'elimination': elimination,
        'iconImageUrl': iconImageUrl,
        'firstHalfScore': firstHalfScore,
        'secondHalfScore': secondHalfScore,
        'scores': scores,
        'createdAt': createdAt,
        'name': name,
        'stars': stars,
      };
}
