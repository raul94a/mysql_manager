import 'package:mysql_manager/src/mysql_manager.dart';

// ignore: slash_for_doc_comments
/*********************************************
 *                                           *
 *  Visit the test folder at the github repo *
 *  in order to check if your .env file is   *
 *  well configured.                         *
 *  https://github.com/raul94a/mysql_manager *
 *                                           *
 ********************************************/

void main() async {
  //There's two ways to stablish a connection to MySQL using this dependency
  //1. With a .env file
  //You're suposed to create a .env file at the root of your application
  //This file will have the following structure (adding more properties IS NOT problematic)

  //db=YOUR_DB_NAME
  //host=YOUR_HOST
  //user=YOUR_MYSQL_USER
  //password=YOUR_PASSWORD
  //port=PORT
//Once the .env file contains the credentials you can connect as easy as the following:

//The only way to instanciate MySQLManager is with the instance getter
  final MySQLManager manager = MySQLManager.instance;
//initialize the connection. Init method will return a MySqlConnection object
  final conn = await manager.init();
//you can pass sql to the query method
  final results = await conn.execute('select * from test');
//results will be a iterator,so is possible to loop over it
  for (var r in results) {
    //returns data in Map<String,dynamic> format
    print(r.rows);
  }

  await conn.close();
//also you can use await manager.close();

//2. Using the configuration map. This method is the same as the first with a little variation
//final conn = await manager.init(false, {'db'='YOUR_DB', 'host': 'YOUR_HOST', 'user':'YOUR_USER', 'password':'YOUR_PASSWORD', 'port': port}); //=> port is an integer, be careful
}
