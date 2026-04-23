import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/common/themes.dart';
import 'package:podcasks/ui/pages/search/search_text_field.dart';
import 'package:podcasks/ui/pages/search/search_list.dart';
import 'package:podcasks/ui/vms/search_vm.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:podcasks/utils.dart';
import 'package:podcast_search/podcast_search.dart';

class SearchPage extends ConsumerWidget {
  static const route = "/search_page";

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(searchViewmodel);

    final bool isSearching =
        vm.searched.isNotEmpty || vm.searchBarController.text.isNotEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: FutureBuilder<Country>(
            future: vm.country,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              return SearchTextField(
                controller: vm.searchBarController,
                search: vm.search,
                init: () => vm.init(),
                hint: context.l10n!.searchHint,
                showFilters: true,
                clear: vm.clearText,
                isSearching: isSearching,
              );
            },
          ),
        ),
        Expanded(
          child: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final vm = ref.watch(searchViewmodel);
              if (vm.state == UiState.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                  ),
                );
              }
          
              if (vm.searched.isEmpty &&
                  vm.searchBarController.text.isEmpty) {
                return _GenreGrid(vm: vm);
              }
          
              if (vm.searched.isEmpty) {
                return Center(
                  child: Column(
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
                );
              }
          
              return SearchList(
                items: vm.searched,
                controller: vm.scrollController,
              );
            },
          ),
        ),
        
      ],
    );
  }
}

class _GenreGrid extends StatelessWidget {
  final SearchViewmodel vm;

  const _GenreGrid({required this.vm});

  IconData _getGenreIcon(String genre) {
    switch (genre) {
      case 'All':
        return Icons.grid_view;
      case 'Arts':
        return Icons.palette_outlined;
      case 'Business':
        return Icons.business;
      case 'Comedy':
        return Icons.sentiment_very_satisfied;
      case 'Education':
        return Icons.school_outlined;
      case 'Fiction':
        return Icons.menu_book;
      case 'Government':
        return Icons.account_balance_outlined;
      case 'Health & Fitness':
        return Icons.fitness_center;
      case 'History':
        return Icons.history_edu;
      case 'Kids & Family':
        return Icons.child_care;
      case 'Leisure':
        return Icons.beach_access_outlined;
      case 'Music':
        return Icons.music_note;
      case 'News':
        return Icons.newspaper;
      case 'Religion & Spirituality':
        return Icons.self_improvement;
      case 'Science':
        return Icons.science_outlined;
      case 'Society & Culture':
        return Icons.public;
      case 'Sports':
        return Icons.sports_basketball_outlined;
      case 'TV & Film':
        return Icons.movie_outlined;
      case 'Technology':
        return Icons.computer;
      case 'True Crime':
        return Icons.gavel;
      default:
        return Icons.podcasts;
    }
  }

  @override
  Widget build(BuildContext context) {
    final genres = vm.genres(context);
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 900 ? 5 : width > 600 ? 3 : 2;

    return GridView.builder(
      key: ValueKey(Theme.of(context).brightness),
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        final entry = genres.entries.elementAt(index);
        return Card(
          color: Theme.of(context).colorScheme.onPrimary,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => vm.setGenre(entry.key),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getGenreIcon(entry.key),
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    entry.value,
                    style: textStyleBody,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
