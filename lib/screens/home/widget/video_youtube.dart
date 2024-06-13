import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_api_client/youtube_api.dart';

class VideoYoutubeScreen extends StatefulWidget {
  const VideoYoutubeScreen({super.key});
  
  @override
  State<VideoYoutubeScreen> createState() => _VideoYoutubeScreenState();
}

class _VideoYoutubeScreenState extends State<VideoYoutubeScreen> {
  static const String _key = "AIzaSyA-DEAkR6vXctxcjl_t0fRXaelIRg0u4Po";
  // https://console.cloud.google.com/apis/api/youtube.googleapis.com/quotas?hl=es-419&project=demoomolds-225117&pageState=(%22allQuotasTable%22:(%22f%22:%22%255B%255D%22))
  // https://pub.dev/packages/youtube_api_client/example
  final _youtube = YoutubeApi(_key);
  List<ApiResult> _result = [];

  Future<void> callAPI() async {
    String query = "press frances con mancuernas";
    _result = await _youtube.search(
      query,
      options: const SearchOptions(
        order: Order.relevance,
        videoDuration: VideoDuration.short,
        maxResults: 2,
        type: [ResultType.video],
      ),
    );
    if (kDebugMode) {
      print('hello youtube 1');
      print(_result);
    }
    _result = (await _youtube.nextPage()) ?? [];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    callAPI();
  }

  @override
  Widget build(BuildContext context) {

      return SizedBox( // Wrap ListView with SizedBox
        height: 300, // Adjust height as needed
        child: ListView(
          children: _result.map<Widget>(listItem).toList(),
        ),
      );
    
  }

  Widget listItem(ApiResult obj) {
    return Card(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7.0),
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (obj.snippet != null) ...[
              if (obj.snippet!.thumbnails != null)
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: CachedNetworkImage(
                    imageUrl: obj.snippet!.thumbnails![ThumbnailResolution.default_]?.url ?? '',
                    width: 120.0,
                    placeholder: (context, url) => const CircularProgressIndicator(), // Widget mientras carga
                    errorWidget: (context, url, error) => const Icon(Icons.error), // Widget si hay error
                  ),
                ),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                      onTap: () async {
                      // Acción que se ejecutará cuando se toque el texto
                      if (await canLaunchUrl(Uri.parse(obj.url))) {
                        await launchUrl(Uri.parse(obj.url), mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch ${obj.url}';
                      }

                    },
                    child: Text(
                      obj.url,
                      softWrap: true,
                      style: const TextStyle(
                        decoration: TextDecoration.underline, // Opcional: Subrayado para indicar que es un enlace
                        color: Colors.blue, // Opcional: Color azul para simular un enlace
                      ),
                    ),
                  ),
                  if (obj is YoutubeVideo)
                    ..._buildVideoElements(obj)
                  else if (obj is YoutubeChannel)
                    ..._buildChannelElements(obj)
                  else if (obj is YoutubePlaylist)
                    ..._buildPlaylistElements(obj)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildVideoElements(YoutubeVideo obj) => [
        if (obj.snippet != null) ...[
          Text(
            obj.snippet!.title ?? '',
            style: const TextStyle(fontSize: 18.0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              obj.snippet!.channelTitle ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text("publishedAt: ${obj.snippet!.publishedAt}"),
          Text("tags: ${obj.snippet!.tags?.take(3).join(", ")}"),
          Text("category: ${obj.snippet!.category?.name}"),
        ],
        //if (obj.contentDetails != null) ...[
         // Text("duration: ${obj.contentDetails?.duration}"),
        //],
      ];

  List<Widget> _buildChannelElements(YoutubeChannel obj) => [
        if (obj.snippet != null) ...[
          Text(
            obj.snippet!.title ?? '',
            style: const TextStyle(fontSize: 18.0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              obj.snippet!.customUrl ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text("publishedAt: ${obj.snippet!.publishedAt}"),
          Text("description: ${obj.snippet!.description}"),
        ],
        if (obj.brandingSettings != null) ...[
          Text(
            obj.brandingSettings!.country ?? '',
            style: const TextStyle(fontSize: 18.0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              obj.brandingSettings!.keywords.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text("moderateComments: ${obj.brandingSettings!.moderateComments}"),
          Text(
              "unsubscribedTrailer: ${obj.brandingSettings!.unsubscribedTrailer}"),
        ],
      ];
  List<Widget> _buildPlaylistElements(YoutubePlaylist obj) => [
        if (obj.snippet != null) ...[
          Text(
            obj.snippet!.title ?? '',
            style: const TextStyle(fontSize: 18.0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              obj.snippet!.channelTitle ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text("publishedAt: ${obj.snippet!.publishedAt}"),
        ],
      ];
}

