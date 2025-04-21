import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pageflow/user/booksByCategory.dart';

class UserCategories extends StatefulWidget {
  const UserCategories({super.key});

  @override
  State<UserCategories> createState() => _UserCategoriesState();
}

class _UserCategoriesState extends State<UserCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
      appBar: AppBar(automaticallyImplyLeading: false,backgroundColor: Colors.black,
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
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(100),
    ),
  ),
  shadowColor: Colors.grey,
),
      body: CategoryListViewForUser(),
    );
  }
}

class CategoryListViewForUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 18,),
        Text(
          'Available Categories',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('categories')
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
    
              final categoryDocs = snapshot.data?.docs ?? [];
    
              if (categoryDocs.isEmpty) {
                return Center(child: Text('No categories found.'));
              }
    
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: GridView.builder(
                    
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 40
                    ),
                    itemCount: categoryDocs.length,
                    itemBuilder: (context, index) {
                      final category =
                          categoryDocs[index].data() as Map<String, dynamic>;
                      
                      return Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                          
                          
                        ),
                        child: InkWell(
                            onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>BooksbyCategory(categoryName: category['category'],)));
                          }
                          ,child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(decoration: BoxDecoration(color: Colors.white),
                              child: Column(
                                children: [
                                  Container(
                                    height:   150,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            category['imageUrl'] != null
                                                ? NetworkImage(category['imageUrl'])
                                                : AssetImage(
                                                      'assets/book_cover_default.png',
                                                    )
                                                    as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Text(maxLines: 2,overflow: TextOverflow.ellipsis,
                                      category['category'] ?? 'Unnamed',textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                      ),
                                                                       ),
                                   ),
                                ],
                              ),
                            ),
                          ),
                        ),
                       
                      );
                      
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
