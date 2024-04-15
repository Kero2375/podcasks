import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:ppp2/ui/common/themes.dart';
import 'package:ppp2/ui/pages/search/filters_dialog.dart';
import 'package:ppp2/ui/pages/search/search_list.dart';
import 'package:ppp2/ui/vms/search_vm.dart';
import 'package:ppp2/ui/vms/vm.dart';

class SearchPage extends ConsumerWidget {
  static const route = "/search_page";

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(searchViewmodel);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: "Search or add RSS feed...",
              suffixIcon: IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => FiltersDialog(
                    countries: const [
                      Country.none,
                      Country.italy,
                      Country.unitedKingdom,
                      Country.unitedArabEmirates,
                    ]
                  ),
                ),
                icon: const Icon(Icons.filter_list_sharp),
              ),
            ),
            style: textStyleBody,
            onChanged: (value) {
              if (value.trim().isNotEmpty) {
                vm.search(value);
              } else {
                vm.charts();
              }
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: vm.state == UiState.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SearchList(items: vm.searched),
      ),
    );
  }
}
