import 'package:flutter/material.dart';
import 'package:mavazi/model/cart.dart';
import 'package:mavazi/model/product.dart';
import 'package:mavazi/screens/cart_card.dart';
import 'package:mavazi/screens/product_card.dart';
import 'package:mavazi/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _tabTitle = "Home";

  static const List<Widget> _tabs = <Widget>[
    _HomeTab(),
    _CartTab(),
    _OrdersTab(),
    _ProfileTab(),
  ];
  static const List<String> _titles = <String>[
    'Home',
    'Cart',
    'Orders',
    'Profile',
  ];

  void _onClickTab(int index) {
    setState(() {
      _selectedIndex = index;
      _tabTitle = _titles[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(_tabTitle),
            Row(
              children: [
                Spacer(flex: 1),
                Consumer<CartModel>(
                  builder: (context, cart, child) {
                    return Text(
                      'KES ${cart.getTotalCost()}',
                      style: TextStyle(fontSize: 12),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onClickTab,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            activeIcon: Icon(Icons.shopping_basket),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            activeIcon: Icon(Icons.person_2),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dummyProducts.length,
      itemBuilder: (context, index) {
        var product = dummyProducts[index];
        return ProductCard(product: product);
      },
    );
  }
}

class _CartTab extends StatelessWidget {
  const _CartTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, cart, child) {
        if (cart.items.isEmpty) {
          return Center(child: Text("Your cart is empty"));
        }
        return ListView.builder(
          itemCount: cart.items.length,
          itemBuilder: (context, index) {
            var cartItem = cart.items[index];
            return CartCard(
              cartItem: cartItem,
              increment: () {
                cart.increment(cartItem.product);
              },
              decrement: () {
                cart.decrement(cartItem.product);
              },
            );
          },
        );
      },
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Orders"));
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (_, authViewmodel, _) {
        return ElevatedButton(
          onPressed: () {
            authViewmodel.logout();
          },
          child: Text('Log out'),
        );
      },
    );
  }
}
