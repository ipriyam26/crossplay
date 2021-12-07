// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:cross_play/download_list.dart';
import 'package:cross_play/song_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class song extends StatefulWidget {
  const song({Key? key}) : super(key: key);

  @override
  _songState createState() => _songState();
}

class _songState extends State<song> {
  final searchController = TextEditingController();
  bool searching = false;
  Future<SearchList> getSongs() async {
    var yt = YoutubeExplode();
    var listSong = yt.search.getVideos(searchController.text);

    return listSong;
  }

  @override
  Widget build(BuildContext context) {
    final Mwidth = MediaQuery.of(context).size.width;
    final Mheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff16161D),
      appBar: AppBar(
        backgroundColor: const Color(0xff1A1110),
        title: Text(
          "Download Songs",
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => downList()));
              },
              icon: Icon(CupertinoIcons.cloud_download))
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: Mheight,
          width: Mwidth,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: Mheight * 0.02,
            ),
            SizedBox(
              height: Mheight * 0.07,
              width: Mwidth * 0.9,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                controller: searchController,
                scrollPadding: EdgeInsets.zero,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      searching = true;
                    });
                  } else {
                    setState(() {
                      searching = false;
                    });
                  }
                },
                autocorrect: false,
                cursorColor: const Color(0xffE76863),
                style: const TextStyle(
                    fontSize: 23,
                    color: Color(0xffE76863),
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    hintText: "Search Your Songs here",
                    hintStyle:
                        const TextStyle(fontSize: 23, color: Colors.grey),
                    prefixIcon:
                        const Icon(Icons.music_note, color: Color(0xffE76863)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    disabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffE76863), width: 2.5),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffE76863), width: 2.5),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2.5),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xffE76863), width: 2.5),
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
            SizedBox(
              height: Mheight * 0.02,
            ),
            searching
                ? FutureBuilder<SearchList>(
                    future: getSongs(),
                    builder: (context, AsyncSongList) {
                      if (!AsyncSongList.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      SearchList SongList = AsyncSongList.data!;
                      return SizedBox(
                        height: Mheight * 0.76,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 5,
                            itemBuilder: (ctx, index) => songCard(
                                  Song: SongList[index],
                                )),
                      );
                    })
                : Container(
                    padding: EdgeInsets.only(top: Mheight * 0.1),
                    child: Image.asset("assets/blank-2.gif")),
          ]),
        ),
      ),
    );
  }
}
