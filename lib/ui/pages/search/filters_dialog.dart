import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/search/filters_dropdown.dart';
import 'package:podcasks/ui/vms/search_vm.dart';
import 'package:podcasks/utils.dart';
import 'package:podcast_search/podcast_search.dart';

class FiltersDialog extends ConsumerWidget {
  const FiltersDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(searchViewmodel);
    return Dialog(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                textAlign: TextAlign.center,
                context.l10n!.searchFilters.toUpperCase(),
                style: textStyleHeader,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                context.l10n!.region,
                style: textStyleBody,
              ),
            ),
            FutureBuilder(
              future: vm.country,
              builder: (context, snapshot) {
                return (snapshot.hasData)
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: FilterDropdown<Country>(
                          onChanged: vm.setCountry,
                          value: snapshot.data,
                          items: Country.values.asMap().map((_, e) => MapEntry(e, e)),
                          getString: (c) => c.name,
                        ))
                    : const SizedBox.shrink();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                context.l10n!.genre,
                style: textStyleBody,
              ),
            ),
            FutureBuilder(
              future: vm.genre,
              builder: (context, snapshot) {
                return (snapshot.hasData)
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: FilterDropdown<String>(
                          onChanged: vm.setGenre,
                          value: snapshot.data,
                          items: vm.genres(context),
                          getString: (c) => c,
                        ))
                    : const SizedBox.shrink();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: buttonStyle,
                child: Text(context.l10n!.ok.toUpperCase()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
