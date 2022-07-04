import 'package:mysql1/mysql1.dart';
import 'package:mysql_manager/src/env_reader.dart';
import 'package:mysql_manager/src/errors/env_reader_exceptions.dart';

class MySQLManager {
  //attributes
  static MySQLManager? _manager;
  MySqlConnection? _conn;
  static Map<String, dynamic> _connectionConfig = const {};

  //private constructor
  MySQLManager._();

  //getters
  ///Getter of MySQLManager instance. This is the entry point to use this class and get the connection
  ///[final manager = MySQLManager.instance]
  ///[final connection = manager.conn;]
  static MySQLManager get instance {
    _manager ??= MySQLManager._();
    return _manager!;
  }

  ///Getter of MySQLConnection object
  ///
  MySqlConnection? get conn => _conn;

  //load connection data
  Future<void> loadConfiguration(
      [bool useEnvFile = true,
      Map<String, dynamic> connectionConfig = const {}]) async {
    try {
      await init(useEnvFile, connectionConfig);
    } catch (err) {
      throw Exception(err.toString());
    } finally {
      if (conn != null) {
        await _conn!.close();
      }
    }
  }

  ///Initialize connection to mysql using both .env file or configuration map.
  ///
  ///if [useEnvFile] is setted to true a [config] Map<String,dynamic> is needed.
  /// It's a requirement for this [config] map to have the following structure:
  ///
  /// ``` Map<String,dynamic> config = {'db':'your_db_name','host':'your_mysql_host', 'user':'your_mysql_user', password: 'your_mysql_password', 'port': your_port}```;
  ///
  ///However, if you use .env file for the configuration, you can use this method without parameters.
  ///.env file should be located at root and each property should have exactly the same key as the config map of above
  ///keys are separated from their values with a = without spaces between them: db=YOUR_DABATABASE
  ///
  ///returns a [MySqlConnection] object which can be used to manipulate directly to query or close the connection;
  ///
  ///If there's a error in the .env file a ```BadMySQLConfigException``` will be thrown.
  ///On the other hand, when not using .env file and setting the configuration directly at [config] argument and the map
  ///has not the correct structure, a ```BadMySQLCodeConfig``` will be raised.
  Future<MySqlConnection> init(
      [useEnvFile = true, Map<String, dynamic> config = const {}]) async {
    if (useEnvFile) {
      try {
        await _initWithEnv();
      } on BadMySQLConfigException catch (err) {
        print(err.toString());
        throw BadMySQLConfigException();
      }
    } else {
      try {
        await _selfInit(config: config);
      } on BadMySQLCodeConfigException catch (err) {
        print(err.toString());
      }
    }
    return conn!;
  }

  ///close connection
  Future<void> close() async => await _conn!.close();

  ///query
  Future<Results> query(String sql, [List<Object?>? values]) async {
    if (_conn == null) {
      throw Exception('MySQL Connection has not been initialized.');
    }
    return _conn!.query(sql, values);
  }

  //initialize with env file
  Future<void> _initWithEnv() async {
    //read .env file
    Map<String, dynamic> env = {};
    if (_connectionConfig.isEmpty) {
      var envReader = EnvReader();
      await envReader.load();
      env = envReader.env;
      if (!_isConnectionConfigCorrect(env)) {
        throw BadMySQLConfigException();
      }
      _connectionConfig = env;
    }

    final connSettings = ConnectionSettings(
        host: _connectionConfig['host'],
        port: int.parse(_connectionConfig['port']),
        user: _connectionConfig['user'],
        password: _connectionConfig['password'],
        db: _connectionConfig['db']);
    _conn = await MySqlConnection.connect(connSettings);
  }

  Future<void> _selfInit({Map<String, dynamic> config = const {}}) async {
    if (_connectionConfig.isEmpty) {
      if (!_isConnectionConfigCorrect(config)) {
        throw BadMySQLCodeConfigException();
      }
      _connectionConfig = config;
    }

    final connSettings = ConnectionSettings(
        host: _connectionConfig['host'],
        port: int.parse(_connectionConfig['port']),
        user: _connectionConfig['user'],
        password: _connectionConfig['password'],
        db: _connectionConfig['db']);
    _conn = await MySqlConnection.connect(connSettings);
  }

  bool _isConnectionConfigCorrect(Map<String, dynamic> config) {
    List<String> configArguments = ['host', 'user', 'db', 'password', 'port'];
    for (String argument in configArguments) {
      if (!config.containsKey(argument)) return false;
    }
    return true;
  }
}
