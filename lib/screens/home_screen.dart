import 'package:flutter/material.dart';
import 'package:invoice_maker/screens/invoice_form.dart';
import 'menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    MenuPage(),
  ];

  final List<String> _appBarTitles = ['Home', 'Menu'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          _appBarTitles[_currentIndex],
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              // Add functionality to create a new invoice
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                showDragHandle: true,
                isDismissible: false,
                elevation: 1,
                builder: (context){
                  return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: const InvoiceForm());
                  },
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('+ Add New Invoice'),
          ),
          const SizedBox(height: 10,)
        ],
      ),
    );
  }
}