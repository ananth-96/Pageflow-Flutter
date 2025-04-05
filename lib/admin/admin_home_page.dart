import 'package:flutter/material.dart';
import 'package:pageflow/admin/admin_profile_page.dart';
import 'package:pageflow/admin/books_list.dart';
import 'package:pageflow/admin/category_list.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 60, right: 60, top: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 28),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BooksList()),
                  );
                },
                child: Container(
                  height: 200,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Add a new book',
                      style: TextStyle(
                        color: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 28),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryList()),
                  );
                },
                child: Container(
                  height: 200,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Add a new category',
                      style: TextStyle(
                        color: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 28),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryList()),
                  );
                },
                child: Container(
                  height: 200,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Add a new category',
                      style: TextStyle(
                        color: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
       bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminHomePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminProfilePage()),
            );
          }
        },
      ),
    );
  }
}
