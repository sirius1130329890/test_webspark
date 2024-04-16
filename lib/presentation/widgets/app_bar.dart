import 'package:flutter/material.dart';

AppBar myAppBar(String title) => AppBar(
  backgroundColor: Colors.lightBlueAccent,
  title: Text(title, style: const TextStyle(color: Colors.white),),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
);