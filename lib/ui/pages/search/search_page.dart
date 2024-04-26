import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/search/search_text_field.dart';
import 'package:podcasks/ui/pages/search/search_list.dart';
import 'package:podcasks/ui/vms/search_vm.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcasks/utils.dart';

class SearchPage extends ConsumerWidget {
  static const route = "/search_page";

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(searchViewmodel);
    final bool isEmpty = vm.searchBarController.text.trim() == '';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              if (isEmpty) {
                Navigator.pop(context);
              } else {
                vm.clearText();
              }
            },
            icon: Icon(isEmpty ? Icons.close : Icons.backspace),
          ),
        ],
        title: SearchTextField(
          controller: vm.searchBarController,
          search: vm.search,
          init: vm.init,
          hint: context.l10n!.searchOrRssHint,
          showFilters: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: vm.state == UiState.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : vm.searched.isEmpty
                ? Center(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n!.noResults,
                          style: textStyleBody,
                        ),
                        Text(
                          context.l10n!.noResultsEmoji,
                          style: textStyleBody,
                        ),
                      ],
                    ),
                  )
                : SearchList(items: vm.searched),
      ),
    );
  }
}
