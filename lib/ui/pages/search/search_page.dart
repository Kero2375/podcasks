import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/common/search_text_field.dart';
import 'package:podcasks/ui/pages/search/search_list.dart';
import 'package:podcasks/ui/vms/search_vm.dart';
import 'package:podcasks/ui/vms/vm.dart';

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
        title: SearchTextField(
          controller: vm.searchBarController,
          search: vm.search,
          init: vm.init,
          hint: 'Search or add RSS feed...',
          showFilters: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: vm.state == UiState.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Expanded(child: SearchList(items: vm.searched)),
      ),
    );
  }
}
