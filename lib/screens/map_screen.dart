import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;
import 'package:proxi_job/models/UserModel.dart';
import 'package:proxi_job/services/user_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  Location _location = Location();
  LocationData? _currentLocation;
  bool _isLoading = true;
  final Set<Marker> _markers = {};
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('user_locations');
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref('users');

  final UserService _userService = UserService();
  UserModel? _currentUser;
  
  // Initial camera position (will be updated with actual location)
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 15,
  );

  // Subscription for location updates
  late StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  void dispose() {
    // Clean up location subscription
    _locationSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentUser() async {
    try {
      _currentUser = await _userService.getCurrentUser();
      _requestLocationPermission();
    } catch (e) {
      print('Error getting current user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get user information: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await permission_handler.Permission.location.request();
    
    if (status == permission_handler.PermissionStatus.granted) {
      _getUserLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location service is disabled')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    try {
      final locationData = await _location.getLocation();
      if (mounted) {
        setState(() {
          _currentLocation = locationData;
          _isLoading = false;
        });
        
        // Update marker
        _updateMarker();
        
        // Save location to Firebase
        _saveLocationToFirebase(locationData);
        
        // Start listening for location updates
        _startLocationUpdates();
      }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateMarker() {
    if (_currentLocation != null) {
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        );
      });
      
      // Animate camera to new position
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        ),
      );
    }
  }

  void _saveLocationToFirebase(LocationData locationData) {
    if (_currentUser == null || _currentUser!.uid.isEmpty) {
      print('Cannot save location: User not authenticated');
      return;
    }
    
    try {
      _databaseRef.child(_currentUser!.uid).set({
        'latitude': locationData.latitude,
        'longitude': locationData.longitude,
        'timestamp': ServerValue.timestamp,
      }).catchError((error) {
        print('Failed to save location data: $error');
      });
    } catch (e) {
      print('Error saving location to Firebase: $e');
    }
  }

  void _startLocationUpdates() {
    try {
      _locationSubscription = _location.onLocationChanged.listen(
        (LocationData currentLocation) {
          if (mounted) {
            setState(() {
              _currentLocation = currentLocation;
            });
            
            // Update marker
            _updateMarker();
            
            // Save to Firebase
            _saveLocationToFirebase(currentLocation);
          }
        },
        onError: (e) {
          print('Error from location stream: $e');
        }
      );
    } catch (e) {
      print('Error setting up location updates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Location'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: _currentLocation != null
                  ? CameraPosition(
                      target: LatLng(
                        _currentLocation!.latitude!,
                        _currentLocation!.longitude!,
                      ),
                      zoom: 15,
                    )
                  : _initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                if (_currentLocation != null) {
                  _mapController?.moveCamera(
                    CameraUpdate.newLatLng(
                      LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
                    ),
                  );
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentLocation != null) {
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
              ),
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}