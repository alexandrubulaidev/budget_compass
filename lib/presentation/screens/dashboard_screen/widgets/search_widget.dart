import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../domain/services.dart';
import '../../../../domain/wallet/wallet_service.dart';
import '../../../app_theme.dart';
import '../../../widgets/base/biz_input_field.dart';
import '../../../widgets/base/rx_builder.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({super.key});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  WalletService get _walletService => Services.get<WalletService>();
  StreamSubscription<dynamic>? _filterSubscription;
  String? _previous;
  final _focusNode = FocusNode();
  final _controller = TextEditingController();

  void _clear() {
    _walletService.search(null);
  }

  @override
  void initState() {
    super.initState();
    _filterSubscription = _walletService.filterStream.listen((final event) {
      if (_previous == null && event.text != null) {
        _controller.text = event.text ?? '';
        _focusNode.requestFocus();
      }
      _previous = event.text;
    });
    _controller.addListener(() {
      _walletService.search(_controller.text);
    });
  }

  @override
  void dispose() {
    unawaited(_filterSubscription?.cancel());
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return RxBuilder(
      subject: _walletService.filterStream,
      builder: (final context, final value) {
        if (value.text == null) {
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: kVerticalPadding,
            horizontal: kHorizontalPadding,
          ),
          child: BizInputField(
            controller: _controller,
            focusNode: _focusNode,
            label: 'Full text search',
            suffixIcon: FontAwesomeIcons.xmark,
            onSuffixTapped: _clear,
          ),
        );
      },
    );
  }
}
