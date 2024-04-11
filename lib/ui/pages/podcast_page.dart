import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/ui/common/app_bar.dart';
import 'package:ppp2/ui/common/fav_button.dart';
import 'package:ppp2/ui/pages/episode_page.dart';
import 'package:ppp2/ui/player/bottom_player.dart';
import 'package:ppp2/ui/vms/theme_vm.dart';

class PodcastPage extends ConsumerStatefulWidget {
  static const route = '/podcast_page';
  final Podcast? podcast;

  const PodcastPage(this.podcast, {super.key});

  @override
  ConsumerState<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends ConsumerState<PodcastPage> {

  @override
  void initState() {
    final themeVm = ref.read(themeViewmodel);
    themeVm.setPrimaryColor(widget.podcast?.image);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context, title: widget.podcast?.title),
      body: SingleChildScrollView(
        child: (widget.podcast == null)
            ? const Center(child: Text("Error"))
            : Column(
                children: [
                  _image(widget.podcast!),
                  Html(
                    data: widget.podcast!.description ?? '',
                    style: {
                      '*': Style(margin: Margins.all(8)),
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: FavButton(widget.podcast!),
                  ),
                  _episodes(),
                  const SizedBox(height: BottomPlayer.playerHeight),
                ],
              ),
      ),
      bottomSheet: const BottomPlayer(),
    );
  }

  Widget _episodes() {
    return ListView.builder(
      physics: const PageScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: widget.podcast?.episodes.length ?? 0,
      itemBuilder: (context, i) {
        final ep = widget.podcast?.episodes[i];
        if (ep != null) {
          return _episode(context, ep);
        }
        return null;
      },
    );
  }

  Widget _episode(BuildContext context, Episode ep) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, EpisodePage.route, arguments: EpisodeData(ep, widget.podcast));
      },
      child: Column(
        children: [
          Container(
            color: Colors.white10,
            width: double.infinity,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  ep.title,
                  style: const TextStyle(fontSize: 18),
                ),
                Html(
                  data: ep.description,
                  style: {
                    '*': Style(
                      maxLines: 3,
                      margin: Margins.zero,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _image(Podcast item) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
      clipBehavior: Clip.antiAlias,
      width: 120,
      height: 120,
      child: Image.network(item.image ?? ''),
    );
  }
}
