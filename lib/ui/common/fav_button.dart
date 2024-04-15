import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/vm.dart';

class FavButton extends ConsumerWidget {
  final Podcast podcast;

  const FavButton(this.podcast, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(homeViewmodel);
    final bool isFav = vm.isFavourite(podcast);
    onTap() => vm.setFavourite(podcast, !isFav);
    return vm.state == UiState.loading
        ? (!isFav)
            ? _following(() {})
            : _follow(() {})
        : isFav
            ? _following(onTap)
            : _follow(onTap);
  }

  Widget _following(Function() onTap) => OutlinedButton.icon(
        onPressed: onTap,
        label: const Text("Following"),
        icon: const Icon(Icons.favorite),
        style: _style,
      );

  Widget _follow(Function() onTap) => FilledButton.icon(
        onPressed: onTap,
        label: const Text("Follow"),
        icon: const Icon(Icons.favorite_border),
        style: _style,
      );

  ButtonStyle get _style => buttonStyle.copyWith(
        fixedSize: const MaterialStatePropertyAll(Size.fromWidth(150)),
      );
}
