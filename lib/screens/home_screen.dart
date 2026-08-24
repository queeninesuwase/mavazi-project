import 'package:flutter/material.dart';
import 'package:mavazi/model/cart.dart';
import 'package:mavazi/model/product.dart';
import 'package:mavazi/screens/cart_card.dart';
import 'package:mavazi/screens/product_card.dart';
import 'package:mavazi/screens/product_card.dart';
import 'package:mavazi/view_model/auth_viewmodel.dart';
import 'package:provider/provider.dart';



class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState(){
    return _HomeScreeenState();
  }
}



class _HomeScreeenState extends State<HomeScreen>{
  int _selectedIndex = 0;
  String _tabTitle = "Home";

  final List<Widget> _tabs=[_HomeTab(),_CartTab(),_OrdersTab(),_ProfileTab()];
  final List<String> _titles = ['Home','Cart','Orders','Profile'];

  void _onClickTab(int index){
    setState((){
    _selectedIndex = index;
    _tabTitle = _titles[index];
  });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Column(children: [
        Text(_tabTitle),
        Row(
          children: [
             Spacer(flex: 1),
             Consumer<CartModel>(builder: (context, cart,child){
          return Text('KES ${cart.getTotalCost()}',
          style: TextStyle(fontSize: 12),
          );
        },
        ),
          ],)
        
      ],
      ),
      ),
      body:IndexedStack(index: _selectedIndex, children: _tabs,),
      bottomNavigationBar: BottomNavigationBar(
        type:BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap:_onClickTab,
       items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home, color: Colors.red,),
          label: 'Home',
          ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket_outlined),
          activeIcon: Icon(Icons.shopping_basket_outlined, color: Colors.yellow,),
          label: 'Cart',
          ),

        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          activeIcon: Icon(Icons.shopping_bag, color: Colors.blue,),
          label: 'Orders',
          ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_outlined),
          activeIcon: Icon(Icons.person_2, color: Colors.green,), 
          label: 'Profile',
          ),
       ],
      )
    );



  
    
  }
}

class _HomeTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dummyProducts.length,
      itemBuilder: (context, index){
        var product = dummyProducts[index];
        return ProductCard(product: product);

      },
    );
  }
}

class _CartTab extends StatelessWidget{
  @override
  Widget build(BuildContext context){
   return Consumer<CartModel>(
    builder:(context, cart , child){
    if(cart.items.isEmpty){
      return Center(child:Text ("Your cart is empty")); 
    }
    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder:(context,index){
        var cartItem = cart.items[index];
        return CartCard(cartItem: cartItem, 
        increment: () {
          cart.increment(cartItem.product);
        },
         decrement: () {
          cart.decrement(cartItem.product);
         },
         );
      },
    );
   },);
}
}
class _OrdersTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Orders"));
        }
      
    }
  


class _ProfileTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewmodel>(builder: (_,authViewmodel,_){
      return ElevatedButton(
        onPressed: (){
          authViewmodel.logout();
        }, 
        child: Text('Log out'),
        );
    });
  }
}