import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              // todo: reset search bar
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
            decoration: const InputDecoration(
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: "Search Podcast..."),
            onChanged: (value) {
              if (value.length > 2) {
                vm.search(value);
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
