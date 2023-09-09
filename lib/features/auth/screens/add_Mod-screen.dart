// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_reddit_clone/core/common/Error_text.dart';
import 'package:new_reddit_clone/core/common/Loader.dart';
import 'package:new_reddit_clone/core/modules/Community_Model.dart';
import 'package:new_reddit_clone/features/auth/controller/AuthController.dart';
import 'package:new_reddit_clone/features/auth/controller/CommunityController.dart';

// screen user can ad modarator like reddit . This is  reddit clone.

class AddModsScreens extends ConsumerStatefulWidget {
  const AddModsScreens({
    required this.name,
  });
  final String name;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreensState();
}

class _AddModsScreensState extends ConsumerState<AddModsScreens> {
  Set<String> uids = {};
  int ctr = 0;
  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void saveMods() {
    ref
        .read(CommunityControllerProvider.notifier)
        .addmods(widget.name, uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: saveMods, icon: const Icon(Icons.done))
          ],
        ),
        body: ref.watch(getCommunityByNameProvider(widget.name)).when(
            data: (community) => ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                  final member = community.members[index];

                  return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        if (community.mods.contains(member) && ctr == 0) {
                          uids.add(member);
                        }
                        ctr++;
                        return CheckboxListTile(
                          value: uids.contains(user.uid),
                          onChanged: (val) {
                            if (val!) {
                              addUid(user.uid);
                            } else {
                              removeUid(user.uid);
                            }
                          },
                          title: Text(user.name),
                        );
                      },
                      error: ((error, stackTrace) =>
                          ErrorText(error: error.toString())),
                      loading: () => const Loader());
                }),
            error: ((error, stackTrace) => ErrorText(error: error.toString())),
            loading: () => const Loader()));
  }
}
