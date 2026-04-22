import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/podcast/podcast_page.dart';
import 'package:podcasks/ui/vms/search_vm.dart';

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
        if (item.feedUrl == null) return;
        vm.loading();
        final nav = Navigator.of(context);
        await vm.fetchPodcast(item.feedUrl);
        nav.pushNamed(PodcastPage.route, arguments: vm.selected);
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
              clipBehavior: Clip.hardEdge,
              child: (item.bestArtworkUrl != null)
                  ? CachedNetworkImage(
                      imageUrl: item.bestArtworkUrl!,
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
            // if (vm.searchBarController.text.trim() == '') ...[
            //   const SizedBox(width: 16),
            //   Text(
            //     '#${index + 1}',
            //     style: textStyleTitle.copyWith(
            //         color:
            //             Theme.of(context).colorScheme.primary.withAlpha(51)),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}
