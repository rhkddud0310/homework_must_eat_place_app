import 'package:homework_must_eat_place_app/model/eatplace.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath(); // 어디 경로에 설치할 것인지 담아놓는 부분이다.
    return openDatabase(
      join(path, 'eatplace.db'),
      onCreate: (db, version) async {
        await db.execute("create table musteatplace "
            "(seq integer primary key autoincrement, "
            "name text, phone text, lat text, lng text, image blob, "
            "estimate text, initdate text)");
      },
      version: 1,
    );
  }

  // ---------------------------------------------------------------------------

  Future<List<EatPlace>> queryEatPlace() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResults =
        await db.rawQuery('select * from musteatplace');
    return queryResults
        .map((e) => EatPlace.fromMap(e))
        .toList(); // Object 형식을 Map으로 바꾼다음 List 형식으로 최종 반환한다.
  }

  // ---------------------------------------------------------------------------

  Future<int> insertEatPlace(EatPlace eatPlace) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
        'insert into musteatplace'
        '(name, phone, lat, lng, image, estimate, initdate) '
        'values (?, ?, ?, ?, ?, ?, ?)',
        [
          eatPlace.name,
          eatPlace.phone,
          eatPlace.lat,
          eatPlace.lng,
          eatPlace.image,
          eatPlace.estimate,
          eatPlace.initdate
        ]);
    return result;
  }

  // ---------------------------------------------------------------------------

  Future<void> updateEatPlace(EatPlace eatPlace) async {
    final Database db = await initializeDB();
    await db.rawUpdate(
        'update musteatplace '
        'set name = ?, phone = ?, lat = ?, lng = ?, '
        'image = ?, estimate = ?, initdate = ? '
        'where seq = ?',
        [
          eatPlace.name,
          eatPlace.phone,
          eatPlace.lat,
          eatPlace.lng,
          eatPlace.image,
          eatPlace.estimate,
          eatPlace.initdate,
          eatPlace.seq
        ]);
  }

  // ---------------------------------------------------------------------------

  Future<void> deleteEatPlace(int seq) async {
    final Database db = await initializeDB();
    await db.rawDelete('delete from musteatplace where seq = ?', [seq]);
  }
} // End
