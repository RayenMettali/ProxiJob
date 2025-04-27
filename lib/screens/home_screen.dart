import 'package:flutter/material.dart';
import 'package:proxi_job/models/cardModel.dart';
import 'package:proxi_job/models/categoriesModel.dart';
import 'package:proxi_job/screens/map_screen.dart';
import 'package:proxi_job/widgets/CustomSearch.dart';
import 'package:proxi_job/services/auth_service.dart';
import 'package:proxi_job/services/user_service.dart';
import 'package:proxi_job/services/job_service.dart';
import 'package:proxi_job/services/job_application_service.dart';
import 'package:proxi_job/models/UserModel.dart';
import 'package:proxi_job/screens/signin_screen.dart';
import 'package:proxi_job/screens/profile_screen.dart';
import 'package:proxi_job/screens/add_job_screen.dart';
import 'package:proxi_job/screens/business_screen.dart';
import 'package:proxi_job/screens/job_applying_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final UserService _userService = UserService();
  final JobService _jobService = JobService();
  final JobApplicationService _applicationService = JobApplicationService();
  UserModel? _currentUser;
  bool _isLoadingUser = true;
  Stream<List<Cardmodel>>? _jobsStream;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _jobsStream = _jobService.getJobs();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoadingUser = true;
    });

    try {
      UserModel? user = await _userService.getCurrentUser();
      setState(() {
        _currentUser = user;
        _isLoadingUser = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoadingUser = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileScreen(),
        ),
      ).then((_) => _loadUserData());
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(),
        ),
      ).then((_) => _loadUserData());
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BusinessScreen(),
        ),
      );
    }
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CategoriesModel> categories = CategoriesModel.getCategories();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 41, 72, 183),
        toolbarHeight: 100,
        centerTitle: true,
        elevation: 4.0,
        title: const Text(
          'Proxi Job',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // User Profile Header in Drawer
            _isLoadingUser
                ? const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // User profile image
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: _currentUser?.photoUrl != null
                                    ? NetworkImage(_currentUser!.photoUrl!)
                                    : null,
                                child: _currentUser?.photoUrl == null
                                    ? Text(
                                        _currentUser?.name
                                                ?.substring(0, 1)
                                                .toUpperCase() ??
                                            _currentUser?.email
                                                .substring(0, 1)
                                                .toUpperCase() ??
                                            "U",
                                        style: const TextStyle(fontSize: 30),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 15),
                              // User name and email
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _currentUser?.name ?? 'No Name',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      _currentUser?.email ?? '',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Phone number and additional info summary
                          if (_currentUser != null) ...[
                            const SizedBox(height: 12),
                            // Show one piece of additional info if available
                            if (_currentUser!.additionalInfo != null &&
                                _currentUser!.additionalInfo!.isNotEmpty)
                              Text(
                                '${_currentUser!.additionalInfo!.entries.first.key}: ${_currentUser!.additionalInfo!.entries.first.value}',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),

            // Drawer Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                children: [
                  const ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                  ),
                  const Divider(),
                  const SizedBox(height: 10.0),
                  const ListTile(
                    leading: Icon(Icons.business),
                    title: Text('Business'),
                  ),
                  const Divider(),
                  const SizedBox(height: 10.0),
                  const ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                  const Divider(),
                  const SizedBox(height: 10.0),
                  // Profile menu item - navigate to profile screen
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(),
                        ),
                      ).then((_) =>
                          _loadUserData()); // Reload user data after returning
                    },
                  ),
                  const Divider(),
                  const SizedBox(height: 10.0),

                  // Show all additional info in a separate section
                  if (_currentUser != null &&
                      _currentUser!.additionalInfo != null &&
                      _currentUser!.additionalInfo!.length > 1) ...[
                    const Padding(
                      padding:
                          EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                      child: Text(
                        'Additional Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromARGB(255, 41, 72, 183),
                        ),
                      ),
                    ),

                    // Skip the first item as it's already shown in the header
                    ..._currentUser!.additionalInfo!.entries
                        .skip(1)
                        .map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key}:',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${entry.value}',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const Divider(),
                    const SizedBox(height: 10.0),
                  ],
                ],
              ),
            ),

            // Logout button
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                textColor: Colors.red,
                iconColor: Colors.red,
                titleTextStyle: const TextStyle(
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
              const SizedBox(height: 30.0),

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

              const SizedBox(height: 30.0),

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

              // Job Cards List - Updated to use StreamBuilder
              StreamBuilder<List<Cardmodel>>(
                stream: _jobsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final jobs = snapshot.data ?? [];

                  if (jobs.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'No jobs posted yet. Be the first to post a job!',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: jobs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final job = jobs[index];
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
                                job.image,
                                height: 100.0,
                                width: 100.0,
                              ),
                              const SizedBox(height: 30.0),
                              Text(
                                job.title,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                job.description,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                job.jobDescription,
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
                                    backgroundColor:
                                        const Color.fromARGB(255, 41, 72, 183),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  onPressed: () async {
                                    try {
                                      // Navigate to ApplyJobScreen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ApplyJobScreen(),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(e.toString()),
                                          duration:
                                              const Duration(seconds: 2),
                                        ),
                                      );
                                    }
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 41, 72, 183),
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
        backgroundColor: const Color.fromARGB(255, 41, 72, 183),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddJobScreen(),
            ),
          );

          if (result == true) {
            // Job was added successfully
            setState(() {
              // Refresh the jobs stream
              _jobsStream = _jobService.getJobs();
            });
          }
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
