import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/vms/search_vm.dart';

class FiltersDialog extends ConsumerWidget {
  const FiltersDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(searchViewmodel);
    return Dialog(
      child: SizedBox(
        height: 500,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Icon(Icons.language),
                  // const SizedBox(width: 8),
                  Text(
                    "Select region",
                    style: textStyleHeader,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Scrollbar(
                radius: const Radius.circular(16),
                child: ListView(
                  children: Country.values
                      .map(
                        (c) => ListTile(
                          onTap: () => vm.setCountry(c),
                          title: Text(
                            (c.name == 'none')
                                ? 'Any'
                                : c.name
                                    .split(RegExp(r"(?=[A-Z])"))
                                    .map((e) =>
                                        e[0].toUpperCase() + e.substring(1))
                                    .join(' '),
                            style: textStyleBody,
                          ),
                          leading: FutureBuilder(
                            future: vm.country,
                            builder: (context, snapshot) => (snapshot.hasData)
                                ? Radio<Country>(
                                    value: c,
                                    groupValue: snapshot.data,
                                    onChanged: vm.setCountry,
                                  )
                                : Radio<Country>(
                                    value: c,
                                    groupValue: Country.none,
                                    onChanged: vm.setCountry,
                                  ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: buttonStyle,
                child: const Text("OK"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
