import 'package:fellowship/src/configs/configs.dart';
import 'package:fellowship/src/data/models/models.dart';
import 'package:fellowship/src/data/providers/providers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fellowship/utilities/utilities.dart';

Future<void> showFavoriteVerseBottomSheet(
    BuildContext context, Verse verse) async {
  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
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
        heightFactor: 0.3,
        widthFactor: isTablet(context) ? 0.75 : null,
        child: Consumer(
          builder: (context, ref, child) {
            return StatefulBuilder(
              builder: (context, setState) {
                var _isFavoriteVerse = ref
                    .read(studyToolsRepositoryProvider)
                    .favoriteVerses
                    .where((element) => element.id == verse.id)
                    .isNotEmpty;

                Widget icon() {
                  if (_isFavoriteVerse) {
                    return SvgPicture.asset(
                      AppAssetsPath.heartS,
                      height: 36,
                      width: 36,
                      color: kPrimaryColor,
                    );
                  }
                  return SvgPicture.asset(
                    AppAssetsPath.heartT,
                    height: 36,
                    width: 36,
                    color: Theme.of(context).colorScheme.primary,
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 27),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            verse.bookChapterVerse,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          HapticFeedback.lightImpact();

                          setState(() {
                            _isFavoriteVerse = !_isFavoriteVerse;
                          });

                          if (_isFavoriteVerse) {
                            await ref
                                .read(studyToolsRepositoryProvider)
                                .addFavoriteVerse(verse);
                          } else {
                            await ref
                                .read(studyToolsRepositoryProvider)
                                .removeFavoriteVerse(verse);
                          }
                        },
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: _isFavoriteVerse
                              ? SvgPicture.asset(
                                  AppAssetsPath.heartS,
                                  height: 36,
                                  width: 36,
                                  color: kPrimaryColor,
                                )
                              : SvgPicture.asset(
                                  AppAssetsPath.heartT,
                                  height: 36,
                                  width: 36,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    },
  );
}
