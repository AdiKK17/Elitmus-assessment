import 'dart:convert';

import 'package:flutter/material.dart';

import 'comment_model.dart';
import 'global_config.dart';

import "package:dio/dio.dart";

class AdvertisementPage extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final List<Comment> comments;

  AdvertisementPage(
      {this.title = "",
      this.description = "",
      required this.id,
      required this.comments});

  @override
  _AdvertisementPageState createState() => _AdvertisementPageState();
}

class _AdvertisementPageState extends State<AdvertisementPage> {
  bool _isLoading = true;
  final TextEditingController _commentController = TextEditingController();

  Future<void> _getComments() async {
    try {
      final response =
          await Dio().get('${GlobalConfigs.baseURl}/comment/${widget.id}');
      widget.comments.clear();
      response.data.forEach((cmnt) {
        final comment = Comment.fromJson(cmnt);
        widget.comments.insert(0, comment);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text == "") {
      return;
    }

    final response = await Dio().post(
      '${GlobalConfigs.baseURl}/comment',
      data: jsonEncode(
        {
          'comment': _commentController.text,
          'advertisement_id': widget.id,
          'user_id': GlobalConfigs.id
        },
      ),
    );
    print(response);

    final cnt = Comment.fromJson(response.data);
    widget.comments.insert(0, cnt);
  }

  @override
  void initState() {
    super.initState();
    _getComments().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> openDialog() async {
    bool isLoading = false;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, ss) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: 200,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              child: TextField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText:
                                        'Add comment to this advertisement'),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                ss(() => isLoading = true);
                                await _addComment();
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Text("Add Comment"),
                            )
                          ],
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: openDialog,
            icon: Icon(Icons.add_comment),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              widget.description,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Divider(),
          _isLoading
              ? CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) => ListTile(
                        title: Text(widget.comments[index].comment),
                        leading: Text((index + 1).toString())),
                    itemCount: widget.comments.length,
                  ),
                ),
        ],
      ),
    );
  }
}
