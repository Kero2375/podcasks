import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/podcast_page.dart';

class PodcastListItem extends ConsumerWidget {
  final Podcast podcast;
  final bool isLast;

  const PodcastListItem({
    super.key,
    required this.podcast,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => InkWell(
        onTap: () {
          Navigator.pushNamed(context, PodcastPage.route, arguments: podcast);
        },
        child: Column(
          children: [
            // divider(context),
            Padding(
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
                    child: Image.network(
                      podcast.image!,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          podcast.title ?? '',
                          maxLines: 1,
                          style: textStyleBody,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // if (isLast) divider(context),
          ],
        ),
      );
}
