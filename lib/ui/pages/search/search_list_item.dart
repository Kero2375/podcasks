import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/podcast/podcast_page.dart';
import 'package:podcasks/ui/vms/search_vm.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchListItem extends ConsumerWidget {
  final Item item;
  final int index;

  const SearchListItem({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(searchViewmodel);

    return InkWell(
      onTap: () async {
        vm.loading();
        final nav = Navigator.of(context);
        if (item.feedUrl == null) {
          if (item.collectionViewUrl != null) {
            launchUrl(Uri.parse(item.collectionViewUrl!));
          }
        } else {
          await vm.fetchPodcast(item.feedUrl);
          nav.pushNamed(PodcastPage.route,
              arguments:
                  MPodcast.fromPodcast(vm.selected)); // TODO: fix loading
        }
        vm.success();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              height: 45,
              width: 45,
              clipBehavior: Clip.antiAlias,
              child: (item.bestArtworkUrl != null)
                  ? Image.network(
                      item.bestArtworkUrl!,
                    )
                  : const SizedBox.shrink(),
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
                color: Theme.of(context).colorScheme.primary.withOpacity(.5),
              )
            ],
            if (vm.searchBarController.text.trim() == '') ...[
              const SizedBox(width: 16),
              Text(
                '#${index + 1}',
                style: textStyleTitle.copyWith(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.3)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
