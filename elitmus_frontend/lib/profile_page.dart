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
              itemBuilder: (ctx, index) {
                Advertisement advertisement = GlobalConfigs.allAdvertisements
                    .where((element) => element.userId == GlobalConfigs.id)
                    .elementAt(index);
                return ListTile(
                  title: Text(advertisement.title),
                  subtitle: Text(advertisement.description),
                  trailing: IconButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewAdvertisementPage(
                            editMode: true,
                            id: advertisement.id,
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
                        title: advertisement.title,
                        description: advertisement.description,
                        id: advertisement.id,
                        comments: advertisement.comments,
                      ),
                    ),
                  ),
                );
              },
              itemCount: GlobalConfigs.allAdvertisements.where((element) => element.userId == GlobalConfigs.id)
                  .length,
            ),
          )
        ],
      ),
    );
  }
}
