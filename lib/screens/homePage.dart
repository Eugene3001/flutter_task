import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:my_app/data/user.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  StateHomePage createState() => new StateHomePage();
}

class StateHomePage extends State<HomePage> {
  Future<List<User>> getUsers() async {
    var data = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/vyatsykiv/Flutter-Task/main/users.json"));

    var jsonData = json.decode(data.body);
    List<User> users = [];

    for (var u in jsonData) {
      // An attempt to handle the error should have been here
      User user = User(u["id"], u["name"], u["picture"], u["title"], u["text"]);
      users.add(user);
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
        actions: <Widget>[
          IconButton(
            icon: ImageIcon(AssetImage('lib/icons/ic_search_white.png')),
            onPressed: () => {},
            color: Colors.white,
          ),
          IconButton(
            icon: ImageIcon(AssetImage('lib/icons/ic_check_circle_white.png')),
            onPressed: () => {},
            color: Colors.white,
          ),
        ],
      ),
      body: Container(
          child: FutureBuilder(
        future: getUsers(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text("Loading..."),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data[index].picture)),
                    title: Text(
                        snapshot.data[index].name +
                            "\n" +
                            snapshot.data[index].title,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      snapshot.data[index].text,
                      maxLines: 1,
                    ));
              },
            );
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () => {},
          child: ImageIcon(
            AssetImage("lib/icons/ic_add_black.png"),
            color: Colors.black,
          ),
          backgroundColor: Colors.cyanAccent),
    );
  }
}
