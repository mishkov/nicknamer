class Settings {
  Settings({this.settings});

  Map<String, String> settings;

  factory Settings.fromJson(List<Map<String, dynamic>> json) {
    var settingsMap = Map<String, String>();

    json.forEach((element) {
      String key = element['setting'];
      settingsMap[key] = element['value'];
    });

    return Settings(settings: settingsMap);
  }

  List<Map<String, dynamic>> toJson() {
    List<Map<String, String>> settingsList = [];

    settings.forEach((key, value) {
      settingsList.add({
        'setting': key,
        'value': value,
      });
    });

    return settingsList;
  }

  String getValueOf(String setting) => settings[setting];

}
