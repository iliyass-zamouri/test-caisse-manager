import 'package:caisse_manager/data.dart';
import 'package:caisse_manager/product_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    products = List.of(data["products"] as List<dynamic>)
        .map((e) => Product.fromJson(e))
        .toList();
  }

  List<Product>? products;
  List<Product> cart = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF121315),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: ListView(
                  children: cart
                      .map((e) => ProductCartWidget(
                            product: e,
                            onMinus: () {
                              if (e.qte! > 1) {
                                e.qte = e.qte! - 1;
                              } else {
                                cart.remove(e);
                              }
                              setState(() {});
                            },
                            onPlus: () {
                              e.qte = e.qte! + 1;
                              setState(() {});
                            },
                          ))
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          constraints: BoxConstraints(maxHeight: 40),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF353535),
                          ),
                          hintText: "Chercher un produit...",
                          hintStyle:
                              TextStyle(color: Color(0xFF353535), fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                  )),
                  const SizedBox(width: 6),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCB001E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text("Chercher",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            ),
            Expanded(
                child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 75, crossAxisCount: 3),
              padding: const EdgeInsets.all(0),
              children: products!
                  .map((e) => ProductWidget(
                        product: e,
                        onTap: () {
                          if (cart.contains(e)) {
                            int index =
                                cart.indexWhere((element) => element == e);
                            cart[index].qte = cart[index].qte! + 1;
                          } else {
                            e.qte = 1;
                            cart.add(e);
                          }
                          setState(() {});
                        },
                      ))
                  .toList(),
            )),
          ],
        ),
      ),
    );
  }
}

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key, required this.product, required this.onTap});

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 120,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFF2D2D2D),
                  border: Border(
                      left: BorderSide(color: Color(0xFFC9CAEF), width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      product.productName!,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${product.price} Dhs",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class ProductCartWidget extends StatelessWidget {
  const ProductCartWidget(
      {super.key, required this.product, this.onMinus, this.onPlus});

  final Product product;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF2D2D2D),
                border: Border(
                    left: BorderSide(color: Color(0xFFC9CAEF), width: 4)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          product.productName!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${product.qte} x ${product.price} Dhs",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      QteButton(icon: Icons.remove, onTap: onMinus),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(product.qte.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                      ),
                      QteButton(icon: Icons.add, onTap: onPlus)
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class QteButton extends StatelessWidget {
  const QteButton({super.key, this.onTap, required this.icon});

  final VoidCallback? onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
