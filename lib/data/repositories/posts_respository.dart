import '../models/post.dart';
import '../services/posts_service.dart';

class PostsRepository {
  final PostsService postService;

  PostsRepository(this.postService);

  Future<List<Post>> getPosts(int page) async {
    final posts = await postService.fetchPosts(page);
    return posts.map((e) => Post.fromJson(e)).toList();
  }
}
