import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:http/http.dart' as http;

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

class GraphPageTwo extends StatefulWidget {
  const GraphPageTwo({
    Key? key,
  }) : super(key: key);

  @override
  _GraphPageTwoState createState() => _GraphPageTwoState();
}

class _GraphPageTwoState extends State<GraphPageTwo>
    with TickerProviderStateMixin {
  late GifController controller;
  Uint8List? data;
  var started = false;

  @override
  void initState() {
    controller = GifController(vsync: this);

    super.initState();
  }

  Future<Uint8List> _fetch() async {
    final result = await http.get(Uri.parse(graphGifUrl));
    data = result.bodyBytes;
    return data!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Граф II"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: FutureBuilder<Uint8List?>(
          future: _fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [
                  Slider(
                    onChanged: (v) {
                      controller.value = v;
                      setState(() {});
                    },
                    max: 4,
                    min: 0,
                    value: controller.value,
                  ),
                  GifImage(
                    controller: controller,
                    image: MemoryImage(data!),
                    alignment: Alignment.topCenter,
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            return Padding(
              padding: const EdgeInsets.all(15),
              child: const CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class GraphPageThree extends StatefulWidget {
  const GraphPageThree({
    Key? key,
  }) : super(key: key);

  @override
  _GraphPageThreeState createState() => _GraphPageThreeState();
}

class _GraphPageThreeState extends State<GraphPageThree>
    with TickerProviderStateMixin {
  late GifController ctrl1, ctrl2, ctrl3;
  Uint8List? data;
  var started = false;

  @override
  void initState() {
    ctrl1 = GifController(vsync: this);
    ctrl2 = GifController(vsync: this);
    ctrl3 = GifController(vsync: this);

    super.initState();
  }

  Future<Uint8List> _fetch() async {
    final result = await http.get(Uri.parse(graphGifUrl));
    data = result.bodyBytes;
    return data!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Граф III"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: FutureBuilder<Uint8List?>(
          future: _fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ctrl1.value = 0;
              ctrl2.value = 2;
              ctrl3.value = 4;
              return Row(
                children: [
                  GifImage(
                    width: 500,
                    controller: ctrl1,
                    image: MemoryImage(data!),
                    alignment: Alignment.topLeft,
                  ),
                  GifImage(
                    width: 500,
                    controller: ctrl2,
                    image: MemoryImage(data!),
                    alignment: Alignment.topLeft,
                  ),
                  GifImage(
                    width: 500,
                    controller: ctrl3,
                    image: MemoryImage(data!),
                    alignment: Alignment.topLeft,
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            return Padding(
              padding: const EdgeInsets.all(15),
              child: const CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
