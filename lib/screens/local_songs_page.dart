import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:musify/API/musify.dart';
import 'package:musify/services/audio_manager.dart';
import 'package:musify/style/app_colors.dart';
import 'package:musify/style/app_themes.dart';
import 'package:musify/widgets/spinner.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LocalSongsPage extends StatefulWidget {
  @override
  State<LocalSongsPage> createState() => _LocalSongsPageState();
}

class _LocalSongsPageState extends State<LocalSongsPage> {
  final TextEditingController _searchBar = TextEditingController();
  final FocusNode _inputNode = FocusNode();
  String _searchQuery = '';

  Future<void> search() async {
    _searchQuery = _searchBar.text;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.localSongs,
          style: TextStyle(
            color: accent.primary,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 26),
                  height: 200,
                  width: 200,
                  child: Card(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withAlpha(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            FluentIcons.save_24_filled,
                            size: 30,
                            color: accent.primary,
                          ),
                          Text(
                            AppLocalizations.of(context)!.localSongs,
                            style: TextStyle(color: accent.primary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.localSongs,
                        style: TextStyle(
                          color: accent.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                      ),
                      ElevatedButton(
                        onPressed: () async => {
                          setActivePlaylist(
                            {
                              'ytid': '',
                              'title': AppLocalizations.of(context)!.localSongs,
                              'subtitle': 'Just Updated',
                              'header_desc': '',
                              'type': 'playlist',
                              'image': '',
                              'list': await getLocalSongs()
                            },
                          ),
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(accent.primary),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.playAll.toUpperCase(),
                          style: TextStyle(
                            color: isAccentWhite(),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 20,
                left: 12,
                right: 12,
              ),
              child: TextField(
                onSubmitted: (String value) {
                  search();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                textInputAction: TextInputAction.search,
                controller: _searchBar,
                focusNode: _inputNode,
                style: TextStyle(
                  fontSize: 16,
                  color: accent.primary,
                ),
                cursorColor: Colors.green[50],
                decoration: InputDecoration(
                  filled: true,
                  isDense: true,
                  fillColor: Theme.of(context).shadowColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    borderSide: BorderSide(color: accent.primary),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      FluentIcons.search_24_regular,
                      color: accent.primary,
                    ),
                    color: accent.primary,
                    onPressed: () {
                      search();
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                  hintText: '${AppLocalizations.of(context)!.search}...',
                  hintStyle: TextStyle(
                    color: accent.primary,
                  ),
                  contentPadding: const EdgeInsets.only(
                    left: 18,
                    right: 20,
                    top: 14,
                    bottom: 14,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 40)),
            if (_searchQuery.isEmpty)
              FutureBuilder(
                future: getLocalSongs(),
                builder: (context, data) {
                  if (data.connectionState != ConnectionState.done) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(35),
                        child: Spinner(),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    itemCount: (data as dynamic).data.length as int,
                    itemBuilder: (BuildContext context, int index) {
                      final lsong = {
                        'id': index,
                        'ytid': '',
                        'title': (data as dynamic).data[index].displayName,
                        'image': '',
                        'lowResImage': '',
                        'highResImage': '',
                        'songUrl': (data as dynamic).data[index].data,
                        'album': '',
                        'type': 'song',
                        'localSongId': (data as dynamic).data[index].id,
                        'more_info': {
                          'primary_artists': '',
                          'singers': '',
                        }
                      };

                      return Container(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          bottom: 15,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            playSong(lsong);
                          },
                          splashColor: accent.primary.withOpacity(0.4),
                          hoverColor: accent.primary.withOpacity(0.4),
                          focusColor: accent.primary.withOpacity(0.4),
                          highlightColor: accent.primary.withOpacity(0.4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              QueryArtworkWidget(
                                id: lsong['localSongId'] as int,
                                type: ArtworkType.AUDIO,
                                artworkWidth: 60,
                                artworkHeight: 60,
                                artworkFit: BoxFit.cover,
                                artworkBorder: BorderRadius.circular(8),
                                nullArtworkWidget: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: accent.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    FluentIcons.music_note_1_24_regular,
                                    size: 25,
                                    color: accent.primary !=
                                            const Color(0xFFFFFFFF)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                keepOldArtwork: true,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                      ),
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        lsong['title'].toString(),
                                        style: TextStyle(
                                          color: accent.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            else
              FutureBuilder(
                future: searchLocalSong(_searchQuery),
                builder: (context, data) {
                  if (data.connectionState != ConnectionState.done) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(35),
                        child: Spinner(),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    itemCount: (data as dynamic).data.length as int,
                    itemBuilder: (BuildContext context, int index) {
                      final lsong = {
                        'id': index,
                        'ytid': '',
                        'title': (data as dynamic).data[index].displayName,
                        'image': '',
                        'lowResImage': '',
                        'highResImage': '',
                        'songUrl': (data as dynamic).data[index].data,
                        'album': '',
                        'type': 'song',
                        'localSongId': (data as dynamic).data[index].id,
                        'more_info': {
                          'primary_artists': '',
                          'singers': '',
                        }
                      };

                      return Container(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          bottom: 15,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            playSong(lsong);
                          },
                          splashColor: accent.primary.withOpacity(0.4),
                          hoverColor: accent.primary.withOpacity(0.4),
                          focusColor: accent.primary.withOpacity(0.4),
                          highlightColor: accent.primary.withOpacity(0.4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              QueryArtworkWidget(
                                id: lsong['localSongId'] as int,
                                type: ArtworkType.AUDIO,
                                artworkWidth: 60,
                                artworkHeight: 60,
                                artworkFit: BoxFit.cover,
                                artworkBorder: BorderRadius.circular(8),
                                nullArtworkWidget: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: accent.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    FluentIcons.music_note_1_24_regular,
                                    size: 25,
                                    color: accent.primary !=
                                            const Color(0xFFFFFFFF)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                keepOldArtwork: true,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                      ),
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        lsong['title'].toString(),
                                        style: TextStyle(
                                          color: accent.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
          ],
        ),
      ),
    );
  }
}