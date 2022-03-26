import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:provider/single_child_widget.dart';

mixin RxStateListenerSingleChildWidget on SingleChildWidget {}

typedef RxWidgetListener<S> = void Function(
  BuildContext context,
  S state,
);

class RxStateListener<T> extends SingleChildStatefulWidget
    with RxStateListenerSingleChildWidget {
  const RxStateListener({
    Widget? child,
    required this.rxState,
    required this.listener,
    Key? key,
  }) : super(key: key, child: child);

  final Rx<T> rxState;
  final RxWidgetListener<T> listener;

  @override
  SingleChildState<RxStateListener<T>> createState() =>
      _RxStateListenerState<T>();
}

class _RxStateListenerState<T> extends SingleChildState<RxStateListener<T>> {
  late Rx<T> _rxState;
  late StreamSubscription _subscription;
  late T _previousState;

  @override
  void initState() {
    super.initState();
    _rxState = widget.rxState;
    _previousState = widget.rxState.value;
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant RxStateListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldRxState = oldWidget.rxState;
    final currentRxState = widget.rxState;
    if (oldRxState != currentRxState) {
      _unsubscribe();
      _rxState = currentRxState;
      _previousState = _rxState.value;
    }
    _subscribe();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final rxState = widget.rxState;
    if (rxState != _rxState) {
      _unsubscribe();
      _rxState = rxState;
      _previousState = _rxState.value;
    }
    _subscribe();
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      child != null,
      '''${widget.runtimeType} used outside of MultiRxStateListener must specify a child''',
    );
    return child!;
  }

  void _subscribe() {
    _subscription = widget.rxState.stream.listen((state) {
      if (_previousState != state) {
        widget.listener(context, state);
      }

      _previousState = state;
    });
  }

  void _unsubscribe() {
    _subscription.cancel();
  }
}
