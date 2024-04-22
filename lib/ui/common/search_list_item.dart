import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/podcast/podcast_page.dart';
import 'package:podcasks/ui/vms/search_vm.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchListItem extends ConsumerWidget {
  final Item item;

  const SearchListItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(searchViewmodel);
    return InkWell(
      onTap: () async {
        final nav = Navigator.of(context);
        if (item.feedUrl == null) {
          if (item.collectionViewUrl != null) {
            launchUrl(Uri.parse(item.collectionViewUrl!));
          }
        } else {
          await vm.fetchPodcast(item.feedUrl);
          nav.pushNamed(PodcastPage.route, arguments: vm.selected);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (item.bestArtworkUrl != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                height: 45,
                width: 45,
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  item.bestArtworkUrl!,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.collectionName ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: textStyleBody,
                  ),
                  Text(
                    item.artistName ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: textStyleBodyGray(context),
                  ),
                  // Text(
                  //   item.feedUrl ?? '',
                  //   maxLines: 1,
                  //   style: textStyleSmallGray(context)
                  // ),
                ],
              ),
            ),
            if (item.feedUrl == null) ...[
              const SizedBox(width: 16),
              Icon(
                Icons.open_in_new,
                size: 24,
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(.5),
              )
            ],
          ],
        ),
      ),
    );
  }
}
