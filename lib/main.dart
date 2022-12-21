import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class User {
  String title;
  String pubDate;
  String description;
  String thumbnail;
  // int id;
  // String name;
  // String email;
  // String gender;

  User({
    required this.title,
    required this.pubDate,
    required this.description,
    required this.thumbnail,
    // required this.gender
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print(json);
    return User(
      title: json['title'],
      pubDate: json['pubDate'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      // gender: json['gender']
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final String apiUrl =
      "https://api-berita-indonesia.vercel.app/antara/terbaru";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '171011450030-Agung Samudra',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        body: Container(
          color: Colors.blue.shade100,
          padding: const EdgeInsets.all(8),
          child: FutureBuilder<List<User>>(
            future: fetchUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<User> users = snapshot.data as List<User>;
                return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              height: 100,
                              child: Image.network(users[index].thumbnail),
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 10,
                                    bottom: 2,
                                  ),
                                  width: 160,
                                  child: Text(
                                    users[index].title,
                                    maxLines: 2,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    bottom: 5,
                                  ),
                                  width: 140,
                                  child: Text(
                                    users[index].pubDate,
                                    style: TextStyle(fontSize: 8),
                                  ),
                                ),
                                Container(
                                  width: 140,
                                  child: Text(
                                    users[index].description,
                                    style: TextStyle(fontSize: 8),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                            // Text(users[index].title),
                            // Text(users[index].pubDate),
                            // Text(users[index].description),
                            // Text(users[index].thumbnail),
                          ],
                        ),
                      );
                    });
              }
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text('error');
              }
              return CircularProgressIndicator();
            },
          ),
        ));
  }

  Future<List<User>> fetchUsers() async {
    var response = await http.get(Uri.parse(apiUrl));
    return (json.decode(response.body)['data']['posts'] as List)
        .map((e) => User.fromJson(e))
        .toList();
  }
}
