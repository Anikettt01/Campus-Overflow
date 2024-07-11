class newChatUser {
  newChatUser({
    required this.FullName,
    required this.userName,
    // required this.image,
    required this.Email,
    required this.CollegeName,
    required this.ProgrammingInterest,
    required this.id,
    required this.pushToken,
    required this.total_upvotes,
  });
  late final String FullName;
  late final String userName;
  // late final String image;
  late final String Email;
  late final String CollegeName;
  late final String ProgrammingInterest;
  late final String id;
  late final String pushToken;
  late final int total_upvotes;

  newChatUser.fromJson(Map<String, dynamic> json){
    FullName = json['Full_Name'] ?? '';
    userName = json['username'] ?? '`';
    // image = json['image'] ?? '';
    Email = json['Email'] ?? '';
    CollegeName = json['College_Name'] ?? '';
    ProgrammingInterest = json['Programming_Interest'] ?? '';
    id = json['id'] ?? '';
    pushToken = json['push_token'] ?? '';
    total_upvotes = json['total_upvotes'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Full_Name'] = FullName;
    data['username'] = userName;
    // data['image'] = image;
    data['Email'] = Email;
    data['College_Name'] = CollegeName;
    data['Programming_Interest'] = ProgrammingInterest;
    data['id'] = id;
    data['push_token'] = pushToken;
    data['total_upvotes'] = total_upvotes;
    return data;
  }
}