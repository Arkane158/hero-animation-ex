import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 44, 43, 46)),
          useMaterial3: true,
        ),
        routes: {
          MyHomePage.title: (context) => const MyHomePage(),
          PersonScreen.screenName: (context) => const PersonScreen()
        },
        initialRoute: MyHomePage.title);
  }
}

@immutable
class Person {
  final String name;
  final int age;
  final String emoji;
  const Person({required this.age, required this.emoji, required this.name});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });
  static const String title = 'Home ';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Person> people = [
    const Person(name: 'John', age: 20, emoji: '🧓'),
    const Person(name: 'Kevin', age: 21, emoji: '🧑‍⚖'),
    const Person(name: 'Bastian', age: 22, emoji: '💁🏼‍♂'),
    const Person(name: 'Mohamed', age: 23, emoji: '👲🏾'),
    const Person(name: 'Steven', age: 24, emoji: '🧑🏻')
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          final person = people[index];
          return ListTile(
            onTap: () {
              Navigator.pushNamed(context, PersonScreen.screenName,
                  arguments: person);
            },
            leading: Hero(
              tag: person.name,
              child: Text(
                person.emoji,
                style: const TextStyle(fontSize: 30),
              ),
            ),
            title: Text(person.name, style: const TextStyle(fontSize: 15)),
            subtitle: Text(person.age.toString(),
                style: const TextStyle(fontSize: 15)),
            trailing: const Icon(Icons.arrow_forward_ios),
          );
        },
      ),
    );
  }
}

class PersonScreen extends StatelessWidget {
  static const String screenName = "person-screen";
  const PersonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Person person = ModalRoute.of(context)?.settings.arguments as Person;
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: person.name,
          flightShuttleBuilder: (flightContext, animation, flightDirection,
              fromHeroContext, toHeroContext) {
            switch (flightDirection) {
              case HeroFlightDirection.push:
                return Material(
                    color: Colors.transparent,
                    child: ScaleTransition(
                        scale: animation.drive(Tween<double>(begin: 0, end: 1)
                            .chain(CurveTween(
                                curve: Curves.fastLinearToSlowEaseIn))),
                        child: toHeroContext.widget));
              case HeroFlightDirection.pop:
                return Material(
                    color: Colors.transparent,
                    child: ScaleTransition(
                        scale: animation.drive(Tween<double>(begin: 0, end: 1)
                            .chain(CurveTween(
                                curve: Curves.fastEaseInToSlowEaseOut))),
                        child: fromHeroContext.widget));
            }
          },
          child: Text(
            person.emoji,
            style: const TextStyle(fontSize: 35),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text(person.name, style: const TextStyle(fontSize: 25)),
            const SizedBox(
              height: 15,
            ),
            Text(person.age.toString(), style: const TextStyle(fontSize: 25)),
          ],
        ),
      ),
    );
  }
}
