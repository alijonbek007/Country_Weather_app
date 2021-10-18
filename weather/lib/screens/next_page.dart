import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/modules/weather_api_module.dart';
import 'package:weather/screens/second_page.dart';
import 'package:weather_icons/weather_icons.dart';


class NextPage extends StatefulWidget {
  String image,country, capital,public_name,yaer,population,flag,place;
 
  NextPage(
    this.image,
    this.country,
    this.capital,
    this.public_name,
    this.yaer,
    this.population,
    this.flag,
    this.place,
  );
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    top: 10.0,
                    bottom: 400.0,
                    right: 300.0,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _getWeatherApi(),
                      builder: (context, AsyncSnapshot<Weather> snap) {
                        var data = snap.data;

                        return snap.hasData
                            ? Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      data!.main!.temp! > 288.15
                                          ? WeatherIcons.day_sunny
                                          : WeatherIcons.day_cloudy,
                                      size: 30.0,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 20.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (data.main!.temp! - 273.15).toStringAsFixed(2),
                                          style: const TextStyle(
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          "Wind: " +
                                              data.wind!.speed.toString() +
                                              ",\t" +
                                              data.weather![0].description
                                                  .toString(),
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(height: 150.0);
                      },
                    ),
                    Text(
                      widget.public_name,
                      style: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      widget.capital.toString() + ", " + widget.country,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: const Size(180.0, 50.0),
                            side: const BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Country_Page3(
                                  widget.image,
                                  widget.country,
                                  widget.capital,
                                  widget.public_name,
                                  widget.yaer,
                                  widget.population,
                                  widget.flag,
                                  widget.place,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Preview",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            fixedSize: const Size(180.0, 50.0),
                            side: BorderSide.none,
                            backgroundColor: Colors.greenAccent,
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Start Round",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              widget.image.toString(),
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Future<Weather> _getWeatherApi() async {
    Uri url = Uri.parse(
        "http://api.openweathermap.org/data/2.5/weather?q=${widget.capital}&appid=23b6521f93275a74c7f67f4c0ae8935c");

    var res = await http.get(url);

    if (res.statusCode == 200) {
      return Weather.fromJson(json.decode(res.body));
    } else {
      throw Exception("Xato bor: ${res.statusCode}");
    }
  }
}