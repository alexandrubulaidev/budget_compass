import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../data/entities/tag_entity.dart';
import '../../../../utils/app_localizations.dart';
import '../../../app_theme.dart';
import '../../../extensions/context_extension.dart';
import '../../../widgets/base/ink_tap.dart';
import '../../../widgets/tags/tag_toggle_widget.dart';
import '../../../widgets/tags/transaction_tag_icon.dart';

class TagGroupListItem extends StatelessWidget {
  const TagGroupListItem({
    required this.parent,
    required this.children,
    required this.onDelete,
    required this.onParentTap,
    required this.onEditChildrenTap,
    required this.onChildTapped,
    required this.onChildLongTapped,
    super.key,
  });

  final void Function() onDelete;
  final void Function() onParentTap;
  final void Function() onEditChildrenTap;
  final void Function(TagEntity child) onChildTapped;
  final void Function(TagEntity child) onChildLongTapped;
  final TagEntity parent;
  final List<TagEntity> children;

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkTap(
          borderRadius: BorderRadius.zero,
          onTap: onParentTap,
          onLongTap: onDelete,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kHorizontalPadding,
              vertical: kVerticalPadding / 2,
            ),
            child: Row(
              children: [
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: parent.color,
                  ),
                  child: Center(
                    child: TransactionTagIcon(
                      icon: parent.icon,
                      size: 12,
                      color: context.background,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  parent.name.localized,
                  style: context.titleMedium,
                ),
                const Spacer(),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  size: 15,
                  color: context.hintColor,
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: kHorizontalPadding,
            vertical: kVerticalPadding / 2,
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            spacing: 8,
            children: [
              for (final tag in children) ...[
                TagToggleWidget(
                  onLongTap: () {
                    onChildLongTapped(tag);
                  },
                  onTap: () {
                    onChildTapped(tag);
                  },
                  iconSize: 15,
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  color: tag.color,
                  name: tag.name,
                  icon: tag.icon,
                  selected: true,
                ),
              ],
              TagToggleWidget(
                onTap: onEditChildrenTap,
                iconSize: 15,
                color: context.hintColor,
                name: 'Edit Subcategories',
                icon: FontAwesomeIcons.arrowRight,
                direction: TextDirection.rtl,
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
