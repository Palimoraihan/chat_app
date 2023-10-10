class UserModel {
  final String name;
  final String uid;
  final String profilePick;
  final bool isOnline;
  final String phoneNum;
  final List<String> groupId;

  UserModel({
    required this.name,
    required this.uid,
    required this.profilePick,
    required this.isOnline,
    required this.phoneNum,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePick': profilePick,
      'isOnline': isOnline,
      'phoneNum': phoneNum,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      profilePick: map['profilePick'] ?? '',
      isOnline: map['isOnline'] ?? false,
      phoneNum: map['phoneNum'] ?? '',
      groupId: List<String>.from(map['groupId']),
    );
  }

  // String toJson() => json.encode(toMap());

  // factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
