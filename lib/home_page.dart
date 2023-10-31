import 'package:flutter/material.dart';
import 'package:weather_app2/constants/api_const.dart';
import 'package:weather_app2/models/weather.dart';
import 'package:dio/dio.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Future<Weather?> festData() async {
      final dio = Dio();
      final Response = await dio.get(ApiConst.address);
      if (Response.statusCode == 200) {
        final Weather weather = Weather(
          id: Response.data['weather'][0]['id'],
          main: Response.data['weather'][0]['main'],
          description: Response.data['weather'][0]['description'],
          icon: Response.data['weather'][0]['icon'], 
         city: Response.data['name'],
           country: Response.data['sys']['country'],
          // humidity: Response.data['main']['humidity'],       
        );      
      return weather;
      }
    }

    @override
    void initState() {
      super.initState();
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Weather App'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Center(
              child: FutureBuilder(
                  future: festData(),
                  builder: (ctx, sn) {
                    if (sn.hasData) {
                      return Column(
                        children: [
                          Text(sn.data!.id.toString()),
                          Text(sn.data!.description),
                          Text(sn.data!.main),
                          Text(sn.data!.icon),
                          Text(sn.data!.city),
                           Text(sn.data!.country),
                          // Text(sn.data!.humidity),
                        ],
                      );
                    } else if (sn.hasError) {
                      return Text(sn.error.toString());
                    } else  {return CircularProgressIndicator();}                
                  }),
            ),               
          ],
        ));
  }
}