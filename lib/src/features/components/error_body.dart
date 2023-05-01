import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorBody extends ConsumerWidget {
  final String message;
  final AutoDisposeFutureProvider provider;

  const ErrorBody(this.message, this.provider, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            message,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => ref.refresh(provider),
          style: ButtonStyle(
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 48)),
          ),
          child: const Text('Try Again!'),
        ),
      ],
    );
  }
}
