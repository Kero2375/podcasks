import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/data/entities/podcast/podcast_entity.dart';
import 'package:podcasks/utils.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/home_vm.dart';
import 'package:podcasks/ui/vms/vm.dart';

class FavButton extends ConsumerWidget {
  final MPodcast podcast;

  const FavButton(this.podcast, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(homeViewmodel);
    final bool isFav = vm.isFavourite(podcast);
    onTap() => vm.setFavourite(podcast, !isFav);
    return vm.state == UiState.loading
        ? (!isFav)
            ? _following(() {}, context)
            : _follow(() {}, context)
        : isFav
            ? _following(onTap, context)
            : _follow(onTap, context);
  }

  Widget _following(Function() onTap, BuildContext context) =>
      OutlinedButton.icon(
        onPressed: onTap,
        label: Text(context.l10n!.following(1)),
        icon: const Icon(Icons.favorite),
        style: _style,
      );

  Widget _follow(Function() onTap, BuildContext context) => FilledButton.icon(
        onPressed: onTap,
        label: Text(context.l10n!.follow),
        icon: const Icon(Icons.favorite_border),
        style: _style,
      );

  ButtonStyle get _style => buttonStyle.copyWith(
        fixedSize: const MaterialStatePropertyAll(Size.fromWidth(150)),
      );
}
