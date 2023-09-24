import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/posts_cubit.dart';
import '../data/models/post.dart';

class PostsView extends StatefulWidget {
  @override
  _PostsViewState createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> with TickerProviderStateMixin {
  final scrollController = ScrollController();
  late AnimationController _animationController;

  // Anything changes happen in ListView() This function will be called.
  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<PostsCubit>(context).loadPosts();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setupScrollController(context);
    BlocProvider.of<PostsCubit>(context).loadPosts();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Adjust the duration as needed
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
      ),
      body: _postList(),
    );
  }

  Widget _postList() {
    return BlocBuilder<PostsCubit, PostsState>(builder: (context, state) {
      if (state is PostsLoading && state.isFirstFetch) {
        return _loadingIndicator();
      }

      List<Post> posts = [];
      bool isLoading = false;

      if (state is PostsLoading) {
        posts = state.oldPosts;
        isLoading = true;
      } else if (state is PostsLoaded) {
        posts = state.posts;
      }

      return ListView.builder(
        controller: scrollController,
        itemCount: posts.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < posts.length) {
            return _buildAnimatedListItem(posts[index], index);
          } else {
            Timer(const Duration(milliseconds: 30), () {
              scrollController.jumpTo(scrollController.position.maxScrollExtent);
            });

            return _loadingIndicator();
          }
        },
      );
    });
  }

  Widget _buildAnimatedListItem(Post post, int index) {
    // Use _animationController to control the animation
    _animationController.forward();

    return SizeTransition(
      sizeFactor: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.5 * index / 10, 1.0, curve: Curves.linearToEaseOut),
        ),
      ),
      child: _post(post, context),
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _post(Post post, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${post.id}. ${post.title}",
            style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Text(post.body)
        ],
      ),
    );
  }
}
