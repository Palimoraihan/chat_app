
class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSend;
  final String lastMessage;

  ChatContact(
      {required this.name,
      required this.profilePic,
      required this.contactId,
      required this.timeSend,
      required this.lastMessage});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'timeSend': timeSend.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      contactId: map['contactId'] ?? '',
      timeSend: DateTime.fromMillisecondsSinceEpoch(map['timeSend']),
      lastMessage: map['lastMessage'] ?? '',
    );
  }

  // String toJson() => json.encode(toMap());

  // factory ChatContact.fromJson(String source) =>
  //     ChatContact.fromMap(json.decode(source));
}
