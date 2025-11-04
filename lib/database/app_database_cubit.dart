import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDatabaseCubit extends Cubit<Database?> {
  late Database _database;
  AppDatabaseCubit() : super(null) {
    _initDatabase();
  }

  void _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'fitsanny.db'),
      onCreate: (db, version) => db.execute(''),
    );
  }

  Database get database => _database;
}
