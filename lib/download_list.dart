import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as p;

class downList extends StatefulWidget {
  downList({Key? key}) : super(key: key);

  @override
  _downListState createState() => _downListState();
}

class _downListState extends State<downList> {
  String? directory;
  List? file;
  Directory? path;
  final player = AudioPlayer();
  bool _playing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listofFiles();
  }

  // Make New Function
  void _listofFiles() async {
    final myDir = Directory("/storage/emulated/0/Documents/");

    setState(() {
      path = myDir;
      file = myDir.listSync(recursive: true, followLinks: false);
    });
    print(myDir);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff16161D),
      appBar: AppBar(
        title: Text(
          "Downloaded",
          style: Theme.of(context).textTheme.headline1,
        ),
        backgroundColor: const Color(0xff1A1110),
      ),
      body: ListView.builder(
          itemCount: file!.length,
          itemBuilder: (context, index) {
            if (file![index].toString().contains(".mp3")) {
              int durationSong = 0;
              int fixduration = 1;
              var pathf = p.join(
                  path.toString().replaceAll(RegExp("'"), ""),
                  file![index]
                      .toString()
                      .split("/")
                      .last
                      .replaceAll(RegExp("'"), ""));
              String pathOfSong = file![index]
                  .toString()
                  .replaceAll(RegExp("File: "), "")
                  .replaceAll(RegExp("'"), "")
                  .trim();
              Timer _timer;

              return ListTile(
                title: Text(
                  file![index]
                      .toString()
                      .split("/")
                      .last
                      .replaceAll(RegExp("'"), ""),
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: _playing
                    ? LinearProgressIndicator(
                        value: (fixduration - durationSong) / fixduration,
                        backgroundColor: Colors.grey,
                        color: Colors.pink)
                    : Container(),
                trailing: _playing
                    ? IconButton(
                        onPressed: () async {
                          var duration = await player
                              .setFilePath(pathOfSong)
                              .then((value) => print(value.toString()));
                          player.pause();
                          setState(() {
                            _playing = false;
                          });
                          print(player.duration!);
                          // _timer.cancel();
                        },
                        icon: const Icon(
                          Icons.pause_circle_filled,
                          color: Colors.white,
                          size: 28,
                        ),
                      )
                    : IconButton(
                        onPressed: () async {
                          var duration = await player
                              .setFilePath(pathOfSong)
                              .then((value) => print(value.toString()));
                          player.play();
                          durationSong = player.duration!.inSeconds;
                          fixduration = player.duration!.inSeconds;
                          setState(() {
                            _playing = true;
                          });

                          _timer =
                              Timer.periodic(Duration(seconds: 1), (timer) {
                            if (durationSong > 0) {
                              setState(() {
                                durationSong--;
                              });
                            } else if (_playing == false) {
                              timer.cancel();
                            } else {
                              timer.cancel();
                            }
                          });
                          print(player.duration!);
                        },
                        icon: const Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
              );
            }
            return Container();
          }),
    );
  }
}
