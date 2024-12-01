import 'package:flutter/material.dart';
import 'api_service_home.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;

  BookDetailScreen({required this.bookId});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  bool isLoading = true;
  Map<String, dynamic>? bookDetails;

  @override
  void initState() {
    super.initState();
    fetchBookDetails();
  }

  Future<void> fetchBookDetails() async {
    try {
      setState(() {
        isLoading = true;
      });
      final apiService = ApiService();
      bookDetails = await apiService.fetchBookDetails(widget.bookId);
    } catch (e) {
      print("Error fetching book details: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.pink[100],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color.fromARGB(
          255, 211, 132, 225), // Warna background full halaman
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        bookDetails?['cover'] ?? '',
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Book Title
                  Center(
                    child: Text(
                      bookDetails?['name'] ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  SizedBox(height: 10),
                  // Author
                  buildDetailRow(
                    icon: Icons.person,
                    title: "Author",
                    value: bookDetails?['authors']?.join(', ') ?? 'Unknown',
                  ),
                  // Rating
                  buildDetailRow(
                    icon: Icons.star,
                    title: "Rating",
                    value: "${bookDetails?['rating'] ?? 'N/A'} / 5",
                  ),
                  // Pages
                  buildDetailRow(
                    icon: Icons.menu_book,
                    title: "Pages",
                    value: "${bookDetails?['pages'] ?? 'N/A'} pages",
                  ),
                  // Published Date
                  buildDetailRow(
                    icon: Icons.date_range,
                    title: "Published Date",
                    value: bookDetails?['published_date'] ?? 'Unknown',
                  ),
                  // Divider
                  SizedBox(height: 16),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  // Synopsis
                  Text(
                    "Synopsis",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    bookDetails?['synopsis'] ?? 'No Synopsis Available',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple[700]),
          SizedBox(width: 10),
          Text(
            "$title:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
