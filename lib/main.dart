import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  String _translatedText = "";
  String _sourceLanguage = 'en';
  String _targetLanguage = 'es';

  // Словарь поддерживаемых языков
  final Map<String, String> _languages = {
    'en': 'English',
    'es': 'Spanish',
    'ru': 'Russian',
    // Добавьте другие языки по желанию
  };

  Future<void> translateText() async {
    final apiKey = 'AIzaSyBAGA2GD1kiObmvtiTeR9sx-8FL3wYt-Go'; // Замените YOUR_API_KEY_HERE на ваш реальный ключ API
    final url = Uri.parse('https://translation.googleapis.com/language/translate/v2?key=$apiKey');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'q': _controller.text,
          'source': _sourceLanguage,
          'target': _targetLanguage,
        }),
      );

      final jsonResponse = json.decode(response.body);
      final translations = jsonResponse['data']['translations'];
      if (translations.isNotEmpty) {
        setState(() {
          _translatedText = translations[0]['translatedText'];
        });
      }
    } catch (e) {
      setState(() {
        _translatedText = 'Error translating text.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Translator')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter text to translate',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            DropdownButton<String>(
              value: _sourceLanguage,
              onChanged: (value) {
                setState(() {
                  _sourceLanguage = value!;
                });
              },
              items: _languages.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(_languages[value]!),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: _targetLanguage,
              onChanged: (value) {
                setState(() {
                  _targetLanguage = value!;
                });
              },
              items: _languages.keys.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(_languages[value]!),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: translateText,
              child: Text('Translate'),
            ),
            SizedBox(height: 20),
            Text(
              _translatedText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
