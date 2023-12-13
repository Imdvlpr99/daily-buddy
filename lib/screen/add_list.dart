
import 'package:daily_buddy/network/api_service.dart';
import 'package:daily_buddy/widget/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../model/category_model.dart';
import '../widget/custom_app_bar.dart';

/**
 * Created by Imdvlpr_
 */

class AddList extends StatefulWidget {
  const AddList({super.key});

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _categoryController = TextEditingController();
  late Future<List<CategoryModel>> categoryList;
  late String categoryId = '';

  @override
  void initState() {
    super.initState();
    categoryList = getCategoryList();
  }

  Future<List<CategoryModel>> getCategoryList() async {
    return ApiService.getCategoryList(onDataChanged: () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Activity",
        showBackButton: true,
        onBackButtonTap: () {
          Navigator.pop(context);
        },
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: categoryList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading categories'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No categories available'));
          } else {
            List<CategoryModel> categoryList = snapshot.data as List<CategoryModel>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    children: <Widget> [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomTextField(
                          controller: _titleController,
                          labelText: 'Title',
                          hintText: 'Set activity title',
                          keyboardType: TextInputType.text,
                          prefixIcon: const Icon(Iconsax.task_square),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomTextField(
                          controller: _dateController,
                          labelText: 'Date',
                          hintText: 'Set the activity date',
                          isReadOnly: true,
                          prefixIcon: const Icon(Iconsax.calendar_1),
                          onMenuActionTap: () {
                            _showDatePicker();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomTextField(
                          controller: _timeController,
                          labelText: 'Time',
                          hintText: 'Set the activity time',
                          isReadOnly: true,
                          prefixIcon: const Icon(Iconsax.clock),
                          onMenuActionTap: () {
                            _selectTime(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomTextField<CategoryModel>(
                          controller: _categoryController,
                          labelText: 'Category',
                          hintText: 'Set the activity category',
                          isReadOnly: true,
                          prefixIcon: const Icon(Iconsax.task_square),
                          dropdownItems: categoryList,
                          onDropdownChanged: (CategoryModel? newValue) {
                            setState(() {
                              _categoryController.text = (newValue?.categoryName ?? '');
                              categoryId = (newValue?.categoryId ?? '');
                            });
                          },
                          displayText: (CategoryModel category) => category.categoryName,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomTextField(
                          controller: _descController,
                          labelText: 'Description',
                          hintText: 'Set activity description',
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FilledButton(
                      onPressed: submitData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                        fixedSize: const Size(200, 50),
                        textStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: const Text('Save')),
                ),
              ],
            );
          }},
      ),
    );
  }

  void _showDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (selectedDate != null) {
      _dateController.text = DateFormat('EEEE, dd MMMM yyyy').format(selectedDate);
    }
  }

  TimeOfDay _selectedTime = TimeOfDay.now();
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = _formatTimeOfDay(_selectedTime);
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  void submitData() {
    final title = _titleController.text;
    final desc = _descController.text;
    final date = _dateController.text;
    final time = _timeController.text;

    DateTime inputDate = DateFormat('EEEE, dd MMMM yyyy').parse(date);
    String outputDate = DateFormat('yyyy-MM-dd').format(inputDate);
    DateTime inputTime = DateFormat('HH:mm').parse(time);
    String outputTime = DateFormat('HH:mm:ss').format(inputTime);

    ApiService.createActivity(title, desc, outputDate, outputTime, categoryId, onActivityCreated: () {
      _titleController.text = '';
      _dateController.text = '';
      _timeController.text = '';
      _descController.text = '';
    });
  }

}