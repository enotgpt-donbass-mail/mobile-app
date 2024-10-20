import 'package:app/urls/imageURL.dart';

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? middleName;
  String? image = CustomIMG.profileImg;

  User({this.id, this.firstName, this.lastName, this.middleName, this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      middleName: json['middle_name'],
      image: json['photo'],
    );
  }
}
