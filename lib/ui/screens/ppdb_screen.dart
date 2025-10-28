import 'package:flutter/material.dart';

class PpdbScreen extends StatelessWidget {
	const PpdbScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('PPDB')),
			body: const Center(child: Text('PPDB Screen')),
		);
	}
}

