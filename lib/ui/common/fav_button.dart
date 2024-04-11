
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/src/model/podcast.dart';
import 'package:ppp2/ui/common/themes.dart';
import 'package:ppp2/ui/vms/home_vm.dart';

class FavButton extends ConsumerWidget {
  final Podcast podcast;

  const FavButton(this.podcast, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(homeViewmodel);
    final bool isFav = vm.isFavourite(podcast);
    return FilledButton.icon(
      onPressed: () => vm.setFavourite(podcast, !isFav),
      label: (isFav) ? const Text("Following") : const Text("Follow"),
      icon: (isFav) ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
      style: buttonStyle,
    );
  }
}