import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'models/bible_verse.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bible Verses',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BibleVerseScreen(),
    );
  }
}

class BibleVerseScreen extends StatefulWidget {
  @override
  _BibleVerseScreenState createState() => _BibleVerseScreenState();
}

class _BibleVerseScreenState extends State<BibleVerseScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _controller = TextEditingController();
  Verse? verse;
  bool isLoading = false;
  String? errorMessage;

  void _fetchVerse(String query) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final json = await apiService.fetchVerse(query);
      setState(() {
        verse = Verse.fromJson(json);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching verse: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bible Verses'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.pink[50], 
        ),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter verse reference (e.g., John 3:16)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white, 
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String query = _controller.text.trim();
                if (query.isNotEmpty) {
                  _fetchVerse(query);
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.pink, 
              ),
              child: Text('Fetch Verse'),
            ),
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator(),
            if (errorMessage != null) 
              Text(
                errorMessage!, 
                style: TextStyle(color: Colors.red),
              ),
            if (verse != null) VerseCard(verse: verse!),
          ],
        ),
      ),
    );
  }
}


class VerseCard extends StatelessWidget {
  final Verse verse;

  VerseCard({required this.verse});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      color: Colors.pink[100], 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              verse.reference,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Book: ${verse.bookName}, Chapter: ${verse.chapter}, Verse: ${verse.verse}',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 8),
            Text(
              verse.text,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}