import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pageflow/admin/addNewCategoryPage.dart';
import 'package:pageflow/admin/categoryEditPage.dart';
import 'package:pageflow/admin/homePage.dart';
import 'package:pageflow/admin/profilePage.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Admin Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,elevation: 4, // default shadow
  shadowColor: Colors.brown.withOpacity(0.5)
      ),
      body: Container(decoration: BoxDecoration(image: DecorationImage(
                image: AssetImage('assets/ChatGPT Image Apr 11, 2025, 04_50_26 PM.png'),
                fit: BoxFit.fill,
              ),),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38),
                  color: Colors.white,boxShadow: [BoxShadow(spreadRadius: 4,blurRadius: 3,color: Colors.grey.shade300)]
                ),
                height: 50,
                width: 300,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Category List',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 35),
              Expanded(
                child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection('categories')
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final categoryDocs = snapshot.data?.docs ?? [];
                    return ListView.builder(
                      itemCount: categoryDocs.length,
                      itemBuilder: (context, index) {
                        final doc = categoryDocs[index];
                        final category =
                            doc.data() as Map<String, dynamic>;
          
                        return Padding(
                          padding: const EdgeInsets.only(left: 3,right: 3),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  category['imageUrl'] != null
                                      ? NetworkImage(category['imageUrl'])
                                      : AssetImage('assets/book_cover_default.png')
                                          as ImageProvider,
                            ),
                            title: Text(
                              category['category'] ?? 'Unnamed',
                              style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w600),
                            ),
                            trailing: SizedBox(
                              width: 80,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => CategoryEditPage(categoryId: categoryDocs[index].id,
                                    currentName: category['category'],
                                    currentImageUrl: category['imageUrl'] ?? ''),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  Icon(Icons.delete),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Addnewcategorypage()),
                  );
                },child: Icon(Icons.add_circle),
              ),
              SizedBox(height: 20,)
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
