import 'dart:io';

import 'package:cross_play/song.dart';
import 'package:cross_play/song_card.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: const TextTheme(
                headline1: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold))),
        home: song()
        // MyHomePage(
        //   title: "new title",
        // ),
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Instance of Duration - 0:19:48.00000
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var yt = YoutubeExplode();
          var data = await yt.search
              .getVideos("All of me", filter: const SearchFilter('CAASAhAB'));
          // // print(data.first.title);
          // for (int i = 0; i < data.length; i++) {
          //   print(data[i].title);
          //   print(data[i].url);
          // }
          var id = data.first.id;
          // You can provide either a video ID or URL as String or an instance of `VideoId`.
          // Returns a Video instance.

          var manifest = await yt.videos.streamsClient.getManifest(id);
          var streamInfo = manifest.audio.withHighestBitrate();

          // var title = video.title; // "Scamazon Prime"
          // var author = video.author; // "Jim Browning"
          // var duration = video.duration;
          print("starting to write");
          Directory appDocDir = await getApplicationDocumentsDirectory();
          String appDocPath = appDocDir.path;
          print(" \n Found Path : $appDocPath");
          print(data.first.title);
          print(streamInfo);
          if (streamInfo != null) {
            var len = streamInfo.size.totalBytes;
            // Get the actual stream
            var count = 0;
            var stream = await yt.videos.streamsClient.get(streamInfo);
            await for (final aud in stream) {
              count = count + aud.length;
              var progress = ((count / len) * 100).ceil();
              print("Progress: $progress");
            }
            print(stream);
            // Open a file for writing.

            var file = File("$appDocPath/${data.first.title}.mp3");
            var fileStream = file.openWrite();
            print("Piping stuff :  $fileStream");
            // Pipe all the content of the stream into the file.
            await stream.pipe(fileStream);

            // Close the file.
            await fileStream.flush();
            await fileStream.close();
            print("Done Writing");
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
