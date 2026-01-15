import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product_app/model/productmodel.dart';

class ProductService {
  static Future<List<Product>> fetchProducts({
    required int limit,
    required int skip,
  }) async {
    final String url =
        'https://dummyjson.com/products?limit=$limit&skip=$skip';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load products');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    final List productsJson = data['products'];

    return productsJson
        .map<Product>((json) => Product.fromJson(json))
        .toList();
  }
}
