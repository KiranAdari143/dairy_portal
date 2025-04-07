import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dairy_portal/app/modules/Drawerscreen/views/drawerscreen_view.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  final AppBar appBar;
  final FloatingActionButton? floatingActionButton;
  const MainScaffold(
      {Key? key,
      required this.body,
      required this.appBar,
      required this.floatingActionButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Change the breakpoint as needed.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          // For web (large screens), show a permanent drawer on the side.
          return Scaffold(
            appBar: appBar,
            body: Row(
              children: [
                // Permanent side drawer with a fixed width.
                Container(
                  width: 250,
                  color: Colors.white,
                  child: const DrawerscreenView(),
                ),
                // Main content area.
                Expanded(child: body),
              ],
            ),
            floatingActionButton: floatingActionButton,
          );
        } else {
          // For mobile (small screens), use a modal drawer.
          return Scaffold(
            appBar: appBar,
            drawer: const DrawerscreenView(),
            body: body,
            floatingActionButton: floatingActionButton,
          );
        }
      },
    );
  }
}
