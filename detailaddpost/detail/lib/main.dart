import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DetailAddPost(),
    );
  }
}

class DetailAddPost extends StatefulWidget {
  @override
  _DetailAddPostState createState() => _DetailAddPostState();
}

class _DetailAddPostState extends State<DetailAddPost> {
  // URL gambar
  final String imageUrl =
      'https://i.pinimg.com/474x/39/dd/9a/39dd9a62af6558596a7e3c0cb457182c.jpg'; // Ganti dengan URL gambar Anda

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'New Post',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Gambar 400x400
            SizedBox(height: 16),
            Center(
              child: Image.network(
                imageUrl,
                width: 400,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            // Judul Post
            TextField(
              decoration: InputDecoration(
                labelText: 'Add a catchy title',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                hintText:
                    'Writing a long description can help get 3x more views on average.',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 16),
            // Hashtag Input
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.tag, color: Colors.grey),
                hintText: '# Hashtags',
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            // Tombol Share
            ElevatedButton(
              onPressed: () {
                // Aksi saat tombol ditekan
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Post shared successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Share',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
