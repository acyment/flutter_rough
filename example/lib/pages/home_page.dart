import 'package:flutter/material.dart';

import '../demos.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Rough example')),
      body: const DemoList(),
    );
  }
}

class DemoList extends StatelessWidget {
  const DemoList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, position) => Container(
        color: Theme.of(context).cardColor,
        child: const Divider(
          indent: 64,
          thickness: 1,
          height: 4,
        ),
      ),
      itemCount: demos.length,
      itemBuilder: (context, position) => DemoRow(demo: demos[position]),
    );
  }
}

class DemoRow extends StatelessWidget {
  const DemoRow({super.key, required this.demo});
  final Demo demo;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        title: Text(demo.name),
        dense: false,
        subtitle: Text(demo.description),
        leading: SizedBox(
          width: 42,
          height: 42,
          child: demo.icon,
        ),
        onTap: () => Navigator.push<MaterialPageRoute>(
          context,
          MaterialPageRoute(
            builder: demo.buildPage,
          ),
        ),
      ),
    );
  }
}
