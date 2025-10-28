import 'package:flutter/material.dart';

class SisdaScreen extends StatelessWidget {
	const SisdaScreen({Key? key}) : super(key: key);

		@override
		Widget build(BuildContext context) {
			return Scaffold(
				appBar: AppBar(title: const Text('Sisda')),
				body: const Center(child: Text('Sisda Screen')),
			);
		}
}

