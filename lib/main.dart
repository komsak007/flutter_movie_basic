import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_movie_basic/widgets/moviesWidget.dart';
import 'package:http/http.dart' as http;

import 'models/movie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Movie> _movies = <Movie>[];

  @override
  void initState() {
    super.initState();
    _populateAllMovie();
  }

  void _populateAllMovie() async {
    final movie = await _fetchAllMovies();
    // print(movie);
    setState(() {
      _movies = movie;
    });
  }

  Future<List<Movie>> _fetchAllMovies() async {
    final response = await http.get(
        Uri.parse("https://www.omdbapi.com/?s=Batman&page2&apiKey=564727fa"));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["Search"];
      return list.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to load movies!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Movies"),
        ),
        body: MoviesWidget(movies: _movies),
      ),
    );
  }
}
