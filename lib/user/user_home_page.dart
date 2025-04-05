import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PageFlow',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets\backgroundimage.png'))),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search..',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            Row(
              children: [
                Text('Books available'),
                Icon(Icons.arrow_forward_ios_rounded),
                SizedBox(height: 20,),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}
