import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final StatefulNavigationShell currentChild;

  int getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;

    switch (location) {
      case "/":
        return 0;
      case "/categories":
        return 1;
      case "/favorites":
        return 2;
      default:
        return 0;
    }
  }

  const CustomBottomNavigation({super.key, required this.currentChild});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: getCurrentIndex(context),
      onTap: (index) => currentChild.goBranch(index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_max),
          label: "Inicio",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outline),
          label: "Categorias",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: "Favoritos",
        ),
      ],
    );
  }
}
