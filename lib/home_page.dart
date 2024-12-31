import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  Map<String, dynamic> usersData = {};
  bool isLoading = false;

  void fetchUsers() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(Uri.parse('https://dummyjson.com/users'));
      if (response.statusCode == 200) {
        setState(() {
          usersData = json.decode(response.body);
        });
      }
    } catch (e) {
      log('Failed to load users $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Api test"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : usersData.isNotEmpty && usersData['users'] != null
              ? ListView.builder(
                  itemCount: usersData['users'].length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Image.network("${usersData["users"][index]["image"]}"),
                      ),
                      title: Text(
                          "${usersData['users'][index]['firstName']} ${usersData['users'][index]['lastName']} ${usersData['users'][index]['maidenName']}"),
                      subtitle: Text(
                        "${usersData['users'][index]['age']} years old",
                        // "${usersData['users'][index]['agee'] ?? "Age is not available"}",
                      ),
                      
                    );
                  })
              : const CircularProgressIndicator(),
    );
  }
}
