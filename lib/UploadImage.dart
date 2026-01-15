import 'dart:convert'; // Added for jsonDecode if needed
import 'package:flutter/material.dart';
import 'UserModel.dart';
import 'package:http/http.dart' as http;

class Uploadimage extends StatefulWidget {
  const Uploadimage({super.key});

  @override
  State<Uploadimage> createState() => _UploadimageState();
}

class _UploadimageState extends State<Uploadimage> {
  // 1. Changed return type to handle the List or pick a specific user
  Future<UserModel> getUser() async {
    final response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/users"),
    );

    if (response.statusCode == 200) {
      // The API returns a List. Assuming you want the first user:
      var data = jsonDecode(response.body);
      return UserModel.fromJson(data[0]);
    } else {
      // 2. Throw an error so the FutureBuilder knows something went wrong
      throw Exception("Error To Connect");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fetch Data"),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      // 3. Removed Expanded from here
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center( // Added Center to align the FutureBuilder
            child: FutureBuilder<UserModel>(
              future: getUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  return Text(snapshot.data!.name.toString(),);
                } else {
                  return const Text("No data found");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}