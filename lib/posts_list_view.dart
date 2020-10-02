import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class PostsListView extends StatefulWidget {
  @override
  _PostsListViewState createState() => _PostsListViewState();
}

class _PostsListViewState extends State<PostsListView> {
  Future<List<Post>> futurePosts;

  @override
  void initState() {
    futurePosts = fetchPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Post> data = snapshot.data;
          return postsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Post>> fetchPosts() async {
    final postsListAPIUrl = 'https://jsonplaceholder.typicode.com/posts';
    final response = await http.get(postsListAPIUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((post) => new Post.fromJson(post)).toList();
    } else {
      // decide how you want to handle errors
      // throw Exception('Failed to read from API');
      // or
      print('Failed to read from API');
      return [];
    }
  }

  ListView postsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return tile(data[index].id, data[index].title, data[index].body,
              Icons.subject);
        });
  }

  ListTile tile(int id, String title, String body, IconData icon) => ListTile(
        title: Text('$id > $title',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(body),
        leading: Icon(
          icon,
          color: Colors.blue[500],
        ),
      );
}
