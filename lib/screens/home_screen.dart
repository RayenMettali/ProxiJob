import 'package:flutter/material.dart';
import 'package:proxi_job/models/cardModel.dart';
import 'package:proxi_job/models/categoriesModel.dart';
import 'package:proxi_job/widgets/CustomSearch.dart';
import 'package:proxi_job/services/auth_service.dart';
import 'package:proxi_job/screens/signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    List<CategoriesModel> categories = CategoriesModel.getCategories();
    List<Cardmodel> cards = Cardmodel.getCards();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        toolbarHeight: 100,
        centerTitle: true,
        elevation: 4.0,
        title: const Text(
          'Home Page',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.white,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white, // Set the background color to white
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Profile Name',
                  style: TextStyle(
                    color: Colors.black, // Set the text color to black
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                    ),
                    Divider(),
                    SizedBox(height: 10.0), // Adds a line between items
                    ListTile(
                      leading: Icon(Icons.business),
                      title: Text('Business'),
                    ),
                    Divider(),
                    SizedBox(height: 10.0),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                    ),
                    Divider(),
                    SizedBox(height: 10.0),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 240.0),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                textColor: Colors.red,
                iconColor: Colors.red,
                titleTextStyle: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
                onTap: () async {
                  AuthService authService = AuthService();
                  await authService.signout(context: context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      //body of the app

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40.0),

              // Categories Section
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 150.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      width: 120.0,
                      decoration: BoxDecoration(
                        color: categories[index].boxColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              categories[index].image,
                              height: 50.0,
                              width: 50.0,
                            ),
                          ),
                          Text(
                            categories[index].name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 60.0),

              // Latest Jobs Section
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Latest Jobs',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Job Cards List
              ListView.builder(
                itemCount: cards.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            cards[index].image,
                            height: 100.0,
                            width: 100.0,
                          ),
                          const SizedBox(height: 30.0),
                          Text(
                            cards[index].title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            cards[index].description,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            cards[index].jobDescription,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 15.0),

                          // Apply Button
                          SizedBox(
                            width: 250.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                // TODO: Define Apply Button Action
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Applied to ${cards[index].title}!'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Text(
                                'Apply to Job',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
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
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          // TODO: Define Floating Action Button Action
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Offer Job button pressed!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Offer Job',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
