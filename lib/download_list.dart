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
              var pathf = p.join(
                  path.toString().replaceAll(RegExp("'"), ""),
                  file![index]
                      .toString()
                      .split("/")
                      .last
                      .replaceAll(RegExp("'"), ""));

              return ListTile(
                title: Text(
                  file![index]
                      .toString()
                      .split("/")
                      .last
                      .replaceAll(RegExp("'"), ""),
                  style: TextStyle(color: Colors.white),
                ),
                trailing: IconButton(
                  onPressed: () async {
                    // print(file![index]
                    //     .toString()
                    //     .replaceAll(RegExp("File:  "), ""));

                    // int result = await audioPlayer.play(
                    //     file![index].toString().replaceAll(RegExp("File:"), ""),
                    //     isLocal: true);
                    // print(result);

                    String pathOfSong = file![index]
                        .toString()
                        .replaceAll(RegExp("File: "), "")
                        .replaceAll(RegExp("'"), "")
                        .trim();
                    final player = AudioPlayer();
                    var duration = await player
                        .setFilePath(pathOfSong)
                        .then((value) => print(value.toString()));
                    player.play();
                    print(player.duration!);
                    // print(pathOfSong);
                    // print(
                    //     '/storage/emulated/0/Documents/A Thousand Years [Official Music Video].mp3');
                    // print(
                    //     // '/storage/emulated/0/Documents/A Thousand Years [Official Music Video].mp3'
                    //     pathOfSong.length
                    //         // .compareTo(pathOfSong)
                    //         .toString());
                    // print(
                    //     '/storage/emulated/0/Documents/A Thousand Years [Official Music Video].mp3'
                    //         .length);
                    // await OpenFile.open(pathOfSong)
                    //     .then((value) => print(value.message));
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
