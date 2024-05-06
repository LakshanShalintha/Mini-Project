import 'package:flutter/material.dart';

import '../../CommonParts/AppBar.dart';
import '../../CommonParts/Setting.dart';

class NewStory extends StatelessWidget {
  const NewStory({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Create Own Story',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurvedBackground(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                    child: SearchBar(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
