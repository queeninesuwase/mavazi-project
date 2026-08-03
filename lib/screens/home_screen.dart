import 'package:flutter/material.dart';
import 'package:mavazi/model/product.dart';
import 'package:mavazi/screens/product_card.dart';



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

  final List<Widget> _tabs=[_HomeTab(), _OrdersTab(),_ProfileTab()];
  final List<String> _titles = ['Home','Orders','Profile'];

  void _onClickTab(int index){
    setState((){
    _selectedIndex = index;
    _tabTitle = _titles[index];
  });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(_tabTitle),),
      body:IndexedStack(index: _selectedIndex, children: _tabs,),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap:_onClickTab,
       items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home, color: Colors.red,),
          label: 'Home',
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

class _OrdersTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Orders"));
  }
}

class _ProfileTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Profile"));
  }
}