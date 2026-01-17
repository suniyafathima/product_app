import 'package:flutter/material.dart';
import 'package:product_app/model/productmodel.dart';
import 'package:product_app/service/productservice.dart';
import 'package:product_app/view/widget/productcard.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<Product> products = [];
  final ScrollController _scrollController = ScrollController();

  int _skip = 0;
  final int _limit = 8;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        fetchProducts();
      }
    });
  }

  Future<void> fetchProducts() async {
    setState(() => _isLoading = true);

    final newProducts = await ProductService.fetchProducts(
      limit: _limit,
      skip: _skip,
    );

    setState(() {
      _skip += _limit;
      _isLoading = false;
      if (newProducts.length < _limit) _hasMore = false;
      products.addAll(newProducts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      appBar: AppBar(
         elevation: 0,
        scrolledUnderElevation: 0, 
       surfaceTintColor: Colors.transparent,
      backgroundColor:  Colors.transparent,
 foregroundColor: Colors.black,
        title: const Text(
          'Discover',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.grey.withAlpha(50),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search products',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          /// PRODUCT GRID
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length + 1,
              itemBuilder: (context, index) {
                if (index < products.length) {
                  return ProductGridCard(product: products[index]);
                }
                return _isLoading
                    ? const Center(
                        child: CircularProgressIndicator())
                    : const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
