import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'models/news_article.dart';
import 'widgets/news_card.dart';

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.grey[800], fontSize: 16),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String locationMessage = "Click the button to see local news";
  List<NewsArticle> allArticles = [];
  TextEditingController searchController = TextEditingController();
  List<NewsArticle> filteredArticles = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeArticles();
  }

  void _initializeArticles() {
    allArticles = [
      NewsArticle(
        id: '1',
        title: 'Global Summit',
        content: 'Highlights from the latest global summit.',
        category: 'World',
        categoryIcon: '0xe050', // world icon
        publishedAt: DateTime.now(),
        imageUrl: 'https://picsum.photos/seed/summit/800/400',
      ),
      NewsArticle(
        id: '2',
        title: 'Dodgers Win Championship',
        content: 'The Dodgers celebrate their championship victory.',
        category: 'Sports',
        categoryIcon: '0xe4dc', // sports icon
        publishedAt: DateTime.now(),
        imageUrl: 'https://picsum.photos/seed/sports/800/400',
      ),
      NewsArticle(
        id: '3',
        title: 'Tech Innovation',
        content: 'Latest breakthrough in artificial intelligence and machine learning.',
        category: 'Technology',
        categoryIcon: '0xe32a', // tech icon
        publishedAt: DateTime.now(),
        imageUrl: 'https://picsum.photos/seed/tech/800/400',
      ),
      NewsArticle(
        id: '4',
        title: 'Entertainment News',
        content: 'Latest updates from the entertainment industry.',
        category: 'Entertainment',
        categoryIcon: '0xe40f', // entertainment icon
        publishedAt: DateTime.now(),
        imageUrl: 'https://picsum.photos/seed/entertainment/800/400',
      ),
      NewsArticle(
        id: '5',
        title: 'Science Discovery',
        content: 'New findings in space exploration.',
        category: 'Science',
        categoryIcon: '0xe4e5', // science icon
        publishedAt: DateTime.now(),
        imageUrl: 'https://picsum.photos/seed/science/800/400',
      ),
    ];
    filteredArticles = List.from(allArticles);
  }

  void _onSearch(String query) {
    setState(() {
      filteredArticles = allArticles
          .where((article) =>
              article.title.toLowerCase().contains(query.toLowerCase()) ||
              article.content.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onLike(String articleId) {
    setState(() {
      final article = allArticles.firstWhere((a) => a.id == articleId);
      article.likes++;
    });
  }

  void _onComment(String articleId, String comment) {
    setState(() {
      final article = allArticles.firstWhere((a) => a.id == articleId);
      article.comments.add(Comment(
        id: DateTime.now().toString(),
        userId: 'current_user',
        userName: 'Current User',
        content: comment,
        createdAt: DateTime.now(),
      ));
    });
  }

  void _onSaveToggle(String articleId, bool isSaved) {
    setState(() {
      final article = allArticles.firstWhere((a) => a.id == articleId);
      article.isSaved = isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home Tab
          ListView.builder(
            itemCount: filteredArticles.length,
            itemBuilder: (context, index) {
              final article = filteredArticles[index];
              return NewsCard(
                article: article,
                onSaveToggle: (isSaved) => _onSaveToggle(article.id, isSaved),
                onLike: _onLike,
                onComment: _onComment,
              );
            },
          ),
          // Saved Tab
          ListView.builder(
            itemCount: allArticles.where((a) => a.isSaved).length,
            itemBuilder: (context, index) {
              final savedArticles = allArticles.where((a) => a.isSaved).toList();
              return NewsCard(
                article: savedArticles[index],
                onSaveToggle: (isSaved) =>
                    _onSaveToggle(savedArticles[index].id, isSaved),
                onLike: _onLike,
                onComment: _onComment,
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}
