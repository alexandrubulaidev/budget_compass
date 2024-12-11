import 'package:flutter/material.dart';

class TabViewer extends StatefulWidget {
  const TabViewer({
    required this.titles,
    required this.children,
    super.key,
  });

  final List<String> titles;
  final List<Widget> children;

  @override
  State<TabViewer> createState() => _TabViewerState();
}

class _TabViewerState extends State<TabViewer> with TickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.titles.length,
      vsync: this,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _controller,
          tabs: widget.titles
              .map(
                (final e) => Tab(
                  text: e,
                ),
              )
              .toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}
