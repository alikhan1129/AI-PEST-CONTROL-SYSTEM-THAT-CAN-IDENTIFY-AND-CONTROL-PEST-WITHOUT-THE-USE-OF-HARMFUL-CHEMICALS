import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(PestApp());

class PestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: PestHome(),
    );
  }
}

class PestHome extends StatefulWidget {
  @override
  _PestHomeState createState() => _PestHomeState();
}

class _PestHomeState extends State<PestHome> {
  File? imageFile;
  String? pest;
  String? pesticide;
  bool loading = false;
  List<Map<String, dynamic>> history = [];
  List<Map<String, dynamic>> filteredHistory = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? saved = prefs.getStringList('pest_history');
    if (saved != null) {
      setState(() {
        history = saved.map((e) => json.decode(e)).toList().cast<Map<String, dynamic>>();
        filteredHistory = [...history];
      });
    }
  }

  Future<void> saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> data = history.map((e) => json.encode({
      'timestamp': e['timestamp'],
      'pest': e['pest'],
      'pesticide': e['pesticide']
    })).toList();
    await prefs.setStringList('pest_history', data);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
        pest = null;
        pesticide = null;
      });
      await sendImageToAPI(File(picked.path));
    }
  }

  Future<void> sendImageToAPI(File image) async {
    setState(() => loading = true);

    final uri = Uri.parse('http://127.0.0.1:5000/predict');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    var response = await request.send();

    final resBody = await response.stream.bytesToString();
    final data = json.decode(resBody);

    final entry = {
      'timestamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      'pest': data['pest'] ?? '',
      'pesticide': data['recommended_pesticide'] ?? '',
      'imagePath': image.path
    };

    setState(() {
      pest = data['pest'];
      pesticide = data['recommended_pesticide'];
      history.insert(0, entry);
      filteredHistory = [...history];
      saveHistory();
    });
  }

  Widget historyTile(Map<String, dynamic> entry) {
    return ListTile(
      leading: entry['imagePath'] != null
          ? Image.file(File(entry['imagePath']), width: 50, height: 50, fit: BoxFit.cover)
          : Icon(Icons.bug_report, color: Colors.green.shade700),
      title: Text("Pest: ${entry['pest'].toString().toUpperCase()}"),
      subtitle: Text("Pesticide: ${entry['pesticide']}\n${entry['timestamp']}", style: TextStyle(fontSize: 12)),
      isThreeLine: true,
    );
  }

  void filterHistory(String query) {
    setState(() {
      searchQuery = query;
      filteredHistory = history.where((entry) =>
        entry['pest'].toLowerCase().contains(query.toLowerCase()) ||
        entry['pesticide'].toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('AI Pest Identifier'),
          centerTitle: true,
          bottom: TabBar(tabs: [
            Tab(text: "Detect"),
            Tab(text: "History")
          ]),
        ),
        body: TabBarView(children: [
          buildDetectorTab(),
          buildHistoryTab(),
        ]),
      ),
    );
  }

  Widget buildDetectorTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: Icon(Icons.image_search),
              label: Text('Select Pest Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            if (imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(imageFile!, height: 250),
              ),
            if (loading)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            if (pest != null && pesticide != null) ...[
              SizedBox(height: 20),
              Card(
                elevation: 4,
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text("Detected Pest: ${pest!.toUpperCase()}", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Recommended Pesticide: $pesticide"),
                  leading: Icon(Icons.eco, color: Colors.green),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }

  Widget buildHistoryTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search history...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: filterHistory,
          ),
        ),
        Expanded(
          child: filteredHistory.isEmpty
              ? Center(child: Text("No matching history found."))
              : ListView.builder(
                  itemCount: filteredHistory.length,
                  itemBuilder: (context, index) => historyTile(filteredHistory[index]),
                ),
        )
      ],
    );
  }
}
