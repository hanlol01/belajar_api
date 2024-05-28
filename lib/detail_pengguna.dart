import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';

class UserDetailPage extends StatefulWidget {
  final int userId;

  UserDetailPage({required this.userId});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late Future<User> futureUser;

  Future<User> fetchUserById(int id) async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users/$id'));

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return User.fromJson(parsed['data']);
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  void initState() {
    super.initState();
    futureUser = fetchUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<User>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Text('${snapshot.data!.firstName} ${snapshot.data!.lastName}');
              } else if (snapshot.hasError) {
                return Text('Error');
              }
            }
            return Text('Loading...');
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<User>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final user = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.avatar),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'ID: ${user.id}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Selamat datang, ${user.firstName} ${user.lastName}!',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Email: ${user.email}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
