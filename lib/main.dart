import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';


// source: https://stackoverflow.com/questions/57004220/how-to-get-all-mp3-files-from-internal-as-well-as-external-storage-in-flutter
Future<List<List<String>>> getSongs() async {
  var dir = await getExternalStorageDirectory();
//  String mp3Path = dir.path + "/";
  List<FileSystemEntity> _files;
//  List<FileSystemEntity> _songs = [];
  List<String> songsPaths = [];
  List<String> songsNames = [];
  List<String> songsArtists = [];
  _files = dir.listSync(recursive: true, followLinks: false);
  for(FileSystemEntity entity in _files) {
    String path = entity.path;
    if(path.endsWith('.mp3')) {
      songsPaths.add(path);
      var songName = path
          .split("/")
          .last;
      songName = songName.split(".mp3")[0];
      var songSplittedNames = songName.split("-");
      songsNames.add(songSplittedNames[0].trimRight().trimLeft());
      songsArtists.add(songSplittedNames[1].trimRight().trimLeft());
    }
  }
  return [songsPaths, songsNames, songsArtists];
}

// global variables
List<String> localSongsPaths = [];
List<String> localSongsNames = [''];
List<String> localSongsArtists = [''];
int _currentIndex = 0;

int _maxIndexes = localSongsNames.length - 1;
bool isPlaying = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getSongs().then((val) {
    localSongsPaths = val[0];
    localSongsNames = val[1];
    localSongsArtists = val[2];
  });

  runApp(
      MaterialApp(
        home: LocalMusicList(),
      )
  );
}

class LocalMusicList extends StatefulWidget {
  @override
  _LocalMusicListState createState() => _LocalMusicListState();
}

class _LocalMusicListState extends State<LocalMusicList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
         "WidgetX Музыка Ойнатқышы"
        ),
        backgroundColor: Colors.green,
      ),
      body: localSongsNames.isNotEmpty
        ? Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: _currentIndex == index
                      ? Icon(Icons.arrow_forward_ios)
                      : Text(''),
                    title: Text(
                      localSongsNames[index]
                    ),
                    subtitle: Text(
                      localSongsArtists[index]
                    ),
                    onTap: () {

                    },
                  );
                },
                itemCount: localSongsNames.length,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.orange[400],
                border: Border.all(
                  color: Colors.blueAccent
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.music_note
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        localSongsNames[_currentIndex]
                      ),
                      Text(
                        localSongsArtists[_currentIndex],
                        style: TextStyle(
                          color: Colors.black54
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.skip_previous
                        ),
                        onPressed: () {

                        },
                      ),
                      IconButton(
                        icon: isPlaying
                          ? Icon(Icons.pause)
                          : Icon(Icons.play_arrow),
                        onPressed: () {

                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        onPressed: () {

                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        )
      : Container(
        child: Center(
          child: Text(
            '0 songs',
            style: TextStyle(
              fontSize: 24
            ),
          ),
        ),
      ),
    );
  }
}