class User
{
  int? id;
    String userName;
    String email;
  User({
    this.id,
    required this.userName,
    required this.email,
  });

  factory User.fromMap(Map<String,dynamic> map)
  {
    return User(
      id: map['id'],
      userName: map['username'],
      email: map['email'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'username':userName,
      'email':email,
    };
  }
}
