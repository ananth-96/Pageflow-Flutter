import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Viewpdf extends StatefulWidget {
  final String pdfUrl;
  const Viewpdf({super.key, required this.pdfUrl});

  @override
  State<Viewpdf> createState() => _ViewpdfState();
}

class _ViewpdfState extends State<Viewpdf> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _showAppBar = true;
  double _lastOffset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
      appBar: PreferredSize(preferredSize: Size.fromHeight(80),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _showAppBar ? kToolbarHeight + 20 : 0,
          child: _showAppBar
              ? AppBar(backgroundColor: Colors.black,
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.menu_book_outlined, color: Colors.blue),
                      const SizedBox(width: 8),
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
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(100),
                    ),
                  ),
                  shadowColor: Colors.grey,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.bookmark,
                        color: Colors.white,
                        semanticLabel: 'Bookmark',
                      ),
                      onPressed: () {
                        _pdfViewerKey.currentState?.openBookmarkView();
                      },
                    ),
                  ],
                )
              : null,
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            final currentOffset = scrollNotification.metrics.pixels;

            if (currentOffset > _lastOffset + 10 && _showAppBar) {
              // Scroll Down
              setState(() => _showAppBar = false);
            } else if (currentOffset < _lastOffset - 10 && !_showAppBar) {
              // Scroll Up
              setState(() => _showAppBar = true);
            }

            _lastOffset = currentOffset;
          }
          return false;
        },
        child: SfPdfViewer.network(
          widget.pdfUrl,
          key: _pdfViewerKey,
          canShowScrollHead: false,
          canShowScrollStatus: false,
        ),
      ),
    );
  }
}
