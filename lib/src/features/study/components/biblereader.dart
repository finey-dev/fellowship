import 'package:fellowship/src/configs/configs.dart';
import 'package:fellowship/src/data/models/models.dart';
import 'package:fellowship/src/data/providers/providers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fellowship/src/features/study/components/components.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BibleReader extends ConsumerWidget {
  const BibleReader({Key? key, required this.chapter}) : super(key: key);

  final Chapter chapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> children = [const SizedBox(height: 10)];
    List<InlineSpan> spans = [];
    children.add(
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: Text.rich(
          TextSpan(children: spans),
          style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: ref
                        .watch(readerSettingsRepositoryProvider.notifier)
                        .bodyTextSize *
                    1.4,
                height: ref
                        .watch(readerSettingsRepositoryProvider.notifier)
                        .bodyTextHeight *
                    1.1,
                fontFamily:
                    ref.watch(readerSettingsRepositoryProvider).typeFace,
              ),
        ),
      ),
    );
    for (int i = 0; i < chapter.verses!.length; i++) {
      var item = chapter.verses![i];
      var _isFavoriteVerse = ref
          .watch(studyToolsRepositoryProvider)
          .favoriteVerses
          .where((element) => element.id == item.id)
          .isNotEmpty;

      spans.add(
        WidgetSpan(
          child: GestureDetector(
            onTap: () async {
              HapticFeedback.mediumImpact();
              await showFavoriteVerseBottomSheet(context, item);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_isFavoriteVerse)
                    SvgPicture.asset(
                      AppAssetsPath.heartS,
                      height: ref
                              .watch(readerSettingsRepositoryProvider)
                              .verseNumberSize *
                          1.3,
                      width: ref
                              .watch(readerSettingsRepositoryProvider)
                              .verseNumberSize *
                          1.3,
                      color: kPrimaryColor,
                    ),
                  Text(
                    item.verseId.toString(),
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Theme.of(context).colorScheme.secondaryVariant,
                          fontSize: ref
                                  .watch(readerSettingsRepositoryProvider)
                                  .verseNumberSize *
                              1.1,
                          // height: ref.watch(readerSettingsRepositoryProvider).verseNumberHeight,
                          fontFamily: ref
                              .watch(readerSettingsRepositoryProvider)
                              .typeFace,
                        ),
                  ),
                  if (!_isFavoriteVerse)
                    const SizedBox(
                      height: 0,
                      width: 0,
                    ),
                ],
              ),
            ),
          ),
        ),
      );

      spans.add(
        TextSpan(
          text: item.text,
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              HapticFeedback.mediumImpact();
              await showFavoriteVerseBottomSheet(context, item);
            },
        ),
      );

      if (!(i == chapter.verses!.length - 1)) {
        spans.add(const TextSpan(text: ' '));
      }
    }
    return Container();
  }
}
