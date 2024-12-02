import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  final Duration duration;
  const Quiz({
    super.key,
    required this.duration,
  });

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late Timer _timer;
  late int _remainingMilliseconds;
  String _answerType = "Mixed";
  final List<String> answerTypes = ["True or False", "Multiple Choice", "Mixed", "Text Field"];

  @override
  void initState() {
    super.initState();

    _remainingMilliseconds = widget.duration.inMilliseconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_remainingMilliseconds > 0) {
          _remainingMilliseconds -= 50;
        } else {
          _timer.cancel();
          // Handle countdown completion (e.g., show a message, navigate to another screen)
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _QuizAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            _questionCard()

          ],
        ),
      ),
    );
  }

  Widget _textFieldAnswer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 128,
          ),
          FilledButton(
            onPressed: () {},
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  // Change your radius here
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            child: const SizedBox(width: double.infinity, height: 60, child: Center(child: Text("Submit"))),
          )
        ],
      ),
    );
  }

  Widget _trueOrFalseAnswer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
          height: 300,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        // Change your radius here
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all(Colors.amber)),
                child: const Text("True"),
              )),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                  child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        // Change your radius here
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all(Colors.pink)),
                child: const Text("False"),
              ))
            ],
          )),
    );
  }

  Widget _multipleChoiceAnswer() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  // Change your radius here
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            onPressed: () {},
            child: const SizedBox(
                height: 70,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Bintana",
                  style: TextStyle(fontSize: 18),
                ))),
          ),
        );
      },
    );
  }

  Widget _questionCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      elevation: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: const SizedBox(
          width: double.infinity,
          height: 250,
          child: Stack(
            children: [Positioned(top: 105, bottom: 0, right: 0, left: 0, child: Text("1+1 = ?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700), textAlign: TextAlign.center)),
              // Positioned(bottom: 0, left: 0, right: 0, child: _countDown())
            ],
          ),
        ),
      ),
    );
  }

  Widget _countDown() {
    return LinearProgressIndicator(
      minHeight: 8.0,
      value: _remainingMilliseconds / widget.duration.inMilliseconds,
      backgroundColor: Colors.grey,
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }

  Widget _changeAnswerTypeButton() {
    return Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: () {
            print(_answerType);
            showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    contentPadding: const EdgeInsets.all(8),
                    children: [
                      ListView.builder(
                        itemCount: answerTypes.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final type = answerTypes[index];
                          return SimpleDialogOption(
                            child: ListTile(
                              title: Text(type),
                              leading: _answerType == type ? const Icon(Icons.check) : null,
                              onTap: () {
                                setState(() {
                                  _answerType = type;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      )
                    ],
                  );
                });
          },
          label: const Text(
            "Change Answer Type",
            style: TextStyle(fontSize: 12),
          ),
          icon: const Icon(
            Icons.repeat,
            size: 20,
          ),
        ));
  }

  /// Dynamically renders the appropriate answer widget based on the selected `_answerType`.
  // Widget _renderAnswerWidget() {
  //   print(_answerType);
  //   switch (_answerType) {
  //     case "True or False":
  //       return _trueOrFalseAnswer();
  //     case "Multiple Choice":
  //       return _multipleChoiceAnswer();
  //     case "Text Field":
  //       return _textFieldAnswer();
  //     case "Mixed":
  //       // Randomly pick one of the available answer widgets
  //       final List<Widget Function()> widgetBuilders = [
  //         _trueOrFalseAnswer,
  //         _multipleChoiceAnswer,
  //         _textFieldAnswer,
  //       ];
  //
  //       final random = Random();
  //       int randomIndex = random.nextInt(widgetBuilders.length);
  //
  //       // Return the randomly chosen widget
  //       return widgetBuilders[randomIndex]();
  //     default: // Default case for "Mixed" or other types
  //       return const Padding(
  //         padding: EdgeInsets.all(16.0),
  //         child: Text(
  //           "No specific answer type selected. Please choose one.",
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //         ),
  //       );
  //   }
  // }
}

class _QuizAppBar extends StatefulWidget implements PreferredSizeWidget {
  const _QuizAppBar({super.key});

  @override
  State<_QuizAppBar> createState() => _QuizAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _QuizAppBarState extends State<_QuizAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Code Crack"),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back)),
      actions: [
        IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This is a snackbar')));
            },
            icon: const Icon(Icons.question_mark))
      ],
    );
  }
}
