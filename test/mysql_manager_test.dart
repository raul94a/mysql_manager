import 'dart:io';

import 'package:mysql1/mysql1.dart';
import 'package:mysql_manager/src/env_reader.dart';
import 'package:mysql_manager/src/mysql_manager.dart';
import 'package:test/test.dart';

class TestMySQLManager {}

void main() {
  //test if you have created .env file in the root of your project
  test('.env file is created in the correct place', () {
    expect(File('.env').existsSync(), true);
  });
  //you can test if you have configured your .env file in a good way with this test
  test('.env file is well configured', () async {
    final manager = MySQLManager.instance;
    expect(await manager.init(), isA<MySqlConnection>());
    await expectLater(manager.query('select * from this_table_does_not_exist'),
        throwsA(isA<Exception>()));
  });

  test('Connection to DB without .env file', () async {
    //I've tested here with my env file because in fact it returns a well-configured map
    //you can delete the following  variables in which envReader is involved and put your config map directly at the config variable
    //if everything is ok this test will pass EXCEPT for the last one, in which I am selecting * from test. If you don't have
    //a table called test, this test is gonna fail. I recommend to comment the last test.
    final envReader = EnvReader();
    await envReader.load();
    final config = envReader.env;
    final manager = MySQLManager.instance;
    expect(await manager.init(false, config), isA<MySqlConnection>());
    await expectLater(manager.query('select * from this_table_does_not_exist'),
        throwsA(isA<Exception>()));
    final res = await manager.query('select * from test');
    expect(res.fields.length, greaterThanOrEqualTo(0));
  });
}
