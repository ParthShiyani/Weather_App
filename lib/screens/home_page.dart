import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/helper/weather_api_helper.dart';
import 'package:weather_app/models/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle mystyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );

  final TextEditingController searchController = TextEditingController();

  late Future<Weather?> getWetherData;

  @override
  void initState() {
    super.initState();
    getWetherData = WeatherAPIHelper.apiHelper.fetchWeatherData(city: "surat");
    searchController.text = "Surat";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Wether App"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getWetherData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            Weather? data = snapshot.data;

            return Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                        left: 10,
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          // hintText: "City Name",
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                              onPressed: () {
                                String searchedData = searchController.text;
                                if (searchedData != "") {
                                  setState(() {
                                    getWetherData = WeatherAPIHelper.apiHelper
                                        .fetchWeatherData(city: searchedData);
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                              )),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 14,
                    child: Column(
                      children: [
                        Card(
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_outlined),
                                      Text(
                                        searchController.text,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Spacer(),
                                      Text(
                                        ("${(data!.temp - 273.15).toInt()}°C "),
                                        style: TextStyle(fontSize: 30),
                                      ),
                                      Text(
                                        ("${data!.name}"),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 200,
                                  width: 300,
                                  child: (data!.name == "Haze")
                                      ? Image.asset("assets/images/haze.png")
                                      : (data!.name == "Mist")
                                          ? Image.asset(
                                              "assets/images/mist.jpg")
                                          : (data!.name == "Clouds")
                                              ? Image.asset(
                                                  "assets/images/cloud.jpg",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  "assets/images/clear`.jpg"),
                                ),
                              ],
                            ),
                          ),
                          margin: EdgeInsets.all(20),
                          elevation: 10,
                        ),
                        getCard2(
                            ic: "🌤",
                            title: "Feels like",
                            trail: Text("${(data.temp - 273.15).toInt()}°C")),
                        getCard2(
                            ic: "💧",
                            title: "Humidity",
                            trail: Text("${data.humidity}%")),
                        getCard(
                          ic: Icons.speed,
                          color: Colors.red,
                          title: "Wind Speed",
                          trail: Text("${data.speed}"),
                        ),
                        getCard(
                          ic: Icons.rotate_90_degrees_cw,
                          color: Colors.indigo.withOpacity(0.6),
                          title: "Wind Degree",
                          trail: Text("${data.degree}"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  getCard({required ic, required color, required title, required trail}) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        child: ListTile(
          leading: Icon(
            ic,
            size: 35,
            color: color,
          ),
          title: Text(title),
          trailing: trail,
        ),
      ),
    );
  }

  getCard2({required ic, required title, required trail}) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        child: ListTile(
          leading: Text(
            ic,
            style: TextStyle(fontSize: 30),
          ),
          title: Text(title),
          trailing: trail,
        ),
      ),
    );
  }
}
