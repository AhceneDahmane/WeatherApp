import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});
  @override
  State<WeatherPage> createState() => _WeatherPageState() ;
}
class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('37b9fd2cc2a99937efe959e232b86586');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getweather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    catch (e){
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }
 String getWeatherAnimation(String? mainCondition)
 {
   if (mainCondition == null) return 'assets/Sunny.json';

   switch (mainCondition.toLowerCase()){
     case 'clouds':
     case 'mist':
     case 'smoke':
     case 'haze':
     case 'dust':
     case 'fog':
       return 'assets/windy.json';
     case 'rain':
     case 'drizzle':
     case 'shower rain':
       return 'assets/Rainny_Day.json';
     case 'thunderstorm':
       return 'assets/storm.json';
     case 'clear':
       return
         'assets/sunny.json';
     default:
       return  'assets/sunny.json';
   }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text (_weather?.cityName ?? "loading city.."
          ),
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
          Text(('${_weather?.temperature.round()} °C')),
          Text (_weather?.mainCondition ?? ""),
        ],
      )
      ),
    );
  }
}