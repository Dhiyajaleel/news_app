import 'package:flutter/material.dart';
import 'news_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NewsService newsService =
      NewsService('12ab8d78fc184ce9a39fe5ac08bbc4fa');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        hintColor: Colors.red,
        fontFamily: 'Arial',
      ),
      home: NewsScreen(newsService: newsService),
    );
  }
}

class NewsScreen extends StatefulWidget {
  final NewsService newsService;

  NewsScreen({required this.newsService});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<dynamic>> newsFuture;

  @override
  void initState() {
    super.initState();
    newsFuture = widget.newsService.getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LATEST NEWS', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic>? newsData = snapshot.data as List<dynamic>?;

            if (newsData == null || newsData.isEmpty) {
              return Center(child: Text('No news available.'));
            }

            return NewsList(newsData: newsData);
          }
        },
      ),
    );
  }
}

class NewsList extends StatelessWidget {
  final List<dynamic> newsData;

  NewsList({required this.newsData});

  // PlaceholderImageWidget definition
  Widget placeholderImageWidget() {
    // Define your placeholder image widget here
    return Container(
      width: 300.0,
      height: 100.0,
      color: Colors.grey, // Customize the color or image as needed
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newsData.length,
      itemBuilder: (context, index) {
        String title = newsData[index]['title'] ?? 'Title not available';
        String description =
            newsData[index]['description'] ?? 'Description not available';

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(title,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                placeholderImageWidget(),
                Text(description),
              ],
            ),
          ),
        );
      },
    );
  }
}
