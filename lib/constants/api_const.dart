class ApiConst {
  static  String address (String name) =>
      'https://api.openweathermap.org/data/2.5/weather?q=$name,&appid=41aa18abb8974c0ea27098038f6feb1b';
  static getIcon(String iconCode, int size) =>
      'https://openweathermap.org/img/wn/$iconCode@${size}x.png';
  static String latLongAddress (double lat, double long) =>
      'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$long&exclude=hourly,daily,minutely&appid=41aa18abb8974c0ea27098038f6feb1b';
}