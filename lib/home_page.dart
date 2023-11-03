import 'package:flutter/material.dart';
import 'package:weather_app2/constants/api_const.dart';
import 'package:weather_app2/constants/app_text.dart';
import 'package:weather_app2/constants/app_text_style.dart';
import 'package:weather_app2/models/weather.dart';
import 'package:dio/dio.dart';

import 'components/custom_icon_button.dart';
import 'constants/app_colors.dart';
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
          temp: Response.data['main']['temp'],
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
        backgroundColor: AppColors.white,
        title: Text(
          AppText.appBarTitle,
          style: AppTextStyle.apBar,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
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
                ),
                CustomIconButton(
                  icon: Icons.location_city,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '8',
                  style: AppTextStyle.temp,
                ),
                Image.network(
                  ApiConst.getIcon('02d', 4),
                ),
              ],
            ),
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
                          Text(sn.data!.temp.toString()),
                        ],
                      );
                    } else if (sn.hasError) {
                      return Text(sn.error.toString());
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}