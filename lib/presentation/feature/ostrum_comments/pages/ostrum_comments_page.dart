import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';


import 'package:get_it/get_it.dart' show GetIt;
import 'package:ostrum_test/presentation/feature/ostrum_comments/bloc/ostrum_comments_bloc.dart';
import 'package:ostrum_test/shared/extensions/string_extensions.dart';
import 'package:ostrum_test/presentation/widgets/custom_app_bar.dart';


@RoutePage()
class OstrumCommentsPage extends StatelessWidget {
  static const id = '/ostrumCommentsPage';
  OstrumCommentsPage({super.key});

  final ostrumCommentsBloc = GetIt.I<OstrumCommentsBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: '',
      ),
      body: Center(
        child: Text('OstrumComments Page'),
      ),
    );
  }
}
