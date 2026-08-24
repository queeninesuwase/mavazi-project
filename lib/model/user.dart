class User {
  final int id;
  final String username,email,firstName, lastName, gender , image;

  User ({required this.id,
  required this.username,
  required this.email,
  required this.firstName,
  required this.lastName,
  required this.gender,
  required this.image,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'], 
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'], 
      lastName: json['lastName'], 
      gender: json['gender'], 
      image: json['image'],
      );
  }
}