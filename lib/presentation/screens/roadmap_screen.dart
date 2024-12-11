import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/app_localizations.dart';
import '../extensions/context_extension.dart';

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final roadmap = <(String, String?, bool)>[
      ('Initial Release'.localized, 'First build is now live!'.localized, true),
      (
        'Subcategories'.localized,
        'Organize several categories within a main category'.localized,
        true
      ),
      (
        'Transaction Labels'.localized,
        'Label unrelated transactions'.localized,
        true
      ),
      (
        'Wallet Creation'.localized,
        'Create more wallets, each having separate transactions'.localized,
        true
      ),
      (
        'Wallet Transfers'.localized,
        'Quick transactions between wallets'.localized,
        false
      ),
      (
        'Cloud Sync'.localized,
        'Save your data on the cloud and sync it on multiple devices'.localized,
        false
      ),
      (
        'Wallet Sharing'.localized,
        'Share any wallet with a friend or a family member!'.localized,
        false
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Roadmap'.localized,
          style: context.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in roadmap)
              ListTile(
                leading: item.$3
                    ? const FaIcon(
                        FontAwesomeIcons.solidCircleCheck,
                        color: Colors.green,
                      )
                    : const FaIcon(
                        FontAwesomeIcons.circleMinus,
                        color: Colors.grey,
                      ),
                title: Text(item.$1),
                subtitle: item.$2 == null
                    ? null
                    : Text(
                        item.$2 ?? '',
                        style: context.bodySmall,
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
