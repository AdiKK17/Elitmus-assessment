import 'dart:convert';

import 'package:elitmus/global_config.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'advertisement_model.dart';

class NewAdvertisementPage extends StatefulWidget {
  final bool editMode;
  final String id;

  NewAdvertisementPage({this.editMode = false, this.id = ""});

  @override
  _NewAdvertisementPageState createState() => _NewAdvertisementPageState();
}

class _NewAdvertisementPageState extends State<NewAdvertisementPage> {
  int index = 0;
  bool _isSwitched = false;
  bool _isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _createAdvertisement() async {
    if (_titleController.text == "" || _descriptionController.text == "") {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      if (widget.editMode) {
        final response = await Dio().put(
          '${GlobalConfigs.baseURl}/advertisement/${GlobalConfigs.allAdvertisements[index].id}',
          data: jsonEncode({
            'title': _titleController.text,
            'description': _descriptionController.text,
            "publish": _isSwitched,
            "user_id": GlobalConfigs.id.toString(),
          }),
          options: Options(
            headers: {
              "Authorization": "Bearer ${GlobalConfigs.token.toString()}"
            },
          ),
        );
        if (response.statusCode == 200) {
          final ad = Advertisement.fromJson(response.data);
          GlobalConfigs.allAdvertisements[index].publish = ad.publish;
          GlobalConfigs.allAdvertisements[index].title = ad.title;
          GlobalConfigs.allAdvertisements[index].description =
              ad.description;
        }
        Navigator.pop(context);
        return;
      }
      final response = await Dio().post(
        '${GlobalConfigs.baseURl}/advertisement',
        data: jsonEncode({
          'title': _titleController.text,
          'description': _descriptionController.text,
          "publish": _isSwitched,
          "user_id": GlobalConfigs.id.toString(),
        }),
        options: Options(
          headers: {
            "Authorization": "Bearer ${GlobalConfigs.token.toString()}"
          },
        ),
      );

      final ad = Advertisement.fromJson(response.data);
      GlobalConfigs.allAdvertisements.insert(0, ad);

      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      index = GlobalConfigs.allAdvertisements
          .indexWhere((element) => element.id == widget.id);
      _titleController.text =
          GlobalConfigs.allAdvertisements[index].title;
      _descriptionController.text =
          GlobalConfigs.allAdvertisements[index].description;
      _isSwitched = GlobalConfigs.allAdvertisements[index].publish;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Advertisement"),
        actions: [
          widget.editMode
              ? IconButton(
                  onPressed: () async {
                    try{
                      setState(() {
                        _isLoading = true;
                      });
                      final response = await Dio().delete(
                        '${GlobalConfigs.baseURl}/advertisement/${GlobalConfigs.allAdvertisements[index].id}',
                        options: Options(
                          headers: {
                            "Authorization":
                            "Bearer ${GlobalConfigs.token.toString()}"
                          },
                        ),
                      );
                      if (response.statusCode == 200) {
                        GlobalConfigs.allAdvertisements.removeAt(index);
                      }
                    } catch(e){
                      print(e);
                    }
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.delete),
                )
              : Container()
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter advertisement title'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter advertisement description'),
                  ),
                ),
                ListTile(
                  leading: Text("Publish:"),
                  trailing: Switch(
                    value: _isSwitched,
                    onChanged: (value) {
                      setState(() {
                        _isSwitched = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: _createAdvertisement,
                  child: Text(widget.editMode ? "Save Changes" : "Create"),
                )
              ],
            ),
    );
  }
}
