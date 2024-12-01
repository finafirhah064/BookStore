import 'dart:convert';
import 'package:http/http.dart' as http;
class ApiService {
  final String baseUrl = "https://hapi-books.p.rapidapi.com";
  final Map<String, String> headers = {
    'x-rapidapi-host': 'hapi-books.p.rapidapi.com',
    'x-rapidapi-key': 'c52c4338e3mshbeaa82f3e8b0939p1ebc2djsnc61711fbcc37',
  };

  Future<List<dynamic>> fetchBooks(int year) async {
    final url = Uri.parse('$baseUrl/top/$year');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch books. Status code: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchBookDetails(String bookId) async {
    final url = Uri.parse('$baseUrl/book/$bookId');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch book details. Status code: ${response.statusCode}');
    }
  }
  Future<List<dynamic>> fetchBooksByGenre(String genre, int limit) async {
  final url = Uri.parse('$baseUrl/week/$genre/$limit');
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch books by genre. Status code: ${response.statusCode}');
  }
}
}
