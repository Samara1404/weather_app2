import 'dart:developer';
//import 'package:geolocator/geolocator.dart';
import 'package:weather_app2/components/custom_icon_button.dart';
import 'package:weather_app2/constants/api_const.dart';
import 'package:weather_app2/constants/app_colors.dart';
import 'package:weather_app2/constants/app_text.dart';
import 'package:weather_app2/constants/app_text_style.dart';
import 'package:weather_app2/models/weather.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {  
    Future<void> weatherLocatio() async {
      log('------------');
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.always && permission == LocationPermission.whileInUse) {
          await fetchData();
        }
      } else {
        Position position = await Geolocator.getCurrentPosition();
        await fetchData(ApiConst.latLongAddress(position.latitude, position.longitude));
        // print(position.latitude);
        // print(position.longitude);
      }
    }

    Future<Weather?>? fetchData([String? url]) async {
     // await Future.delayed(Duration(seconds: 3));
      final dio = Dio();
      final Response = await dio.get( url ?? ApiConst.address);
      if (Response.statusCode == 200) {
        final Weather weather = Weather(
          id: Response.data['weather'][0]['id'],
          main: Response.data['weather'][0]['main'],
          description: Response.data['weather'][0]['description'],
          icon: Response.data['weather'][0]['icon'],
          city: Response.data['name'],
          country: Response.data['sys']['country'],
          temp: Response.data['main']['temp'],
        );
        return weather;
      }
    }
@override
Widget build(BuildContext context) {    
  // void initState() {
  //     super.initState();
  //   }
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
      body: FutureBuilder<Weather?>(
          future: fetchData(),
          builder: (context, joop) {
            if (joop.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (joop.connectionState == ConnectionState.none) {
              return const Text('Internt jok');
            } else if (joop.connectionState == ConnectionState.done) {
              if (joop.hasError) {
                return Text('${joop.error}');
              } else if (joop.hasData) {
                final Weather = joop.data;
                return Container(
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
                            onPressed: () async {await weatherLocatio();},
                          ),
                          CustomIconButton(
                            icon: Icons.location_city,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('${(Weather!.temp - 273.15).round()}',
                              style: AppTextStyle.temp),
                          Image.network(
                            ApiConst.getIcon('${Weather.icon}', 4),
                            height: 200,
                            fit: BoxFit.fitHeight,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${Weather.description}'.replaceAll(' ', '\n'),
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
                            Weather.city,
                            style: AppTextStyle.body,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Text('Belgisiz kata');
              }
            } else {
              return const Text('Belgisiz kata2');
            }
          }),
    );
  }
}