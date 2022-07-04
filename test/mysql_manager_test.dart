import 'package:mysql1/mysql1.dart';
import 'package:mysql_manager/mysql_manager.dart';
import 'package:mysql_manager/src/mysql_manager.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    test('.env file is well configured', ()async{

      final manager = MySQLManager.instance;
      expect(await manager.init(), isA<MySqlConnection>());
      await expectLater(manager.query('select * from this_table_does_not_exists'), throwsA(isA<Exception>()));


    });
  });
}
