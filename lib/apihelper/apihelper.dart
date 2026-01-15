import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  static Future<Map<String, dynamic>> get(String url) async {
    final http.Response response =
        await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)
          as Map<String, dynamic>;
    } else {
      throw Exception('API Error');
    }
  }
}
