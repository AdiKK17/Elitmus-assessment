import "package:flutter/material.dart";

import 'advertisement_model.dart';
import 'advertisement_page.dart';
import 'profile_page.dart';
import 'global_config.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  Future<void> setVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    GlobalConfigs.name = prefs.getString("name");
    GlobalConfigs.id = prefs.getString("id");
    GlobalConfigs.email = prefs.getString("email");
    GlobalConfigs.token = prefs.getString("token");
    await _getAllAdvertisements();
  }

  Future<void> _getAllAdvertisements() async {
    try {
      final response = await Dio().get(
          '${GlobalConfigs.baseURl}/relevantAds/1',
          options: Options(headers: {"Authorization": "Bearer ${GlobalConfigs.token}"}));
      response.data.forEach((ad) {
        final advert = Advertisement.fromJson(ad);
        GlobalConfigs.allAdvertisements.insert(0, advert);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    setVariables().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                  ),
                ),
              );
              setState(() {});
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                Advertisement advertisement = GlobalConfigs.allAdvertisements
                    .where((element) => element.publish)
                    .elementAt(index);
                return ListTile(
                  title: Text(advertisement.title),
                  subtitle: Text(advertisement.description),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AdvertisementPage(
                        title: advertisement.title,
                        description: advertisement.description,
                        id: advertisement.id,
                        comments: advertisement.comments,
                      ),
                    ),
                  ),
                );
              },
              itemCount:
                  GlobalConfigs.allAdvertisements.where((element) => element.publish).length,
            ),
    );
  }
}
