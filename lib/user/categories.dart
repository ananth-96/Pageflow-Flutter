import 'package:flutter/material.dart';

class UserCategories extends StatefulWidget {
  const UserCategories({super.key});

  @override
  State<UserCategories> createState() => _UserCategoriesState();
}

class _UserCategoriesState extends State<UserCategories> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('PageFlow',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),
      body: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10,mainAxisSpacing: 10,childAspectRatio: 1),
      itemCount: 6,
       itemBuilder: (context,index){

        
       }),
    );
  }
}