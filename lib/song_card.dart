// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numeral/numeral.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class songCard extends StatefulWidget {
  const songCard({Key? key, required this.Song}) : super(key: key);

  final Video Song;
  @override
  State<songCard> createState() => _songCardState();
}

class _songCardState extends State<songCard> {
  final formatCurrency = NumberFormat.simpleCurrency();

  var yt = YoutubeExplode();

  bool downloaing = false;
  bool downloaded = false;

  Future<String> getchannel(String channelid) async {
    var channel = await yt.channels.get(channelid);
    var image = channel.logoUrl;
    return image;
  }

  var progress = 0.0;

  downloadSong(String videoId, String videoTitle) async {
    setState(() {
      downloaing = true;
    });
    var manifest = await yt.videos.streamsClient.getManifest(videoId);
    var streams = manifest.audioOnly;
    var audio = streams.first;
    var audioStream = yt.videos.streamsClient.get(audio);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    print("Path: $appDocPath");
    var len = audio.size.totalBytes;

    var count = 0;

    print(audioStream);

    var file = File("/storage/emulated/0/Documents/$videoTitle.mp3");
    if (file.existsSync()) {
      setState(() {
        downloaing = false;
        downloaded = true;
      });
      return;
    }

    var fileStream = file.openWrite(mode: FileMode.writeOnlyAppend);
    await for (final aud in audioStream) {
      count = count + aud.length;
      setState(() {
        progress = (count / len);
      });
      print("Progress: $progress");
      fileStream.add(aud);
      if (progress == 1.0) {
        setState(() {
          downloaing = false;
          downloaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Mheight = MediaQuery.of(context).size.height;
    final Mwidth = MediaQuery.of(context).size.width;
    var Song = widget.Song;
    return FutureBuilder<String>(
        future: getchannel(Song.channelId.value),
        builder: (context, futureImage) {
          if (!futureImage.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
              ),
            );
          }
          var channellogo = futureImage.data!;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Card(
              child: Container(
                width: Mwidth * 0.95,
                height: Mwidth * 0.95 * 0.562,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          Song.thumbnails.mediumResUrl,
                        ),
                        fit: BoxFit.cover)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(),
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Mwidth * 0.02,
                              vertical: Mwidth * 0.02),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      color: Colors.white,
                                      child: ClipOval(
                                        child: Image.network(
                                          channellogo,
                                          height: Mwidth * 0.18,
                                          width: Mwidth * 0.18,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Mwidth * 0.015,
                                  ),
                                  Container(
                                    // color: Colors.pink,
                                    height: Mheight * 0.05,
                                    width: Mwidth * 0.44,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          Song.author,
                                          style: const TextStyle(
                                              shadows: [
                                                Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 2)
                                              ],
                                              fontSize: 19,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          DateFormat.yMMMd().format(
                                              Song.uploadDate ??
                                                  DateTime.now()),
                                          style: const TextStyle(
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 2)
                                            ],
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                  // color: Colors.pink,
                                  padding: EdgeInsets.only(left: Mwidth * 0.05),
                                  width: Mwidth * 0.6,
                                  height: Mheight * 0.1,
                                  child: AutoSizeText(
                                    Song.title
                                        .toString()
                                        .replaceAll(RegExp(Song.author), "")
                                        .replaceAll(RegExp("-"), "")
                                        .replaceAll(RegExp("OFFICIAL"), "")
                                        .replaceAll(RegExp("LYRICAL"), "")
                                        .replaceAll(RegExp("|"), "")
                                        .replaceAll(RegExp("'"), "")
                                        .replaceAll(RegExp(":"), "")
                                        .trim(),
                                    style: const TextStyle(
                                        shadows: [
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 4)
                                        ],
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800),
                                    stepGranularity: 2,
                                  )),
                              Container(
                                margin: EdgeInsets.only(left: Mwidth * 0.03),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.watch_later,
                                      color: Colors.white.withOpacity(0.8),
                                      size: 20,
                                    ),
                                    Text(
                                      " ${Song.duration!.inMinutes}:${Song.duration!.inSeconds - Song.duration!.inMinutes * 60} mins",
                                      style: const TextStyle(
                                          shadows: [
                                            Shadow(
                                                color: Colors.black,
                                                blurRadius: 1)
                                          ],
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: Mwidth * 0.02,
                                    ),
                                    Icon(
                                      Icons.visibility,
                                      color: Colors.white.withOpacity(0.8),
                                      size: 20,
                                    ),
                                    Text(
                                      " ${Numeral(Song.engagement.viewCount)}",
                                      style: const TextStyle(
                                          shadows: [
                                            Shadow(
                                                color: Colors.black,
                                                blurRadius: 1)
                                          ],
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: Mwidth * 0.04,
                        ),
                        VerticalDivider(
                          indent: Mheight * 0.01,
                          endIndent: Mheight * 0.01,
                          thickness: 3,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        downloaing
                            ? Container(
                                margin: EdgeInsets.only(left: Mwidth * 0.03),
                                height: Mwidth * 0.15,
                                width: Mwidth * 0.15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 6,
                                  color: Colors.white,
                                  value: progress,
                                ),
                              )
                            : downloaded
                                ? IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.download_done,
                                      color: Colors.white,
                                      size: Mheight * 0.07,
                                    ))
                                : IconButton(
                                    onPressed: () async {
                                      var title = Song.title
                                          .toString()
                                          .replaceAll(RegExp(Song.author), "")
                                          .replaceAll(RegExp("-"), "")
                                          .replaceAll(RegExp("OFFICIAL"), "")
                                          .replaceAll(RegExp("LYRICAL"), "")
                                          .replaceAll(RegExp("|"), "")
                                          .replaceAll(RegExp("'"), "")
                                          .replaceAll(RegExp(":"), "")
                                          .trim();
                                      downloadSong(Song.id.toString(), title);
                                    },
                                    icon: Icon(
                                      CupertinoIcons.cloud_download,
                                      color: Colors.white,
                                      size: Mheight * 0.07,
                                    ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
