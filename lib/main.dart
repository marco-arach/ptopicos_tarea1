import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textEditingController = TextEditingController();
  String _translatedText = '';
  String _selectedLanguage = 'en';
  String _apiKey = 'API_KEY';

  Future<void> _translateText() async {
    String textToTranslate = _textEditingController.text;
    String endpoint = 'https://translation.googleapis.com/language/translate/v2';
    String url = '$endpoint?key=$_apiKey&q=$textToTranslate&target=$_selectedLanguage';

    try {
      final response = await http.post(Uri.parse(url));
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('data') && data['data'].containsKey('translations')) {
        setState(() {
          _translatedText = data['data']['translations'][0]['translatedText'];
        });
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PTopicos-Tarea 01'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'Ingresa el texto a traducir',
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Traducir a: '),
                  DropdownButton<String>(
                    value: _selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('Inglés'),
                      ),
                      DropdownMenuItem(
                        value: 'es',
                        child: Text('Español'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _translateText(),
                child: Text('Traducir'),
              ),
              SizedBox(height: 30),
              Text('Traducción:', style: Theme.of(context).textTheme.headline6),
              Text(_translatedText, style: TextStyle(color: Colors.blueAccent)),
            ],
          ),
        ),
      ),
    );
  }
}
