import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';

class WeatherAPIHelper {
  WeatherAPIHelper._();

  static final WeatherAPIHelper apiHelper = WeatherAPIHelper._();

  Future<Weather?> fetchWeatherData({required String city}) async {
    final String baseURL = "https://api.openweathermap.org/data/2.5";
    final String endPoint =
        "/weather?q=$city&appid=4d31cc28bd98a6b5f060389bf4cd5437";
    http.Response res = await http.get(
      Uri.parse(baseURL + endPoint),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> decodedData = jsonDecode(res.body);

      Weather weather = Weather.fromJson(json: decodedData);
      return weather;
    }
    return null;
  }
}
