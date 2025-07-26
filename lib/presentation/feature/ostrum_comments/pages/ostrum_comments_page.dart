import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart' show GetIt;
import 'package:ostrum_test/domain/models/comment/comment_model.dart';
import 'package:ostrum_test/presentation/feature/ostrum_comments/bloc/ostrum_comments_bloc.dart';
import 'package:ostrum_test/presentation/feature/ostrum_comments/bloc/ostrum_comments_state.dart';
import 'package:tuple/tuple.dart';

@RoutePage()
class OstrumCommentsPage extends StatelessWidget {
  static const id = '/ostrumCommentsPage';
  OstrumCommentsPage({super.key});

  final ostrumCommentsBloc = GetIt.I<OstrumCommentsBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: BlocSelector<OstrumCommentsBloc, OstrumCommentsState, Tuple3<bool, bool, List<CommentModel>>>(
        bloc: ostrumCommentsBloc,
        selector: (state) => Tuple3(state.isLoading, state.error, state.comments),
        builder: (context, tuple) {
          final isLoading = tuple.item1;
          final hasError = tuple.item2;
          final comments = tuple.item3;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (hasError) {
            return const Center(
              child: Text('Something went wrong while loading comments.', style: TextStyle(color: Colors.red)),
            );
          }

          if (comments.isEmpty) {
            return const Center(child: Text("No comments loaded"));
          }

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return ListTile(
                title: Text(comment.name ?? 'No name'),
                subtitle: Text(comment.email ?? 'No email'),
                trailing: const Icon(Icons.comment),
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              ostrumCommentsBloc.fetchOstrum();
            },
            child: const Icon(Icons.refresh),
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              ostrumCommentsBloc.clearCache();
            },
            child: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
