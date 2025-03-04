import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  GoogleMapController? mapController;
  Position? currentPosition;
  @override
  void initState(){
    super.initState();
    _getUserLocation();
  }
  void _getUserLocation() async{
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    setState(() {
      currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Doctors")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search by specialty",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      searchQuery = searchController.text;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var filteredDocs = snapshot.data!.docs.where((doc) {
                  return doc['specialty'].toString().toLowerCase().contains(searchQuery.toLowerCase());
                }).toList();
                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    var doctor = filteredDocs[index];
                    return ListTile(
                      title: Text(doctor['name']),
                      subtitle: Text(doctor['specialty']),
                      trailing: ElevatedButton(
                        onPressed: () {},
                        child: Text('Book'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (currentPosition != null)
            SizedBox(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
                  zoom: 12,
                ),
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
              ),
            ),
        ],
      ),
    );
  }
}
