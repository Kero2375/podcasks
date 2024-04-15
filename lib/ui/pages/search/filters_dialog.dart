import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/ui/vms/search_vm.dart';

class FiltersDialog extends ConsumerWidget {
  final List<Country> countries;

  const FiltersDialog({
    super.key,
    required this.countries,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(searchViewmodel);
    return Dialog(
      child: SizedBox(
        height: 500,
        child: Column(
          children: countries
              .map(
                (c) => ListTile(
                  title: Text(
                    c.name
                        .split(RegExp(r"(?=[A-Z])"))
                        .map((e) => e[0].toUpperCase() + e.substring(1))
                        .join(' '),
                  ),
                  leading: Radio<Country>(
                    value: c,
                    groupValue: vm.getSelectedCountry(),
                    onChanged: vm.setCountry,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
