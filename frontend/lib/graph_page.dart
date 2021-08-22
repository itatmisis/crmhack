import 'package:flutter/material.dart';
import 'package:frontend/api.dart';

class GraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Граф"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: ListView(
          children: [
            Image.network(graphGifUrl),
          ],
        ),
      ),
    );
  }
}
