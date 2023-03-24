import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paginationbloc/pregentation/posts_screen.dart';
import 'cubit/posts_cubit.dart';
import 'data/repositories/posts_respository.dart';
import 'data/services/posts_service.dart';

void main() {
  runApp( MyApp(repository: PostsRepository(PostsService())));
}

class MyApp extends StatelessWidget {
   final PostsRepository repository;

  const MyApp({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => PostsCubit(repository),
        child: PostsView(),
      ),
    );
  }
}
