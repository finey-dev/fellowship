import 'package:fellowship/src/configs/configs.dart';
import 'package:fellowship/src/data/models/models.dart';
import 'package:fellowship/src/data/providers/providers.dart';
import 'package:fellowship/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerseOfTheDayView extends ConsumerStatefulWidget {
  const VerseOfTheDayView({Key? key, required this.verses}) : super(key: key);

  final List<Verse> verses;

  @override
  ConsumerState<VerseOfTheDayView> createState() => _VerseOfTheDayViewState();
}

class _VerseOfTheDayViewState extends ConsumerState<VerseOfTheDayView> {
  var _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite =
        ref.read(studyToolsRepositoryProvider).favoriteVerses.where((e) {
      return widget.verses.any((element) => e.id == element.id);
    }).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _header(context),
        _body(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    Widget favoriteButton(BuildContext context) {
      Color heartColor() {
        if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
          return const Color(0xFFf97583);
        }
        return const Color(0xFFf97583);
      }

      Widget icon() {
        if (ref.watch(studyToolsRepositoryProvider).favoriteVerses.where((e) {
          return widget.verses.any((element) => e.id == element.id);
        }).isNotEmpty) {
          return SvgPicture.asset(
            AppAssetsPath.heartS,
            height: 24,
            width: 24,
            color: heartColor(),
          );
        }
        return SvgPicture.asset(
          AppAssetsPath.heartT,
          height: 24,
          width: 24,
          color: Theme.of(context).colorScheme.primary,
        );
      }

      return GestureDetector(
        onTap: () async {
          HapticFeedback.mediumImpact();

          setState(() {
            _isFavorite = !_isFavorite;
          });

          for (Verse item in widget.verses) {
            if (_isFavorite) {
              await ref
                  .read(studyToolsRepositoryProvider)
                  .addFavoriteVerse(item);
            } else {
              await ref
                  .read(studyToolsRepositoryProvider)
                  .removeFavoriteVerse(item);
            }
          }
        },
        child: Container(
          height: 40,
          width: 40,
          margin: const EdgeInsets.symmetric(horizontal: 17),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          child: Center(
            child: icon(),
          ),
        ),
      );
    }

    return SliverAppBar(
      expandedHeight: 250,
      stretch: true,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      leadingWidth: 56 + 17.0,
      backgroundColor: WefellowshipMethods.alternateCanvasColor(context),
      leading: Container(
        padding: const EdgeInsets.all(7),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: SvgPicture.asset(
            AppAssetsPath.back,
            height: 24,
            width: 24,
            color: Colors.black,
          ),
        ),
      ),
      actions: [
        favoriteButton(context),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildImage(context),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          child: Text(
            'Verse of the Day',
            style: Theme.of(context).textTheme.headline4?.copyWith(
                  color: Colors.white,
                  fontSize: 17,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Image.asset(
      ref.watch(userRepositoryProvider).getNatureImage,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }

  Widget _body(BuildContext context) {
    Widget bookChapterVerse(BuildContext context) {
      String versesString() {
        var str = '';
        if (widget.verses.length > 1) {
          str = widget.verses.first.verseId.toString() +
              ' - ' +
              widget.verses.last.verseId.toString();
        } else {
          str = widget.verses[0].verseId.toString();
        }

        return str;
      }

      return SelectableText(
        widget.verses[0].book.name! +
            ' ' +
            widget.verses[0].chapterId.toString() +
            ':' +
            versesString(),
        style: Theme.of(context).textTheme.headline6?.copyWith(
              fontWeight: FontWeight.w500,
              height: ref
                  .watch(readerSettingsRepositoryProvider.notifier)
                  .bodyTextHeight,
              fontFamily: ref.watch(readerSettingsRepositoryProvider).typeFace,
            ),
      );
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 27.0),
        child: Column(
          children: [
            const SizedBox(
              height: 17.0,
            ),
            for (var verse in widget.verses)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SelectableText.rich(
                  TextSpan(
                    text: verse.verseId.toString() + ' ',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          fontSize: ref
                                  .watch(readerSettingsRepositoryProvider)
                                  .verseNumberSize *
                              1.5,
                          height: ref
                              .watch(readerSettingsRepositoryProvider)
                              .verseNumberHeight,
                          fontFamily: ref
                              .watch(readerSettingsRepositoryProvider)
                              .typeFace,
                        ),
                    children: [
                      TextSpan(
                        text: (verse.text +
                            (widget.verses.last == verse ? '' : ' ')),
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: ref
                                      .watch(readerSettingsRepositoryProvider
                                          .notifier)
                                      .bodyTextSize *
                                  1.5,
                              height: ref
                                  .watch(
                                      readerSettingsRepositoryProvider.notifier)
                                  .bodyTextHeight,
                              fontFamily: ref
                                  .watch(readerSettingsRepositoryProvider)
                                  .typeFace,
                            ),
                      ),
                    ],
                  ),
                  cursorColor: Theme.of(context).primaryColor,
                ),
              ),
            const SizedBox(height: 17.0),
            bookChapterVerse(context),
            const SizedBox(height: 17.0 * 3),
          ],
        ),
      ),
    );
  }
}
