import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pageflow/user/musicPlayer.dart';
import 'package:pageflow/user/pdfViewerpage.dart';
import 'package:pageflow/user/viewPDF.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookDetailsPage extends StatefulWidget {
  final Map<String, dynamic> bookData;
  const BookDetailsPage({Key? key, required this.bookData}) : super(key: key);

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
    final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
 
  bool isFavourited = false;
 

  @override
  void initState() {
    super.initState();
    checkIfFavourited();
    print(widget.bookData);
    print(FirebaseAuth.instance.currentUser?.uid);
  }

  

  Future<void> checkIfFavourited() async {
    final bookId = widget.bookData['id'];
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final doc =
        await FirebaseFirestore.instance
            .collection('favourites')
            .doc(userId)
            .collection('userFavourites')
            .doc(bookId)
            .get();

    if (doc.exists) {
      setState(() {
        isFavourited = true;
      });
    }
  }

  void toggleFavourite(BuildContext context) async {
    final bookId = widget.bookData['id'];
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final favRef = FirebaseFirestore.instance
        .collection('favourites')
        .doc(userId)
        .collection('userFavourites')
        .doc(bookId);

    try {
      final doc = await favRef.get();

      if (doc.exists) {
        await favRef.delete();
        setState(() {
          isFavourited = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Book removed from favourites')));
      } else {
        await favRef.set(widget.bookData);
        setState(() {
          isFavourited = true;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Book added to favourites')));
      }
    } catch (e) {
      print('Error toggling favourite $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.bookData['bookCoverUrl'] ?? '',
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 100),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomCircularIconButton(
                  onPressed: () {
                    toggleFavourite(context);
                  },
                  icon: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder:
                        (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                    child: Icon(
                      Icons.favorite,
                      key: ValueKey<bool>(isFavourited),
                      color: isFavourited ? Colors.red : Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                CustomCircularIconButton(
                  onPressed: () {
                    print(widget.bookData['pdfUrl']);
                   if (widget.bookData['pdfUrl'].isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF coming soon'),backgroundColor: Colors.yellow,));
                   }
                   else{
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Viewpdf(pdfUrl: widget.bookData['pdfUrl'],)));
                   }
                  },
                  icon: Icon(Icons.picture_as_pdf_rounded,color: Colors.black,),
                ),
                SizedBox(width: 10),
                CustomCircularIconButton(
                  onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MusicView(userData:widget.bookData)));},
                icon: Icon(Icons.play_circle_fill_outlined,color: Colors.black,),
                ),
               
              ],
            ),
            const SizedBox(height: 15),
            Text(
              widget.bookData['title'] ?? 'No title',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              "Category : ${widget.bookData['category'] ?? 'N/A'}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.white),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Description : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Required to show text in RichText
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: widget.bookData['description'] ?? 'N/A',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Author Info ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: Colors.white),
            ),
            const SizedBox(height: 20),
            if (widget.bookData['authorImageUrl'] != null &&
                (widget.bookData['authorImageUrl'] as String).isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    widget.bookData['authorImageUrl'],
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 100),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              "Author Description : ${widget.bookData['authorDescription'] ?? 'No description available'}",
              style: TextStyle(fontSize: 16,color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCircularIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget icon;

  const CustomCircularIconButton({
    required this.onPressed,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF06202B),
        shape: BoxShape.circle,
      ),
      height: 60,
      width: 60,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0XFFF5EEDD),
          ),
          height: 50,
          width: 50,
          child: IconButton(onPressed: onPressed, icon: icon),
        ),
      ),
    );
  }
}
