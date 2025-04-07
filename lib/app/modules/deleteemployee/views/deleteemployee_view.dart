import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/deleteemployee_controller.dart';

class DeleteemployeeView extends GetView<DeleteemployeeController> {
  const DeleteemployeeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeleteemployeeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DeleteemployeeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
