import 'package:flutter/material.dart';
import 'api_service_home.dart'; 
import 'homescreen.dart';
import 'Detailbook.dart';
class ThrillerScreen extends StatefulWidget {
  @override
  _ThrillerScreen createState() => _ThrillerScreen();
}

class _ThrillerScreen extends State<ThrillerScreen> {
  bool isLoading = true;
  List<dynamic> books = [];

  @override
  void initState() {
    super.initState();
    fetchRomanceBooks();
  }

  Future<void> fetchRomanceBooks() async {
    try {
      final apiService = ApiService();
      books = await apiService.fetchBooksByGenre('Thriller', 10); // Fetch 10 books
    } catch (e) {
      print("Error fetching books: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 203, 3, 239),
      appBar: AppBar(
        title: Text('Thriller Books'),
        backgroundColor: Colors.pink[100],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Thriller Books...',
                  prefixIcon: Icon(Icons.search, color: Colors.purple),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Book List Section
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.purple))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailScreen(
                                  bookId: book['book_id'].toString(),
                                ),
                              ),
                            );
                          },
                          child: _buildBookCard(
                            title: book['name'],
                            coverUrl: book['cover'],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard({required String title, required String coverUrl}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Cover Image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(coverUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Book Title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.purple[900],
              ),
            ),
          ),
        ],
      ),
    );
  }
}