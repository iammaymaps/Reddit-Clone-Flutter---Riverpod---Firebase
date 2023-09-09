import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_reddit_clone/core/Home/delegates/search_delecates.dart';
import 'package:new_reddit_clone/core/constants/constants.dart';
import 'package:new_reddit_clone/features/Home/Community%20List%20Drawer/Community_List_Drawer.dart';
import 'package:new_reddit_clone/features/Home/Community%20List%20Drawer/profile_drawer.dart';
import 'package:new_reddit_clone/features/auth/controller/AuthController.dart';
import 'package:new_reddit_clone/theme/pallete.dart';

class HomeScreens extends ConsumerStatefulWidget {
  const HomeScreens({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreensState();
}

class _HomeScreensState extends ConsumerState<HomeScreens> {
  int _page = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Home'),
          centerTitle: false,
          leading: Builder(builder: (context) {
            return Builder(builder: (context) {
              return IconButton(
                  onPressed: () => displayDrawer(context),
                  icon: const Icon(Icons.menu));
            });
          }),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: SearchCommunityDelegate(ref));
                },
                icon: const Icon(Icons.search)),
            Builder(builder: (context) {
              return IconButton(
                onPressed: () => displayEndDrawer(context),
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
              );
            })
          ]),
      drawer: CommunityListDrawer(),
      endDrawer: ProfileScreen(),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: currentTheme.backgroundColor,
        activeColor: currentTheme.iconTheme.color,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
        ],
        onTap: onPageChanged,
        currentIndex: _page,
      ),
      body: Constants.tabWidget[_page],
    );
  }
}
