class ApiConst {
  static const String address =
      'https://api.openweathermap.org/data/2.5/weather?q=osh,&appid=41aa18abb8974c0ea27098038f6feb1b';
  static getIcon(String iconCode, int size) =>
      'https://openweathermap.org/img/wn/$iconCode@${size}x.png';
}