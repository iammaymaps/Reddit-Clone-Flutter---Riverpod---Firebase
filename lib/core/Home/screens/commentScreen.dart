// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_reddit_clone/core/common/Error_text.dart';
import 'package:new_reddit_clone/core/common/Loader.dart';
import 'package:new_reddit_clone/core/common/Postcard.dart';
import 'package:new_reddit_clone/core/common/commentcard.dart';
import 'package:new_reddit_clone/core/modules/postModels.dart';
import 'package:new_reddit_clone/features/post/controller/addpostController.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({
    required this.postId,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(PostControllerProvider.notifier).addComment(
        context: context, text: commentController.text.trim(), postId: post);

    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (data) {
              return Column(
                children: [
                  PostCard(post: data),
                  TextField(
                    onSubmitted: (val) => addComment(data),
                    controller: commentController,
                    decoration:
                        InputDecoration(hintText: 'What are you thoughts?'),
                  ),
                  Expanded(
                    child: ref
                        .watch(getPostByCommentsProvider(widget.postId))
                        .when(
                          data: (data) {
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return CommentCard(comment: data[index]);
                              },
                            );
                          },
                          error: (error, stackTrace) {
                            print(error);
                            return ErrorText(
                              error: error.toString(),
                            );
                          },
                          loading: () => const Loader(),
                        ),
                  ),
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader()));
  }
}
