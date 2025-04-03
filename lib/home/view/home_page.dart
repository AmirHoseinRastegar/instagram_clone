import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/navigation/navigation.dart';
import 'package:ui/ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.navShell, super.key});
  final StatefulNavigationShell navShell;

  @override
  Widget build(BuildContext context) {
    return HomeView(
      navShell: navShell,
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({required this.navShell, super.key});
  final StatefulNavigationShell navShell;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: navShell,
      bottomNavigationBar: BottomNavBar(navShell: navShell),
    );
  }
}
