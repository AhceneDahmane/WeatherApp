import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('37b9fd2cc2a99937efe959e232b86586');
  TextEditingController _cityController = TextEditingController();
  Weather? _weather;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  _fetchWeatherForCity(String cityName) async {
    if (cityName.isEmpty) return;

    try {
      final weather = await _weatherService.getweather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
      // Optionally handle the error
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
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
        return 'assets/Rainy_Day.json';
      case 'thunderstorm':
        return 'assets/storm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'Enter City Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _fetchWeatherForCity(_cityController.text);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _weather == null
                ? Center(child: CircularProgressIndicator())
                : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_weather?.cityName ?? "Loading city...",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                  Text('${_weather?.temperature.round()} °C',
                      style: TextStyle(fontSize: 36, color: Colors.deepOrange)),
                  Text(_weather?.mainCondition ?? "",
                      style: TextStyle(fontSize: 20, color: Colors.teal)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
