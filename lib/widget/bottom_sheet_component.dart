import 'dart:math';

import 'package:daily_buddy/model/activity_model.dart';
import 'package:daily_buddy/widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../api/api_service.dart';
import '../model/category_model.dart';
import 'custom_text_field.dart';

class BottomSheetComponent {
  static void showActivityBottomSheet({
    required BuildContext context,
    ActivityModel? activityModel,
    Function()? onComplete
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          //minChildSize: 0.2,
          maxChildSize: 0.8,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return _ActivityBottomSheetContent(
              activityModel: activityModel,
              scrollController: scrollController,
            );
          },
        );
      },
    ).whenComplete(() {
      if (onComplete != null) {
        onComplete();
      }
    });
  }
}

class _ActivityBottomSheetContent extends StatefulWidget {
  final ActivityModel? activityModel;
  final ScrollController scrollController;

  const _ActivityBottomSheetContent({
    Key? key,
    this.activityModel,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<_ActivityBottomSheetContent> createState() => _ActivityBottomSheetContentState();
}

class _ActivityBottomSheetContentState extends State<_ActivityBottomSheetContent> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _categoryController = TextEditingController();
  late Future<List<CategoryModel>> categoryList;
  late String categoryId = '';
  String buttonText = '';
  double maxHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<List<CategoryModel>> getCategoryList() async {
    return ApiService.getCategoryList(onDataChanged: () {
      setState(() {});
    });
  }

  Future<void> _initializeData() async {
    categoryList = getCategoryList();
    if (widget.activityModel != null) {
      final categories = await categoryList;
      final matchingCategory = categories.firstWhere(
            (category) =>
        category.categoryId == widget.activityModel!.categoryId,
        orElse: () => CategoryModel('', ''),
      );

      _titleController.text = widget.activityModel!.title;
      _descController.text = widget.activityModel!.desc;
      _dateController.text = Utils.formatDateString(widget.activityModel!.date, 'EEE, dd MMMM yyyy');
      _timeController.text = Utils.formatTimeString(widget.activityModel!.time, 'HH:mm:ss', 'HH:mm');
      _categoryController.text = matchingCategory.categoryName;
      categoryId = widget.activityModel!.categoryId;
      buttonText = 'Update';
    }
    buttonText = 'Save';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: SizedBox(
        height: maxHeight = MediaQuery.of(context).size.height * 0.8,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: FutureBuilder<List<CategoryModel>>(
            future: categoryList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading categories'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No categories available'));
              } else {
                List<CategoryModel> categoryList =
                snapshot.data as List<CategoryModel>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              height: 5,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                            child: CustomTextField(
                              controller: _titleController,
                              labelText: 'Title',
                              hintText: 'Set activity title',
                              keyboardType: TextInputType.text,
                              prefixIcon:
                              const Icon(Iconsax.task_square),
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                            child: CustomTextField(
                              controller: _dateController,
                              labelText: 'Date',
                              hintText: 'Set the activity date',
                              isReadOnly: true,
                              prefixIcon:
                              const Icon(Iconsax.calendar_1),
                              onMenuActionTap: () {
                                _showDatePicker();
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                            child: CustomTextField(
                              controller: _timeController,
                              labelText: 'Time',
                              hintText: 'Set the activity time',
                              isReadOnly: true,
                              prefixIcon:
                              const Icon(Iconsax.clock),
                              onMenuActionTap: () {
                                _selectTime(context);
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                            child: CustomTextField<CategoryModel>(
                              controller: _categoryController,
                              labelText: 'Category',
                              hintText: 'Set the activity category',
                              isReadOnly: true,
                              prefixIcon:
                              const Icon(Iconsax.task_square),
                              dropdownItems: categoryList,
                              onDropdownChanged:
                                  (CategoryModel? newValue) {
                                setState(() {
                                  _categoryController.text =
                                  (newValue?.categoryName ?? '');
                                  categoryId =
                                  (newValue?.categoryId ?? '');
                                });
                              },
                              displayText: (CategoryModel category) =>
                              category.categoryName,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                            child: CustomTextField(
                              controller: _descController,
                              labelText: 'Description',
                              hintText: 'Set activity description',
                              keyboardType:
                              TextInputType.multiline,
                              maxLines: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FilledButton(
                        onPressed: () {
                          if (widget.activityModel == null) {
                            submitData();
                          } else {
                            editData();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Set the background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: const Size(200, 50), // Use minimumSize instead of fixedSize
                          textStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white, // Set the text color
                            ),
                          ),
                        ),
                        child: Text(buttonText),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
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
      _dateController.text = DateFormat('EEE, dd MMMM yyyy').format(selectedDate);
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

    DateTime inputDate = DateFormat('EEE, dd MMMM yyyy').parse(date);
    String outputDate = DateFormat('yyyy-MM-dd').format(inputDate);
    DateTime inputTime = DateFormat('HH:mm').parse(time);
    String outputTime = DateFormat('HH:mm:ss').format(inputTime);

    ApiService.createActivity(title, desc, outputDate, outputTime, categoryId,
        onActivityCreated: () {
          _titleController.text = '';
          _dateController.text = '';
          _timeController.text = '';
          _descController.text = '';
          Navigator.pop(context);
        });
  }

  void editData() {
    final title = _titleController.text;
    final desc = _descController.text;
    final date = _dateController.text;
    final time = _timeController.text;

    DateTime inputDate = DateFormat('EEE, dd MMMM yyyy').parse(date);
    String outputDate = DateFormat('yyyy-MM-dd').format(inputDate);
    DateTime inputTime = DateFormat('HH:mm').parse(time);
    String outputTime = DateFormat('HH:mm:ss').format(inputTime);

    ActivityModel activityModel = ActivityModel(
        widget.activityModel!.id,
        title,
        desc,
        outputDate,
        outputTime,
        categoryId,
        widget.activityModel!.isComplete);

    ApiService.editActivity(activityModel, onSuccessEditActivity: () {
      _titleController.text = '';
      _dateController.text = '';
      _timeController.text = '';
      _descController.text = '';
      Navigator.pop(context);
    });
  }
}