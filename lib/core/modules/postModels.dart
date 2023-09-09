import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Post {
  final String id;
  final int commentCount;
  final String title;
  final String? link;
  final String? description;
  final String communityName;
  final String communityProfile;
  final String username;
  final String uid;
  final String type;
  final DateTime createdAt;
  final List<String> awards;
  final List<String> upvotes;
  final List<String> downvotes;
  Post({
    required this.id,
    required this.commentCount,
    required this.title,
    this.link,
    this.description,
    required this.communityName,
    required this.communityProfile,
    required this.username,
    required this.uid,
    required this.type,
    required this.createdAt,
    required this.awards,
    required this.upvotes,
    required this.downvotes,
  });

  Post copyWith({
    String? id,
    int? commentCount,
    String? title,
    String? link,
    String? description,
    String? communityName,
    String? communityProfile,
    String? username,
    String? uid,
    String? type,
    DateTime? createdAt,
    List<String>? awards,
    List<String>? upvotes,
    List<String>? downvotes,
  }) {
    return Post(
      id: id ?? this.id,
      commentCount: commentCount ?? this.commentCount,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      communityName: communityName ?? this.communityName,
      communityProfile: communityProfile ?? this.communityProfile,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      awards: awards ?? this.awards,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'commentCount': commentCount,
      'title': title,
      'link': link,
      'description': description,
      'communityName': communityName,
      'communityProfile': communityProfile,
      'username': username,
      'uid': uid,
      'type': type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'awards': awards,
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        commentCount: map['commentCount']?.toInt() ?? 0,
        link: map['link'],
        description: map['description'],
        communityName: map['communityName'] ?? '',
        communityProfile: map['communityProfile'] ?? '',
        username: map['username'] ?? '',
        uid: map['uid'] ?? '',
        type: map['type'] ?? '',
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        awards: List<String>.from(map['awards']),
        upvotes: List<String>.from(map['upvotes']),
        downvotes: List<String>.from(
          (map['downvotes']),
        ));
  }

  @override
  String toString() {
    return 'Post(id: $id, commentCount: $commentCount, title: $title, link: $link, description: $description, communityName: $communityName, communityProfile: $communityProfile, username: $username, uid: $uid, type: $type, createdAt: $createdAt, awards: $awards, upvotes: $upvotes, downvotes: $downvotes)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.commentCount == commentCount &&
        other.title == title &&
        other.link == link &&
        other.description == description &&
        other.communityName == communityName &&
        other.communityProfile == communityProfile &&
        other.username == username &&
        other.uid == uid &&
        other.type == type &&
        other.createdAt == createdAt &&
        listEquals(other.awards, awards) &&
        listEquals(other.upvotes, upvotes) &&
        listEquals(other.downvotes, downvotes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        commentCount.hashCode ^
        title.hashCode ^
        link.hashCode ^
        description.hashCode ^
        communityName.hashCode ^
        communityProfile.hashCode ^
        username.hashCode ^
        uid.hashCode ^
        type.hashCode ^
        createdAt.hashCode ^
        awards.hashCode ^
        upvotes.hashCode ^
        downvotes.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);
}
