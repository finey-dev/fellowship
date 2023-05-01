import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnexpectedError extends ConsumerWidget {
  const UnexpectedError(this.provider, {Key? key}) : super(key: key);

  final AutoDisposeFutureProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Oops, something unexpected happened :(',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => ref.refresh(provider),
            style: ButtonStyle(
              minimumSize:
                  MaterialStateProperty.all(const Size(double.infinity, 48)),
            ),
            child: const Text('Try Again!'),
          ),
        ],
      ),
    );
  }
}
