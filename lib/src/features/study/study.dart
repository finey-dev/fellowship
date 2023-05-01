import 'package:fellowship/src/features/study/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Study extends ConsumerStatefulWidget {
  const Study({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudyState();
}

class _StudyState extends ConsumerState<Study> {
  @override
  Widget build(BuildContext context) {
    String greeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Morning';
      }
      if (hour < 17) {
        return 'Afternoon';
      }
      return 'Evening';
    }

    String name(String source) {
      if (source.length > 18) {
        return source.substring(0, 15) + '...';
      }
      return source;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: Text(
              'Good ' + greeting() + ', ' + ' Bro. Branham',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(letterSpacing: 0.1),
            ),
          ),
        const SizedBox(height: 17),
        const VerseOfTheDayCard(),
        

        ],
      ),
    );
  }
}
