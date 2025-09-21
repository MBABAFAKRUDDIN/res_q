import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '321b1e1768f68025fd9b87e1080d783b';

  Future<Map<String, dynamic>?> fetchWeather(double lat, double lon) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to load weather data');
      }
    } catch (e) {
      print('Error fetching weather: $e');
    }
    return null;
  }
}
