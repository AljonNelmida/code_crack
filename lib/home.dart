import 'package:code_crack/login.dart';
import 'package:code_crack/quiz.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'learning.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _id;
  String? _username;
  String? _studentNumber;
  String? _email;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
          () {
        getUserInfo();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        title: const Text("Code Crack"),
        actions: [
          IconButton(
              onPressed: () async {
                print(_username);
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          welcomeCard(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              "Quiz Categories",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Programming"),
                      content: const Text("The art of writing instructions (code) for computers to perform specific tasks using programming languages like C++, Java, or Python."),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Learning(title: "Programming");
                                  },
                                ),
                              );
                            },
                            child: const Text("Learn")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Quiz(
                                      tags: ["Programming"],
                                    );
                                  },
                                ),
                              );
                            },
                            child: const Text("Quiz")),
                      ],
                    );
                  });
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              color: Colors.amber,
              child: SizedBox(
                height: 80,
                child: Center(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(64),
                      child: Container(
                          color: const Color(0x88FFFFFF),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.computer,
                              size: 24,
                            ),
                          )),
                    ),
                    title: const Text(
                      "Programming",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {

                    return AlertDialog(
                      title: const Text("Web Development"),
                      content: const Text("The creation and maintenance of websites or web applications, encompassing front-end design, back-end logic, and integration using technologies like HTML, CSS, JavaScript, and frameworks."),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Learning(title: "Web Development");
                                  },
                                ),
                              );
                            },
                            child: const Text("Learn")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Quiz(
                                      tags: ["Web Development"],
                                    );
                                  },
                                ),
                              );
                            },
                            child: const Text("Quiz")),
                      ],
                    );
                  });
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              color: Colors.lightGreenAccent,
              child: SizedBox(
                height: 80,
                child: Center(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(64),
                      child: Container(
                          color: const Color(0x88FFFFFF),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.web,
                              size: 24,
                            ),
                          )),
                    ),
                    title: const Text(
                      "Web Development",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Database"),
                      content: const Text("The structured organization, storage, and retrieval of data using systems like SQL, MongoDB, or PostgreSQL for efficient management and analysis."),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Learning(title: "Database");
                                  },
                                ),
                              );
                            },
                            child: const Text("Learn")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Quiz(
                                      tags: ["Database"],
                                    );
                                  },
                                ),
                              );
                            },
                            child: const Text("Quiz")),
                      ],
                    );
                  });
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              color: Colors.deepPurpleAccent,
              child: SizedBox(
                height: 80,
                child: Center(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(64),
                      child: Container(
                          color: const Color(0x88FFFFFF),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.storage,
                              size: 24,
                            ),
                          )),
                    ),
                    title: const Text(
                      "Database",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Networking"),
                      content: const Text("The practice of connecting computers and devices to share resources and information, involving concepts like protocols, IP addressing, and network security."),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Learning(title: "Networking");
                                  },
                                ),
                              );
                            },
                            child: const Text("Learn")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const Quiz(
                                      tags: ["Networking"],
                                    );
                                  },
                                ),
                              );
                            },
                            child: const Text("Quiz")),
                      ],
                    );
                  });
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              color: Colors.blue,
              child: SizedBox(
                height: 80,
                child: Center(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(64),
                      child: Container(
                          color: const Color(0x88FFFFFF),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.cable,
                              size: 24,
                            ),
                          )),
                    ),
                    title: const Text(
                      "Networking",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget welcomeCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 100,
        child: Center(
          child: ListTile(
            title: Text(
              _username ?? "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            leading: ClipRRect(borderRadius: BorderRadius.circular(64), child: Image.asset("assets/icon.png")),
            subtitle: const Text(
              "Welcome to Code Crack!",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }

  void getUserInfo() async {
    print("Retrieved username: $_username");
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _id = prefs.getString("id");
      _username = prefs.getString("username");
      _studentNumber = prefs.getString("studentNumber");
      _email = prefs.getString("email");
    });
    print("Retrieved username2: $_username");

  }
}
