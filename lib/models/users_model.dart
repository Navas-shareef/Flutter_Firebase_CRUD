class User {
  String id;
  String userId;
  String name;
  int age;
  String birthday;

  User(
      {this.id = '',
      this.userId = '',
      required this.name,
      required this.age,
      required this.birthday});

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'age': age,
        'birthday': birthday
      };

  static User fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      age: json['age'],
      birthday: json['birthday']);
}
