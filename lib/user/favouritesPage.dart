import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pageflow/user/bookDetailsPage.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'PageFlow',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(100)),
        ),
        shadowColor: Colors.grey,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('favourites')
                .doc(userId)
                .collection('userFavourites')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final favBooks = snapshot.data?.docs ?? [];
          if (favBooks.isEmpty) {
            return Center(child: Text('No books added to Favourites',style:TextStyle(fontSize: 20,color: Colors.white),));
          }

          return Container(
            decoration: BoxDecoration(color: Colors.black),
            child: ListView.builder(
              itemCount: favBooks.length,

              itemBuilder: (context, index) {
                final book = favBooks[index].data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    height: 80,
                    child: Center(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                              book['bookCoverUrl'] ?? '',
                            ),
                          ),
                        ),
                        title: Text(
                          book['title'] ?? 'Untitled',maxLines: 2,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BookDetailsPage(bookData: book),
                            ),
                          );
                        },
                        trailing: IconButton(
                          onPressed: () {
                            removeFav(
                              book['id'],
                              FirebaseAuth.instance.currentUser!.uid,
                            );
                          },
                          icon: Icon(Icons.favorite),
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

Future<bool> removeFav(String bookid, String userId) async {
  try {
    await FirebaseFirestore.instance
        .collection('favourites')
        .doc(userId)
        .collection('userFavourites')
        .doc(bookid)
        .delete();
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
