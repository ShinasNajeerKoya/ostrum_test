import '{{name.snakeCase()}}_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ostrum_test/domain/repositories/{{name.snakeCase()}}/{{name.snakeCase()}}_repository.dart';

class {{name.pascalCase()}}Bloc extends Cubit<{{name.pascalCase()}}State> {
  {{name.pascalCase()}}Bloc(this._repo) : super(const {{name.pascalCase()}}State());

  final {{name.pascalCase()}}Repository _repo;

  /// Add your business logic here
}
