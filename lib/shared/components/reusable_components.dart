import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void showFlutterToast({
  required context,
  required String text,
  required ToastStates state,
  Color textColor = Colors.white,
}) {
  showToast(
    text,
    borderRadius: BorderRadius.circular(10.0),
    context: context,
    animation: StyledToastAnimation.slideFromBottom,
    reverseAnimation: StyledToastAnimation.slideFromTopFade,
    position: StyledToastPosition.top,
    duration: const Duration(seconds: 5),
    animDuration: const Duration(milliseconds: 250),
    backgroundColor: chooseToastState(state: state),
    textStyle: TextStyle(fontSize: 16.0, color: textColor),
  );
}

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastState({
  required ToastStates state,
}) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;

    case ToastStates.ERROR:
      color = Colors.red;
      break;

    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

Widget buildListItem({
  required IconData prefixIcon,
  required String title,
  required context,
  required Widget destinationWidget,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        const SizedBox(
          width: 10.0,
        ),
        Icon(prefixIcon),
        const SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => destinationWidget,
              ),
            );
          },
          icon: const Icon(Icons.arrow_forward_ios_rounded),
        ),
      ],
    ),
  );
}

// SnackBar Widget:
void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.blueAccent,
  );

  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}
