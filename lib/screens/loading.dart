import 'package:flutter/material.dart';
import 'package:weather_app/data/my_location.dart';
import 'package:weather_app/data/network.dart';
import 'package:weather_app/screens/weather_screen.dart';

const apikey = '2d0b9df3630730263dd41e14f37ccb9e';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  // 위도
  late double latitude3;
  // 경도
  late double longitude3;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    MyLocation myLocation = MyLocation();
    await myLocation.getMyCurrentLocation();
    latitude3 = myLocation.latitude2;
    longitude3 = myLocation.longitude2;

    print('위도3: $latitude3');
    print('경도3: $longitude3');

    NetWork netWork = NetWork(
        'https://api.openweathermap.org/data/2.5/weather'
            '?lat=$latitude3&lon=$longitude3&appid=$apikey&units=metric',
        'https://api.openweathermap.org/data/2.5/air_pollution'
            '?lat=$latitude3&lon=$longitude3&appid=$apikey&units=metric');
    var weatherData = await netWork.getJsonData();
    print(weatherData);

    var airData = await netWork.getAirData();
    print(airData);

    // Navigate to WeatherScreen once data is fetched
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return WeatherScreen(
            parseWeatherData: weatherData,
            parseAirPollution: airData,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // You can return a loading widget here if needed
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
