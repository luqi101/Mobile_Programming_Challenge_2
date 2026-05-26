import 'package:flutter/material.dart';

import 'empty_state.dart';
import 'error_state.dart';
import 'loading_state.dart';

class AsyncStateView<T> extends StatelessWidget {
  const AsyncStateView({
    super.key,
    required this.future,
    required this.builder,
    this.emptyMessage,
  });

  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingState();
        }
        if (snapshot.hasError) {
          return ErrorState(
            title: 'Portfolio data unavailable',
            message: snapshot.error.toString(),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return EmptyState(message: emptyMessage ?? 'No data available.');
        }
        if (data is Iterable && data.isEmpty) {
          return EmptyState(message: emptyMessage ?? 'No items available.');
        }
        return builder(context, data);
      },
    );
  }
}
