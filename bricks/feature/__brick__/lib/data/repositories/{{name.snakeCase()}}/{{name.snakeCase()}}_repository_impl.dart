import 'package:ostrum_test/domain/repositories/{{name.snakeCase()}}/{{name.snakeCase()}}_repository.dart';

class {{name.pascalCase()}}RepositoryImpl implements {{name.pascalCase()}}Repository {
  @override
  Future<void> start{{name.pascalCase()}}() async {
    // start your repository here
  }
}
