import 'package:flutter/material.dart';
import 'package:new_reddit_clone/features/feed/feedScreen.dart';
import 'package:new_reddit_clone/features/post/AddPostScreen.dart';

class Constants {
  static const GooglePath = 'assets/images/google.png';
  static const LoginEmotePath = 'assets/images/loginEmote.png';
  static const LogoPath = 'assets/images/logo.png';

  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  static const tabWidget = [
    FeedScreen(),
    AddPostScreen(),
  ];

  static const IconData up =
      IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);
  static const IconData down =
      IconData(0xe801, fontFamily: 'MyFlutterApp', fontPackage: null);

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': 'assets/awards/awesomeanswer.png',
    'gold': 'assets/awards/gold.png',
    'platinum': 'assets/awards/platinum.png',
    'helpful': 'assets/awards/helpful.png',
    'plusone': 'assets/awards/plusone.png',
    'rocket': 'assets/awards/rocket.png',
    'thankyou': 'assets/awards/thankyou.png',
    'til': 'assets/awards/til.png',
  };
}
