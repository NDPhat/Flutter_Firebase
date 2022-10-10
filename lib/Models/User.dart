class User{
  String id;
  final String name;
  final int age;
  final DateTime birthday;

  User(this.id, this.name, this.age, this.birthday);
  Map<String,dynamic> toJson()=>{
    'id':id,
    'name':name,
    'age':age,
    'birthday':birthday,
  };
}