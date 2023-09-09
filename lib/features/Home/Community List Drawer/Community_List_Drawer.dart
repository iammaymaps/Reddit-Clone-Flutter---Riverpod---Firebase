import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_reddit_clone/core/common/Error_text.dart';
import 'package:new_reddit_clone/core/common/Loader.dart';
import 'package:new_reddit_clone/core/modules/Community_Model.dart';
import 'package:new_reddit_clone/features/auth/controller/CommunityController.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          ListTile(
            title: const Text("Create a community"),
            leading: const Icon(Icons.add),
            onTap: () => navigateToCreateCreateCommunity(context),
          ),
          ref.watch(userCommunitiesProvider).when(
              data: (communities) => Expanded(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        final community = communities[index];

                        return ListTile(
                            onTap: () {
                              navigateToCommunity(context, community);
                            },
                            leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(community.avater)),
                            title: Text('r/${community.name}'));
                      },
                      itemCount: communities.length,
                    ),
                  ),
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader())
        ],
      )),
    );
  }
}
