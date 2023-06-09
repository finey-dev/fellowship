import 'package:fellowship/src/configs/configs.dart';
import 'package:fellowship/src/data/models/models.dart';
import 'package:fellowship/src/data/providers/providers.dart';
import 'package:fellowship/src/data/services/services.dart';
import 'package:fellowship/src/features/components/components.dart';
import 'package:fellowship/utilities/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fellowship/utilities/utilities.dart';

import 'components/components.dart';

class Bible extends ConsumerStatefulWidget {
  const Bible({Key? key}) : super(key: key);

  @override
  _BibleState createState() => _BibleState();
}

class _BibleState extends ConsumerState<Bible> {
  var _isBookmarked = false;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final translations = ref.watch(bibleTranslationsProvider);
    final booksRepo = ref.watch(bibleBooksProvider);
    final chaptersRepo = ref.watch(bibleChaptersProvider);

    translations.sort((a, b) => a.id!.compareTo(b.id!));

    return booksRepo.when(
      error: (e, s) {
        if (e is Exceptions) {
          return ErrorBody(e.message, bibleBooksProvider);
        }
        return UnexpectedError(bibleBooksProvider);
      },
      loading: () => Container(),
      data: (books) {
        return chaptersRepo.when(
          error: (e, s) {
            if (e is Exceptions) {
              return ErrorBody(e.message, bibleChaptersProvider);
            }
            return UnexpectedError(bibleChaptersProvider);
          },
          loading: () => Container(),
          data: (chapter) {
            _isBookmarked = _isBookmarked = ref
                .watch(studyToolsRepositoryProvider)
                .bookmarkedChapters
                .where((e) =>
                    e.id == chapter.id &&
                    e.verses![0].book.id == chapter.verses![0].book.id)
                .isNotEmpty;

            final kChapter = chapter.copyWith(verses: [
              for (var item in chapter.verses!)
                item.copyWith(text: item.text.replaceAll('\\"', '"')),
            ]);

            return Responsive(
              tablet: _buildTabletContent(
                  context, ref, translations, books, kChapter),
              mobile: _buildMobileContent(
                  context, ref, translations, books, kChapter),
            );
          },
        );
      },
    );
  }

  Widget _buildMobileContent(
    BuildContext context,
    WidgetRef ref,
    List<Translation> translations,
    List<Book> books,
    Chapter chapter,
  ) {
    Widget reader() {
      return SliverToBoxAdapter(
        child: BibleReader(chapter: chapter),
      );
    }

    return Scrollbar(
      controller: _scrollController,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildMobileHeader(context, ref, translations, books, chapter),
          reader()
        ],
      ),
    );
  }

  Widget _buildTabletContent(
    BuildContext context,
    WidgetRef ref,
    List<Translation> translations,
    List<Book> books,
    Chapter chapter,
  ) {
    Widget reader() {
      return SliverToBoxAdapter(
        child: BibleReader(chapter: chapter),
      );
    }

    return Scrollbar(
      controller: _scrollController,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildTabletHeader(context, ref, translations, books, chapter),
          reader()
        ],
      ),
    );
  }

  Widget _buildMobileHeader(
    BuildContext context,
    WidgetRef ref,
    List<Translation> translations,
    List<Book> books,
    Chapter chapter,
  ) {
    Widget _previousChapterButton() {
      return GestureDetector(
        onTap: () async {
          HapticFeedback.lightImpact();

          await ref
              .read(bibleRepositoryProvider)
              .goToNextPreviousChapter(ref, true);
        },
        child: SvgPicture.asset(
          AppAssetsPath.back,
          width: 27,
          height: 27,
          color: Colors.black,
        ),
      );
    }

    Widget _nextChapterButton() {
      return GestureDetector(
        onTap: () async {
          HapticFeedback.lightImpact();

          await ref
              .read(bibleRepositoryProvider)
              .goToNextPreviousChapter(ref, false);
        },
        child: SvgPicture.asset(
          AppAssetsPath.chevronRight,
          width: 27,
          height: 27,
          color: Colors.black,
        ),
      );
    }

    Widget _bookmarkButton(Chapter chapter) {
      return GestureDetector(
        onTap: () async {
          HapticFeedback.lightImpact();

          setState(() {
            _isBookmarked = !_isBookmarked;
          });

          if (_isBookmarked) {
            await ref
                .read(studyToolsRepositoryProvider.notifier)
                .addBookmarkChapter(chapter);
          } else {
            await ref
                .read(studyToolsRepositoryProvider.notifier)
                .removeBookmarkChapter(chapter);
          }
        },
        child: Icon(
          _isBookmarked
              ? CupertinoIcons.bookmark_fill
              : CupertinoIcons.bookmark,
          size: 24,
          color: _isBookmarked
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.primary,
        ),
      );
    }

    Widget _readerSettingsButton() {
      return GestureDetector(
        onTap: () async {
          HapticFeedback.lightImpact();

          await _showReaderSettingsBottomSheet();
        },
        child: SvgPicture.asset(
          AppAssetsPath.settings,
          width: 24,
          height: 24,
          color: Colors.black,
        ),
      );
    }

    Widget _translationControls(
        String bookChapterTitle, List<Translation> translations) {
      return Row(
        children: [
          GestureDetector(
            onTap: () async {
              HapticFeedback.lightImpact();

              await _showBookAndChapterBottomSheet();
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(10)),
                color: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              child: Text(
                bookChapterTitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: () async {
              HapticFeedback.lightImpact();

              await _showTranslationsBottomSheet(context, translations);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(10)),
                color: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              child: Text(
                translations[int.parse(translationID)]
                    .abbreviation!
                    .toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );
    }

    Widget _chapterVerseTranslationControls(
        List<Translation> translations, List<Book> books, Chapter chapter) {
      var bookChapterTitle =
          chapter.verses![0].book.name! + ' ' + chapter.number!;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _previousChapterButton(),
          const Spacer(),
          _readerSettingsButton(),
          const Spacer(),
          _translationControls(bookChapterTitle, translations),
          const Spacer(),
          _bookmarkButton(chapter),
          const Spacer(),
          _nextChapterButton(),
        ],
      );
    }

    return SliverAppBar(
      centerTitle: true,
      floating: true,
      backgroundColor: WefellowshipMethods.alternateCanvasColor(context),
      title: _chapterVerseTranslationControls(translations, books, chapter),
    );
  }

  Widget _buildTabletHeader(
    BuildContext context,
    WidgetRef ref,
    List<Translation> translations,
    List<Book> books,
    Chapter chapter,
  ) {
    Widget _previousChapterButton() {
      return GestureDetector(
        onTap: () async {
          HapticFeedback.lightImpact();

          await ref
              .read(bibleRepositoryProvider)
              .goToNextPreviousChapter(ref, true);
        },
        child: SvgPicture.asset(
          AppAssetsPath.back,
          width: 34,
          height: 34,
          color: Colors.black,
        ),
      );
    }

    Widget _nextChapterButton() {
      return GestureDetector(
        onTap: () async {
          HapticFeedback.lightImpact();

          await ref
              .read(bibleRepositoryProvider)
              .goToNextPreviousChapter(ref, false);
        },
        child: SvgPicture.asset(
          AppAssetsPath.chevronRight,
          width: 34,
          height: 34,
          color: Colors.black,
        ),
      );
    }

    Widget _bookmarkButton(Chapter chapter) {
      return GestureDetector(
        onTap: () async {
          HapticFeedback.lightImpact();

          setState(() {
            _isBookmarked = !_isBookmarked;
          });

          if (_isBookmarked) {
            await ref
                .read(studyToolsRepositoryProvider.notifier)
                .addBookmarkChapter(chapter);
          } else {
            await ref
                .read(studyToolsRepositoryProvider.notifier)
                .removeBookmarkChapter(chapter);
          }
        },
        child: Icon(
          _isBookmarked
              ? CupertinoIcons.bookmark_fill
              : CupertinoIcons.bookmark,
          size: 28,
          color: _isBookmarked
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.primary,
        ),
      );
    }

    Widget _readerSettingsButton() {
      return GestureDetector(
        onTap: () async {
          HapticFeedback.lightImpact();

          await _showReaderSettingsBottomSheet();
        },
        child: SvgPicture.asset(
          AppAssetsPath.settings,
          width: 28,
          height: 28,
          color: Colors.black,
        ),
      );
    }

    Widget _translationControls(
        String bookChapterTitle, List<Translation> translations) {
      return Row(
        children: [
          GestureDetector(
            onTap: () async {
              HapticFeedback.lightImpact();

              await _showBookAndChapterBottomSheet();
            },
            child: Container(
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(10)),
                color: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              child: Text(
                bookChapterTitle,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      height: 1.3,
                    ),
              ),
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: () async {
              HapticFeedback.lightImpact();

              await _showTranslationsBottomSheet(context, translations);
            },
            child: Container(
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(10)),
                color: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              child: Text(
                translations[int.parse(translationID)]
                    .abbreviation!
                    .toUpperCase(),
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      height: 1.3,
                    ),
              ),
            ),
          ),
        ],
      );
    }

    Widget _chapterVerseTranslationControls(
        List<Translation> translations, List<Book> books, Chapter chapter) {
      var bookChapterTitle =
          chapter.verses![0].book.name! + ' ' + chapter.number!;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _previousChapterButton(),
          const Spacer(),
          _readerSettingsButton(),
          const Spacer(),
          _translationControls(bookChapterTitle, translations),
          const Spacer(),
          _bookmarkButton(chapter),
          const Spacer(),
          _nextChapterButton(),
        ],
      );
    }

    return SliverAppBar(
      centerTitle: true,
      floating: true,
      backgroundColor: WefellowshipMethods.alternateCanvasColor(context),
      title: _chapterVerseTranslationControls(translations, books, chapter),
    );
  }

  Future<void> _showReaderSettingsBottomSheet() async {

    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(17)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          widthFactor: Responsive.isTablet(context) ? 0.75 : null,
          child: StatefulBuilder(
            builder: (context, setState) {
              Widget textSizeControls = Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Text Size',
                        style: Theme.of(context).textTheme.headline5),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        await ref
                            .read(readerSettingsRepositoryProvider)
                            .decrementBodyTextSize();
                        await ref
                            .read(readerSettingsRepositoryProvider)
                            .decrementVerseNumberSize();
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          'A',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                fontSize: 16,
                                height: 1.25,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        await ref
                            .read(readerSettingsRepositoryProvider)
                            .incrementBodyTextSize();
                        await ref
                            .read(readerSettingsRepositoryProvider)
                            .incrementVerseNumberSize();
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          'A',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                fontSize: 30,
                                height: 2,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              );

              Widget fontControls = MaterialExpansionTile(
                childrenPadding: EdgeInsets.zero,
                iconColor: Theme.of(context).colorScheme.primary,
                title: Text(
                  ref.watch(readerSettingsRepositoryProvider).typeFace,
                  style: Theme.of(context).textTheme.headline5,
                ),
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await ref
                              .read(readerSettingsRepositoryProvider)
                              .setTypeFace('New York');
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'New York',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      fontFamily: 'New York',
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 17),
                      GestureDetector(
                        onTap: () async {
                          await ref
                              .read(readerSettingsRepositoryProvider)
                              .setTypeFace('Inter');
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Inter',
                            style:
                                Theme.of(context).textTheme.headline4?.copyWith(
                                      fontFamily: 'Inter',
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );

              Widget lineHeightControls = Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Line Spacing',
                        style: Theme.of(context).textTheme.headline5),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        await ref
                            .read(readerSettingsRepositoryProvider)
                            .decrementBodyTextHeight();
                        await ref
                            .read(readerSettingsRepositoryProvider)
                            .decrementVerseNumberHeight();
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.format_line_spacing,
                            color: Theme.of(context).colorScheme.onBackground,
                            size: 16),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        await ref
                            .read(readerSettingsRepositoryProvider)
                            .incrementBodyTextHeight();
                        await ref
                            .read(readerSettingsRepositoryProvider)
                            .incrementVerseNumberHeight();
                        setState(() {});
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.format_line_spacing,
                            color: Theme.of(context).colorScheme.onBackground,
                            size: 26),
                      ),
                    ),
                  ],
                ),
              );

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textSizeControls,
                    const SizedBox(height: 17),
                    const Divider(),
                    const SizedBox(height: 5),
                    fontControls,
                    const Divider(height: 17),
                    const SizedBox(height: 8.5),
                    lineHeightControls,
                    const Divider(height: 34),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showBookAndChapterBottomSheet() async {
    List<Book> books = await BibleService().getBooks('');

    Widget _bookCard(Book book) {
      Widget _chapterCard(ChapterId chapter) {
        return GestureDetector(
          onTap: () async {
            HapticFeedback.lightImpact();
            await ref
                .read(bibleRepositoryProvider)
                .changeChapter(ref, book.id!, chapter.id!);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  width: 0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                chapter.id.toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        );
      }

      return MaterialExpansionTile(
        childrenPadding: const EdgeInsets.symmetric(horizontal: 24),
        title: Text(book.name!, style: Theme.of(context).textTheme.headline6),
        iconColor: Theme.of(context).colorScheme.primary,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: book.chapters!.length,
              itemBuilder: (context, index) =>
                  _chapterCard(book.chapters![index]),
            ),
          ),
        ],
      );
    }

    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(17)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.95,
          widthFactor: Responsive.isTablet(context) ? 0.75 : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 27),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Books',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              Expanded(
                child: ListView.separated(
                  itemCount: books.length,
                  separatorBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(),
                    );
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        if (index == 0)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Divider(),
                          ),
                        _bookCard(books[index]),
                        if (index == 0)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Divider(),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showTranslationsBottomSheet(
      BuildContext context, List<Translation> translations) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(17)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          widthFactor: Responsive.isTablet(context) ? 0.75 : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 27),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Versions',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              Expanded(
                child: ListView.separated(
                  itemCount: translations.length,
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Responsive.isTablet(context)
                          ? const Divider(height: 10)
                          : const Divider(),
                    );
                  },
                  itemBuilder: (context, index) {
                    var translation = translations[index];
                    Widget _translationCard() {
                      return GestureDetector(
                        onTap: () async {
                          await ref
                              .read(localRepositoryProvider.notifier)
                              .changeBibleTranslation(
                                index,
                                translation.abbreviation!.toLowerCase(),
                              );

                          ref.refresh(bibleChaptersProvider);
                          setState(() {});

                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 24),
                          title: Text(
                            translation.name!,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                  fontSize:
                                      Responsive.isTablet(context) ? 21 : null,
                                ),
                          ),
                          trailing: Text(
                            translation.abbreviation!.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryVariant,
                                  fontSize:
                                      Responsive.isTablet(context) ? 18 : null,
                                ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        if (index == 0)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Divider(),
                          ),
                        _translationCard(),
                        if (index == translations.length - 1)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Divider(),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
