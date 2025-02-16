import 'package:flutter/material.dart';
import 'package:proxi_job/widgets/CustomSearch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color of the Scaffold

      appBar: AppBar(
        backgroundColor: Colors.white, // Set the background color of the AppBar
        toolbarHeight: 80.0,
        centerTitle: true, // Center the title
        title: const Text(
          'Home Page',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w900,
            color: Color.fromRGBO(65, 111, 223, 1),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search  jobs here...',
                prefixIconColor: Color.fromRGBO(65, 111, 223, 1),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color:
                        Color.fromRGBO(65, 111, 223, 1), // Default border color
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color:
                        Color.fromRGBO(65, 111, 223, 1), // Default border color
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: const Color.fromARGB(139, 236, 236, 236),
              ),
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text('Erja3 8odoi',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w900,
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Person',
          ),
        ],
      ),
    );
  }
}
