import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_supabase_crud/app/models/employee_model.dart';
import 'package:flutter_getx_supabase_crud/supabase_const.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/snackbars.dart';

class HomeController extends GetxController {
  RxList employeeList = <Employee>[].obs;

  var nameC = TextEditingController();
  var roleC = TextEditingController();
  var imageUrlC = TextEditingController();

  Future<void> fetchAllEmployees() async {
    try {
      final data = await supabase.from('employees').select('*');
      employeeList.clear();
      for (var employee in (data as List)) {
        employeeList.add(Employee(
            id: employee['id'],
            name: employee['name'],
            role: employee['role'],
            imageUrl: employee['image_url']));
      }
      update();
    } on PostgrestException catch (error) {
      messageWithError(error);
    } catch (_) {
      unexpectedError();
    }
  }

  Future<void> editEmployee(String id) async {
    try {
      await supabase.from('employees').update({
        'name': nameC.text,
        'role': roleC.text,
        'image_url': imageUrlC.text
      }).match({'id': id});
      await fetchAllEmployees();
      Get.back();
    } on PostgrestException catch (error) {
      messageWithError(error);
    } catch (_) {
      unexpectedError();
    }
  }

  Future<void> addEmployee() async {
    try {
      await supabase.from('employees').insert({
        'name': nameC.text,
        'role': roleC.text,
        'image_url': imageUrlC.text
      });
      clearTextControllers();
      await fetchAllEmployees();
      Get.back();
    } on PostgrestException catch (error) {
      messageWithError(error);
    } catch (_) {
      unexpectedError();
    }
  }

  Future<void> deleteEmployee(String id) async {
    Get.defaultDialog(
      radius: 8,
      title: 'Warning',
      middleText: 'Do you want to delete?',
      actions: [
        ElevatedButton(
          onPressed: () async {
            Get.back();
            await supabase.from('employees').delete().match({'id': id});
            await fetchAllEmployees();
          },
          child: const Text('Yes'),
        ),
        ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text('No'),
        ),
      ],
    );
  }

  clearTextControllers() {
    nameC.clear();
    roleC.clear();
    imageUrlC.clear();
  }

  @override
  void onInit() {
    fetchAllEmployees();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
