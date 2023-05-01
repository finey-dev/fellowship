import 'package:fellowship/src/configs/configs.dart';
import 'package:fellowship/src/data/models/models.dart';
import 'package:fellowship/src/data/providers/providers.dart';
import 'package:fellowship/src/features/screens.dart';
import 'package:fellowship/src/features/study/components/components.dart';
import 'package:fellowship/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerseOfTheDayCard extends ConsumerStatefulWidget {
  const VerseOfTheDayCard({Key? key}) : super(key: key);

  @override
  _VerseOfTheDayCardState createState() => _VerseOfTheDayCardState();
}

class _VerseOfTheDayCardState extends ConsumerState<VerseOfTheDayCard> {
  var _isFavorite = false;
  List<Verse>? _verses = [];

  @override
  void initState() {
    super.initState();
    _checkIfVerseIsFavorite();
  }

  void _checkIfVerseIsFavorite() {
    _isFavorite =
        ref.read(studyToolsRepositoryProvider).favoriteVerses.where((e) {
      return _verses!.any((element) => e.text == element.text);
    }).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    const elementSpacing = 17.0;
    Color bgColor() {
      if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
        return const Color(0xFF373e47);
      }
      return const Color(0xFF909dab);
    }

    final votdRepo = ref.watch(verseOfTheDayFutureProvider);

    return votdRepo.when(
      error: (e, s) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: const ErrorCard(),
          ),
        );
      },
      loading: () {
        return const LoadingCard();
      },
      data: (verses) {
        _verses = verses;
        _checkIfVerseIsFavorite();

        return GestureDetector(
          onTap: () {
            WefellowshipMethods.viewTransition(
                context, VerseOfTheDayView(verses: _verses!));
          },
          child: Container(
            padding: const EdgeInsets.all(17.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: WefellowshipMethods.alternateCanvasColorType3(context),
            ),
            child: Column(
              children: [
                _buildImage(context),
                const SizedBox(height: elementSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _header(context, bgColor()),
                          const SizedBox(height: elementSpacing),
                          _body(context, bgColor()),
                          const SizedBox(height: elementSpacing),
                          _bookChapterVerse(context),
                        ],
                      ),
                    ),
                    _favoriteButton(context, bgColor(), _verses!),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage(BuildContext context) {
    var imagePath = ref.watch(userRepositoryProvider).getNatureImage;

    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: Image.asset(
        imagePath,
        fit: BoxFit.fitWidth,
        height: 140,
        width: MediaQuery.of(context).size.width,
        errorBuilder: (_, __, ___) {
          return Container();
        },
      ),
    );

    return imageWidget;
  }

  Widget _header(BuildContext context, Color bgColor) {
    return Text(
      'Verse of the Day',
      style: Theme.of(context)
          .textTheme
          .headline4
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _favoriteButton(
      BuildContext context, Color bgColor, List<Verse> verses) {
    Color heartColor() {
      if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
        return const Color(0xFFf47067);
      }
      return const Color(0xFFf97583);
    }

    Widget icon() {
      if (ref.watch(studyToolsRepositoryProvider).favoriteVerses.where((e) {
        return _verses!.any((element) => e.id == element.id);
      }).isNotEmpty) {
        return SvgPicture.asset(
          AppAssetsPath.heartS,
          height: 24,
          width: 24,
          color: kPrimaryColor,
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

        for (Verse item in verses) {
          if (_isFavorite) {
            await ref.read(studyToolsRepositoryProvider).addFavoriteVerse(item);
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
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Center(
          child: icon(),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, Color bgColor) {
    String verseText() {
      var str = '';
      for (Verse item in _verses!) {
        str += '${item.text} ';
      }
      return str.substring(0, str.length);
    }

    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Text(
              verseText(),
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: _verses == null
                        ? Theme.of(context).colorScheme.error
                        : null,
                    fontFamily:
                        ref.watch(readerSettingsRepositoryProvider).typeFace,
                    fontSize: ref
                            .watch(readerSettingsRepositoryProvider)
                            .bodyTextSize *
                        1.3,
                    height: ref
                            .watch(readerSettingsRepositoryProvider)
                            .bodyTextHeight *
                        0.8,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookChapterVerse(BuildContext context) {
    String versesString() {
      if (_verses != null) {
        var str = '';
        if (_verses!.length > 1) {
          str = '${_verses!.first.verseId} - ${_verses!.last.verseId}';
        } else {
          str = _verses![0].verseId.toString();
        }

        return str;
      }
      return '';
    }

    return Text(
      _verses == null
          ? 'Matthew 28:20'
          : '${_verses![0].book.name!} ${_verses![0].chapterId}:${versesString()}',
      style: Theme.of(context)
          .textTheme
          .headlineMedium
          ?.copyWith(fontWeight: FontWeight.w500),
    );
  }
}
