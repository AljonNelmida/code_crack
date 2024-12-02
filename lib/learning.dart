import 'package:code_crack/repository/quiz_repository.dart';
import 'package:flutter/material.dart';

class Learning extends StatefulWidget {
  final String title;
  const Learning({super.key, required this.title});

  @override
  State<Learning> createState() => _LearningState();
}

class _LearningState extends State<Learning> {
  final quizRepository = QuizRepository();
  late Future<List<dynamic>> quizzesFuture;

  @override
  void initState() {
    super.initState();
    quizzesFuture = quizRepository.fetchQuizzesByTags([widget.title]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: quizzesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No quizzes available'),
            );
          } else {
            final quizzes = snapshot.data!;
            return ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizzes[index];

                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                      title: Text(quiz['explanation'] ?? 'No Explanation', style: const TextStyle(), textAlign: TextAlign.justify,),
                    ),
                    const Divider()
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
