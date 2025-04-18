import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pageflow/admin/editBook.dart';
import 'package:pageflow/admin/homePage.dart';
import 'package:pageflow/admin/profilePage.dart';
import 'package:pageflow/admin/addNewBook.dart';

class BooksList extends StatelessWidget {
  const BooksList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Admin Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,elevation: 4, // default shadow
  shadowColor: Colors.brown.withOpacity(0.5)
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 50, right: 30, top: 20),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('book')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No books uploaded yet.'));
                  }

                  final books = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index].data() as Map<String, dynamic>;
                      final bookId = books[index].id;

                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),elevation: 3,shadowColor: Colors.grey.withOpacity(0.5),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: Image.network(
                            book['bookCoverUrl'] ?? '',
                            height: 70,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(book['title'] ?? 'No Title'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Category: ${book['category'] ?? ''}'),
                              Text('Author: ${book['authorName'] ?? ''}'),
                              Row(children: [TextButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditBook(bookId: bookId,bookdata: book,)));
                        
                              }, child: Text('Edit')),
                              
                              TextButton(
  onPressed: () async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          )
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('book')
          .doc(books[index].id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book deleted',style: TextStyle(color: Colors.red),)),
      );
    }
  },
  child: Text('Delete'),
),
],)
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            
          ],
        ),
      ),  





      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
  