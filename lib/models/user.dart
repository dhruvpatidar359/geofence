import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.imageUrl,
    required this.name,
  });

  final String id;
  final String name;
  final String email;
  final String imageUrl;

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
        id: json['id'] ?? "",
        name: json['name'] ?? "",
        email: json['email'] ?? "",
        imageUrl: json['imageUrl'] ?? "",
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
      };
  factory UserEntity.empty() =>
      const UserEntity(id: "", email: "", imageUrl: "", name: "");
  @override
  List<Object?> get props => [id, name, email, imageUrl];
}
