import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:pageflow/user/bookDetailsPage.dart';

class MusicView extends StatefulWidget {
  final Map<String,dynamic> userData;
  const MusicView({required this.userData,super.key});

  @override
  State<MusicView> createState() => _MusicViewState();
}

class _MusicViewState extends State<MusicView> {
  late AudioPlayer _audioPlayer;
   bool isPlaying = false;
  Future<void> _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    final audioUrl = widget.userData['audioUrl'];
    if (audioUrl != null && audioUrl.isNotEmpty) {
      try {
        await _audioPlayer.setUrl(audioUrl);
      } catch (e) {
        print('Error loading audio: $e');
      }
    }
  }

  @override
   void initState() {
    super.initState();
    _initAudioPlayer();
   
  }
   void _togglePlayPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
      setState(() => isPlaying = false);
    } else {
      _audioPlayer.play();
      setState(() => isPlaying = true);
    }
  
  }

  void _seekBackward ()async{
    final currentPosition= await _audioPlayer.position;
    final newPosition = currentPosition- const Duration(seconds: 10);
    _audioPlayer.seek(newPosition>Duration.zero? newPosition: Duration.zero);
  }

  void _seekForward ()async{
    final currentPosition = await _audioPlayer.position;
    final newPosition=currentPosition+const Duration(seconds: 10);
    final totalDuration=_audioPlayer.duration?? Duration.zero;
    _audioPlayer.seek(newPosition<totalDuration? newPosition:totalDuration);
  }

  @override
  void dispose(){
    _audioPlayer.dispose();
    super.dispose();
  }

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black
          ),
        
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 60),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(
                              widget.userData['bookCoverUrl']
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              
                    
                             Expanded(
                               child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 30,),
                                  Text(textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    widget.userData['title'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    widget.userData['authorName'],
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                                                           ),
                             ),
                            
                          ],
                        ),
                        
                        Lottie.asset(
                          'assets/musicPlayer.json',
                          width: double.infinity,height: 250
                        ),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                  
                            IconButton(onPressed: (){
                              _seekBackward();
                           },
                              icon:Icon(Icons.replay_10, size: 40),
                            
                              color: Colors.white,
                            ),
                            CustomCircularIconButton(
                              onPressed: () {
                                _togglePlayPause();
                               
                              },
                               icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                    color: Colors.black,
                  )
                            
                            ),
                            IconButton(onPressed: (){
                              _seekForward();
                            }, icon: Icon(Icons.forward_10,size: 40,color: Colors.white,))
                            
                          ],
                        ),
                       
                      ],
                    ),
                  ),
                ],
              ),
               
            ],
          ),
        ),
      ),
    );
  }

}