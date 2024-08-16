import 'package:daily_quran/resources/styles.dart';
import 'package:flutter/material.dart';

class BottomActionFabWidget extends StatelessWidget {
  const BottomActionFabWidget(
      {super.key,
      required this.incrementCallback,
      required this.decrementCallback,
      this.isVisible = true,
      });

  final VoidCallback incrementCallback;
  final VoidCallback decrementCallback;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Visibility(
        visible: isVisible,
        child: Row(
          children: [
            const SizedBox(
              width: 30,
            ),
            FloatingActionButton(
              backgroundColor: Styles.actionFabBGColor,
              onPressed: decrementCallback,
              tooltip: 'Decrement',
              heroTag: null,
              child: const Icon(Icons.arrow_back,color: Colors.blueAccent,),
            ),

            const Spacer(),

            FloatingActionButton(
              backgroundColor: Styles.actionFabBGColor,
              onPressed: incrementCallback,
              heroTag: null,
              tooltip: 'Increment',
              child: const Icon(Icons.arrow_forward,color:Colors.blueAccent,),
            ),

          ],
        ),
      ),
    );
  }
}
