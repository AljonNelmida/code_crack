import 'dart:math';

import 'package:code_crack/repository/quiz_repository.dart';
import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  final List<String> tags;
  const Quiz({
    super.key, required this.tags,
  });

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  final repository = QuizRepository();
  int currentIndex = 0;
  bool showFeedback = false;
  List<dynamic> quizzes = [];
  bool? isCorrect;
  String explanation = "";
  int score = 0;

  @override
  void initState() {
    super.initState();
    repository.fetchQuizzesByTags(widget.tags).then((data) {
      setState(() {
        quizzes = data;
        quizzes.shuffle(Random()); // Shuffle the quizzes
      });
    }).catchError((error) {
      // Handle errors gracefully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    });
  }

  void _submitAnswer(bool correctAnswer, String explanation) {
    setState(() {
      if (correctAnswer) {
        score++;
      }
      isCorrect = correctAnswer;
      explanation = explanation;
      showFeedback = true;
    });
  }

  void _nextQuestion(List<dynamic> quizzes) {
    setState(() {
      currentIndex++;
      if (currentIndex >= quizzes.length) {
        currentIndex = 0; // Reset to the beginning or handle as needed
      }
      showFeedback = false;
      isCorrect = null;
      explanation = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _QuizAppBar(),
      body: quizzes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : showFeedback
          ? _feedbackCard(quizzes[currentIndex])
          : ListView(
        shrinkWrap: true,
        children: [
          _progressIndicator(),
          _questionCard(quizzes[currentIndex]['question']),
          const SizedBox(height: 16),
          quizzes[currentIndex]['type'] == "true_false"
              ? _trueOrFalseAnswer(quizzes[currentIndex])
              : quizzes[currentIndex]['type'] == "multiple_choice"
              ? _multipleChoiceAnswer(quizzes[currentIndex])
              : _textFieldAnswer(quizzes[currentIndex]),
        ],
      ),
    );
  }

  Widget _progressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Question ${currentIndex + 1}/${quizzes.length} - Score: $score/${quizzes.length}",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _feedbackCard(dynamic quiz) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            isCorrect == true ? Icons.check_circle : Icons.cancel,
            color: isCorrect == true ? Colors.green : Colors.red,
            size: 100,
          ),
          const SizedBox(height: 16),
          Text(
            isCorrect == true ? "Correct!" : "Wrong!",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              isCorrect == true ? quiz['feedback'] : "",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          isCorrect ?? false ?
          ElevatedButton(
            onPressed: () => _nextQuestion(quizzes),
            child:const Text("Next"),
          ):
            FilledButton(onPressed: (){
              setState(() {
                showFeedback = false;
              });
            }, child: const Text("Retry"))
        ],
      ),
    );
  }

  Widget _textFieldAnswer(dynamic quiz) {
    print(quiz);
    final TextEditingController answerField = TextEditingController();
    final choices = quiz["choices"];
    List<String> options = [];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: answerField,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 128,),
          FilledButton(
            onPressed: () {
              for (var i = 0; i<choices.length; i++){
                options.add(choices[i]['option'].toLowerCase().trim());
                print(choices[i]['option'].toLowerCase().trim());
              }
              print(answerField.text.toLowerCase().trim());
              if(options.contains(answerField.text.toLowerCase().trim())){
                print("tama");
                _submitAnswer(true, quiz['explanation'] ?? "No provided explanation.");
              } else {
                print("wrong");
                _submitAnswer(false, quiz['explanation'] ?? "No provided explanation.");
              }
            },
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

  Widget _trueOrFalseAnswer(dynamic quiz) {
    print(quiz["explanation"]);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
          height: 300,
          width: double.infinity,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 2,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final choice = quiz['choices'][index];
              final color = choice['option'].toLowerCase() == "true" ? Colors.pink : Colors.amber;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 140,
                    child: ElevatedButton(
                      onPressed: () {
                        if(choice['isCorrect']){
                          print("Tama");
                          _submitAnswer(true, quiz['explanation'] ?? "No provided explanation.");
                        } else {
                          print("Wrong");
                          _submitAnswer(false, quiz['explanation'] ?? "No provided explanation.");
                        }
                      },
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              // Change your radius here
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          backgroundColor: WidgetStateProperty.all(color)),
                      child: choice['option'].toLowerCase() == "true" ? const Text("True", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),) : const Text("False", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18)),
                    )),
              );
            },
          )),
    );
  }

  Widget _multipleChoiceAnswer(dynamic quiz) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final choice = quiz['choices'][index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: FilledButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  // Change your radius here
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            onPressed: () {
              if(choice['isCorrect']){
                print("Tama");
                _submitAnswer(true, quiz['explanation'] ?? "No provided explanation.");
              } else {
                print("Wrong");
                _submitAnswer(false, quiz['explanation'] ?? "No provided explanation.");
              }
            },
            child: SizedBox(
                height: 70,
                width: double.infinity,
                child: Center(
                    child: Text(
                  choice['option'],
                  style: const TextStyle(fontSize: 16),
                ))),
          ),
        );
      },
    );
  }

  Widget _questionCard(String question) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      elevation: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: SizedBox(
          width: double.infinity,
          height: 250,
          child: Stack(
            children: [
              Positioned(top: 0, bottom: 0, right: 16, left: 16, child: Center(child: Text(question, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700), textAlign: TextAlign.center))),
            ],
          ),
        ),
      ),
    );
  }
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
      // actions: [
      //   IconButton(
      //       onPressed: () {
      //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This is a snackbar')));
      //       },
      //       icon: const Icon(Icons.question_mark))
      // ],
    );
  }
}
