import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/bottom_navigation/bottom_bar.dart';
import 'package:podcasks/ui/pages/search/search_text_field.dart';
import 'package:podcasks/ui/pages/search/search_list.dart';
import 'package:podcasks/ui/vms/search_vm.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcasks/utils.dart';

class SearchPage extends StatelessWidget {
  static const route = "/search_page";

  const SearchPage({super.key});

  /// ------------------ TODO ---------------
  /// remove scaffold
  /// move bar on top of list
  /// fix expanded errors?
  /// make only list watching searchViewmodel? -> Consumer(...)

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final vm = ref.watch(searchViewmodel);
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SearchTextField(
                  controller: vm.searchBarController,
                  search: vm.search,
                  init: vm.init,
                  hint: context.l10n!.searchOrRssHint,
                  showFilters: true,
                  clear: vm.clearText,
                ),
              );
            },
          ),
          Expanded(
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final vm = ref.watch(searchViewmodel);
                return vm.state == UiState.loading
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
                        : SearchList(items: vm.searched);
              },
            ),
          ),
        ],
      ),
    );
  }
}
