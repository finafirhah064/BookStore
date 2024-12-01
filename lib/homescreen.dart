import 'package:flutter/material.dart';
import 'RomanceScreen.dart';
import 'HororScreen.dart';
import 'ThrillerScreen.dart';
import 'api_service_home.dart'; 
import 'Detailbook.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'ALL';
  List<dynamic> bestsellers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      setState(() {
        isLoading = true;
      });
      final apiService = ApiService();
      bestsellers = await apiService.fetchBooks(2020) ?? [];
      print("Bestsellers: $bestsellers");
    } catch (e) {
      print("Error fetching books: $e");
      bestsellers = []; // Set data kosong jika ada error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: Text(
          'Book Store',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink[100],
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.search, color: Colors.purple),
                      hintText: 'Cari buku...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) {
                      print('Searching for: $value');
                    },
                  ),
                ),
                // Container untuk bagian Rekomendasi (Horizontal)
                Container(
                  color: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Rekomendasi untuk Anda',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: bestsellers.length,
                          itemBuilder: (context, index) {
                            final book = bestsellers[index];
                            final cover = book['cover'] ?? 'https://via.placeholder.com/120x180';

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookDetailScreen(bookId: book['book_id']),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    cover,
                                    width: 120,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 120,
                                        height: 180,
                                        color: Colors.grey,
                                        child: Center(
                                          child: Icon(Icons.broken_image, color: Colors.white),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Container untuk bagian Bestsellers (Vertikal)
                // Container untuk bagian Bestsellers (Vertikal)
Expanded(
  child: Container(
    decoration: BoxDecoration(
      color: Colors.purple[700], // Warna background
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30), // Radius atas membentuk setengah lingkaran
      ),
    ),
    padding: const EdgeInsets.symmetric(vertical: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Bestsellers',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: bestsellers.length,
            itemBuilder: (context, index) {
              final book = bestsellers[index];

              final bookId = book['book_id'] ?? 'Unknown ID';
              final name = book['name'] ?? 'No Title';
              final category = book['category'] ?? 'No Category';
              final cover = book['cover'] ?? 'https://via.placeholder.com/80x120';
              final url = book['url'] ?? '#';

              return BookItemVertical(
                bookId: bookId,
                name: name,
                category: category,
                cover: cover,
                url: url,
              );
            },
          ),
        ),
      ],
    ),
  ),
),
              ],
            ),
      bottomNavigationBar: FooterCategories(
        selectedCategory: selectedCategory,
        onCategorySelected: (category) {
          setState(() {
            selectedCategory = category;
            fetchBooks(); // Memperbarui daftar buku berdasarkan kategori
          });
        },
      ),
    );
  }
}

class BookItemVertical extends StatelessWidget {
  final String bookId;
  final String name;
  final String category;
  final String cover;
  final String url;

  BookItemVertical({
    required this.bookId,
    required this.name,
    required this.category,
    required this.cover,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailScreen(bookId: bookId),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Cover Buku
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                cover,
                height: 120,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    width: 80,
                    color: Colors.grey,
                    child: Center(
                      child: Icon(Icons.broken_image, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 16),
            // Detail Buku
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Book ID: $bookId",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Category: $category",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "URL: ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Opening URL: $url");
                    },
                    child: Text(
                      url,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FooterCategories extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  FooterCategories({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'title': 'ALL', 'icon': Icons.library_books},
      {'title': 'ROMANCE', 'icon': Icons.favorite},
      {'title': 'HORROR', 'icon': Icons.emoji_objects},
      {'title': 'THRILLER', 'icon': Icons.warning},
    ];

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.pink[100],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: categories.map((category) {
          final isSelected = selectedCategory == category['title'];
          return GestureDetector(
            onTap: () {
              if (category['title'] == 'ROMANCE') {
                // Navigasi ke halaman RomanceScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RomanceScreen()),
                );
              } else if (category['title'] == 'HORROR') {
                // Navigasi ke halaman HorrorScreen (tambahkan halaman ini)
                Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => Hororscreen()), // Ganti dengan halaman Anda
                );
              } else if (category['title'] == 'THRILLER') {
                // Navigasi ke halaman ThrillerScreen (tambahkan halaman ini)
                Navigator.push(
                 context,
                MaterialPageRoute(builder: (context) => ThrillerScreen()), // Ganti dengan halaman Anda
                 );
              } else {
                // Untuk kategori ALL atau kategori lain
                onCategorySelected(category['title'] as String);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category['icon'] as IconData,
                  color: isSelected ? Colors.purple : Colors.black,
                ),
                SizedBox(height: 4),
                Text(
                  category['title'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.purple : Colors.black,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
