import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:ui/ui.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({required this.navShell, super.key});
  final StatefulNavigationShell navShell;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final navBarItems = mainNavigationBarItems(
      homeLabel: l10n.homeNavBarItemLabel,
      searchLabel: l10n.searchNavBarItemLabel,
      createMediaLabel: l10n.createMediaNavBarItemLabel,
      reelsLabel: l10n.reelsNavBarItemLabel,
      userProfileLabel: l10n.profileNavBarItemLabel,
      userProfileAvatar: const Icon(Icons.person),
    );
    return BottomNavigationBar(
      currentIndex: navShell.currentIndex,
      onTap: (index) {
        if (index == 2) {
        } else {
          navShell.goBranch(
            index,
            initialLocation: index == navShell.currentIndex,
          );
        }
      },
      iconSize: 28,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: navBarItems
          .map(
            (e) => BottomNavigationBarItem(
              tooltip: e.tooltip,
              label: e.label,
              icon: e.child ?? Icon(e.icon),
            ),
          )
          .toList(),
    );
  }
}
