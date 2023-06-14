import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CoinApp(),
    );
  }
}

class CoinApp extends StatefulWidget {
  const CoinApp({super.key});

  @override
  _CoinAppState createState() => _CoinAppState();
}

class _CoinAppState extends State<CoinApp> {
  int coin_10 = 0;
  int coin_50 = 0;
  int coin_100 = 0;
  int coin_500 = 0;
  int total = 0;

  final coinController = TextEditingController();

  Future<void> updateCoins() async {
    try {
      var url =
          Uri.parse('http://10.0.2.2:8000/run_script/${coinController.text}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          coin_10 = data['coin_10'];
          coin_50 = data['coin_50'];
          coin_100 = data['coin_100'];
          coin_500 = data['coin_500'];
          total = data['total'];
        });
      } else {
        print('Failed to execute script. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: coinController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Coin Number',
              ),
            ),
            Text('10원: $coin_10개'),
            Text('50원: $coin_50개'),
            Text('100원: $coin_100개'),
            Text('500원: $coin_500개'),
            Text('Total: $total원'),
            ElevatedButton(
              onPressed: updateCoins,
              child: const Text('Run Script'),
            ),
          ],
        ),
      ),
    );
  }
}
