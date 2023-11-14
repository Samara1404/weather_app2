import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app2/components/custom_icon_button.dart';
import 'package:weather_app2/constants/api_const.dart';
import 'package:weather_app2/constants/app_colors.dart';
import 'package:weather_app2/constants/app_text.dart';
import 'package:weather_app2/constants/app_text_style.dart';
import 'package:weather_app2/models/weather.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

List cities = <String>[
  'Bishkek',
  'Osh',
  'Batken',
  'Talas',
  'Tokmok',
  'Jalal-Abad',
  'Karakol',
  'Moscow',
  'Paris',
  'Rome',
  'Tokyo',
  'Beijing'
];

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Weather? weather;
  Future<void> weatherLocatio() async {
    setState(() {
      weather = null;
    });
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always &&
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition();
        final dio = Dio();
        final resp = await dio.get(
            ApiConst.latLongAddress(position.latitude, position.longitude));
        if (resp.statusCode == 200) {
          weather = Weather(
            id: resp.data['current']['weather'][0]['id'],
            main: resp.data['current']['weather'][0]['main'],
            description: resp.data['current']['weather'][0]['description'],
            icon: resp.data['current']['weather'][0]['icon'],
            city: resp.data['timezone'],
            // country: resp.data['sys']['country'],
            temp: resp.data['current']['temp'],
          );
        }
        setState(() {});
        // print(position.latitude);
        // print(position.longitude);
          }
      } else {
        Position position = await Geolocator.getCurrentPosition();
        final dio = Dio();
        final resp = await dio.get(
            ApiConst.latLongAddress(position.latitude, position.longitude));
        if (resp.statusCode == 200) {
          weather = Weather(
            id: resp.data['current']['weather'][0]['id'],
            main: resp.data['current']['weather'][0]['main'],
            description: resp.data['current']['weather'][0]['description'],
            icon: resp.data['current']['weather'][0]['icon'],
            city: resp.data['timezone'],
            temp: resp.data['current']['country']['temp'],
          );
        }
        setState(() {});
      }
    } 
      
    Future<void>? weatherName([String? name]) async {
      // await Future.delayed(Duration(seconds: 3));
      final dio = Dio();
      var response2 = await dio.get(ApiConst.address(name ?? 'Bishkek'));
      final response = response2;
      if (response.statusCode == 200) {
         weather = Weather(
          id: response.data['weather'][0]['id'],
          main: response.data['weather'][0]['main'],
          description: response.data['weather'][0]['description'],
          icon: response.data['weather'][0]['icon'],
          city: response.data['name'],
          country: response.data['sys']['country'],
          temp: response.data['main']['temp'],
        );
        setState(() {});
      }
    }

    @override
    void initState() {
      super.initState();
      weatherName();
    }
@override
    Widget build(BuildContext context) {
      log('max w ${MediaQuery.of(context).size.width}');
      log('max h ${MediaQuery.of(context).size.height}');
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: const Text(
            AppText.appBarTitle,
            style: AppTextStyle.appBar,
          ),
          centerTitle: true,
        ),
        body: weather == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('/weather.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          icon: Icons.near_me,
                          onPressed: () async {
                            await weatherLocatio();
                          },
                        ),
                        CustomIconButton(
                          icon: Icons.location_city,
                          onPressed: () {showBottom();},
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('${(weather!.temp - 273.15).round()}',
                            style: AppTextStyle.temp),
                        Image.network(
                          ApiConst.getIcon(weather!.icon, 4),
                          height: 200,
                          fit: BoxFit.fitHeight,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          weather!.description.replaceAll(' ', '\n'),
                          textAlign: TextAlign.right,
                          style: AppTextStyle.body,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Column(
                          children: [
                            Icon(
                              Icons.web_asset,
                              size: 50,
                              color: Colors.white,
                            ),
                            Icon(
                              Icons.access_alarm,
                              size: 50,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: FittedBox(
                        child: Text(
                          weather!.city,
                          style: AppTextStyle.body,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      );
    }
  
  void showBottom() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.fromLTRB(15, 20, 15, 7),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 18, 18, 18),
            border: Border.all(color: Colors.blue),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: ListView.builder(
            itemCount: cities.length,
            itemBuilder: (BuildContext context, int index) {
              final city = cities[index];
return Card(
                child: ListTile(
                  onTap: () async {
                    setState(() {
                      weather = null;
                    });
                    weatherName(city);
                    Navigator.pop(context);
                  },
                  title: Text(city),
                ),
              );
            },
          ),
        );
      },
    );
  }  
}