class Comments {
  final String id;
  final String text;
  final String postId;
  final String username;
  final DateTime createdAt;
  final String profilePic;
  Comments({
    required this.id,
    required this.text,
    required this.postId,
    required this.username,
    required this.createdAt,
    required this.profilePic,
  });

  Comments copyWith({
    String? id,
    String? text,
    String? postId,
    String? username,
    DateTime? createdAt,
    String? profilePic,
  }) {
    return Comments(
      id: id ?? this.id,
      text: text ?? this.text,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'postId': postId,
      'username': username,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
    };
  }

  factory Comments.fromMap(Map<String, dynamic> map) {
    return Comments(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      postId: map['postId'] ?? '',
      username: map['username'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      profilePic: map['profilePic'] ?? '',
    );
  }

  @override
  bool operator ==(covariant Comments other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        other.postId == postId &&
        other.username == username &&
        other.createdAt == createdAt &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        postId.hashCode ^
        username.hashCode ^
        createdAt.hashCode ^
        profilePic.hashCode;
  }
}
