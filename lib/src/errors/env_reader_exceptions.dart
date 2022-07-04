abstract class EnvReaderExceptions implements Exception {
  String cause;
  EnvReaderExceptions({required this.cause});

  @override
  String toString() => ' $cause';
}

class BadMySQLConfigException extends EnvReaderExceptions {
  static String problem =
      'BadMySQLConfigException: some .env configuration is missing for MySQL Connection. bd, host, user, port or password are lost.';
  BadMySQLConfigException() : super(cause: problem);
}

class BadMySQLCodeConfigException extends EnvReaderExceptions {
  static String problem =
      'BadMySQLCodeConfigException: Map<String,dynamic> provided is not correct. It should contains db, host, user, password and port keys';
  BadMySQLCodeConfigException() : super(cause: problem);
}
