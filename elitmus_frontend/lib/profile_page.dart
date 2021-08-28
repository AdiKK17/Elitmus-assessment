import 'package:flutter/material.dart';

import 'main.dart';
import 'new_advertisement_page.dart';
import 'advertisement_model.dart';
import 'advertisement_page.dart';
import 'global_config.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewAdvertisementPage(),
                ),
              );
              setState(() {});
            },
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              GlobalConfigs.allAdvertisements.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => SplashScreen(),
                  ),
                  (Route<dynamic> route) => false);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: Text("Name:"),
            trailing: Text(
              GlobalConfigs.name.toString(),
            ),
          ),
          ListTile(
            leading: Text("Email:"),
            trailing: Text(
              GlobalConfigs.email.toString(),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) {
                int idx = GlobalConfigs.allAdvertisements
                    .indexWhere((element) => element.userId == GlobalConfigs.id);
                return ListTile(
                  title: Text(GlobalConfigs.allAdvertisements[idx].title),
                  subtitle: Text(GlobalConfigs.allAdvertisements[idx].description),
                  trailing: IconButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewAdvertisementPage(
                            editMode: true,
                            index: idx,
                          ),
                        ),
                      );
                      setState(() {});
                    },
                    icon: Icon(Icons.edit),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AdvertisementPage(
                        title: GlobalConfigs.allAdvertisements[idx].title,
                        description: GlobalConfigs.allAdvertisements[idx].description,
                        id: GlobalConfigs.allAdvertisements[idx].id,
                        comments: GlobalConfigs.allAdvertisements[idx].comments,
                      ),
                    ),
                  ),
                );
              },
              itemCount: GlobalConfigs.allAdvertisements
                  .where((element) => element.userId == GlobalConfigs.id)
                  .length,
            ),
          )
        ],
      ),
    );
  }
}
