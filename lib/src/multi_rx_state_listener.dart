import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'rx_state_listener.dart';

class MultiRxStateListener extends MultiProvider {
  MultiRxStateListener({
    Key? key,
    required List<RxStateListenerSingleChildWidget> listeners,
    required Widget child,
  }) : super(key: key, providers: listeners, child: child);
}
