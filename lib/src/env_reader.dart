import 'dart:io';

class EnvReader {
  EnvReader();
  Future<void> load() async {
    File file = File('.env');
    //exists env file at root
    if (await file.exists()) {
      var res = file.readAsLinesSync();
      Map<String, dynamic> mapper = {};
      for (String r in res) {
        var splitter = r.trim().split('=');
        mapper.addAll({splitter[0]: splitter[1]});
      }
      _env = mapper;
      return;
    }
    //file is created in case it does not exist.
    file.create();
  }

  late Map<String, dynamic> _env;
  Map<String, dynamic> get env => _env;
}
