class ChatUser {
  ChatUser({
    required this.Username,
    required this.college_name,
    required this.email,
    required this.programming_intrests,
    required this.id
  });
  late final String Username;
  late final String college_name;
  late final String email;
  late final String programming_intrests;
  late final String id;

  ChatUser.fromJson(Map<String, dynamic> json){
    Username = json['Full_Name'] ?? '';
    college_name = json['College_Name'] ?? '';
    email = json['Email'] ?? '';
    programming_intrests = json['Programming_Interest'] ?? '';
    id = json['id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Full_Name'] = Username;
    data['College_Name'] = college_name;
    data['Email'] = email;
    data['Programming_Interest'] = programming_intrests;
    data['id'] = id;
    return data;
  }
}