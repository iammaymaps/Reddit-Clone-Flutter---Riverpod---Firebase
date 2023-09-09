import 'package:flutter/material.dart';
import 'package:new_reddit_clone/features/Community_Screens/Create_Community_Screens.dart';

import 'package:new_reddit_clone/features/Home/HomeScreens.dart';
import 'package:new_reddit_clone/features/auth/screens/CommunityScreen.dart';
import 'package:new_reddit_clone/features/auth/screens/EditCommunity.dart';
import 'package:new_reddit_clone/features/auth/screens/ModScreens.dart';
import 'package:new_reddit_clone/features/auth/screens/add_Mod-screen.dart';
import 'package:new_reddit_clone/features/post/add_post_type_Screen.dart';
import 'package:new_reddit_clone/user_profile/screens/UserProfileScreen.dart';
import 'package:new_reddit_clone/user_profile/screens/editProfileScreen.dart';
import 'package:routemaster/routemaster.dart';

import 'features/auth/screens/LoginScreen.dart';

final loggedOutRoute =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: LoginScreen())});



final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreens()),

  '/create-community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),

      
  '/r/:name': (route) => MaterialPage(
          child: CommunityScreen(
        name: route.pathParameters['name']!,
      )),
  '/mod-tools/:name': (routeData) =>

      MaterialPage(child: ModTool(name: routeData.pathParameters['name']!)),
  '/edit-community/:name': (routeData) => MaterialPage(
      child: EditCommunity(name: routeData.pathParameters['name']!)),
  '/add-mods/:name': (routeData) => MaterialPage(
      child: AddModsScreens(name: routeData.pathParameters['name']!)),
  '/u/:uid': (routeData) => MaterialPage(
      child: UserProfileScreen(uid: routeData.pathParameters['uid']!)),
  '/edit/:uid': (routeData) => MaterialPage(
      child: EditProfileScreen(uid: routeData.pathParameters['uid']!)),
  '/add-post/:type': (routeData) => MaterialPage(
      child: AddPostypeScreen(type: routeData.pathParameters['type']!)),
});
