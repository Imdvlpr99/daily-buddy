import 'package:daily_buddy/widget/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../api/api_service.dart';
import '../model/category_model.dart';
import '../widget/custom_app_bar.dart';
import '../widget/custom_text_field.dart';

/**
 * Created by Imdvlpr_
 */

class Category extends StatefulWidget {
  const Category({super.key});
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final _categoryNameController = TextEditingController();
  late Future<List> categoryList;

  @override
  void initState() {
    super.initState();
    refreshCategoryList();
  }

  Future<void> refreshCategoryList() async {
    categoryList = ApiService.getCategoryList(onDataChanged: () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: "Category",
        ),
        body: FutureBuilder<List>(
          future: categoryList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Text('Error loading categories');
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const EmptyScreen();
            } else {
              List<CategoryModel> categoryList = snapshot.data as List<CategoryModel>;
              return RefreshIndicator(
                onRefresh: refreshCategoryList,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ListView.separated(
                    itemCount: categoryList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 10); // Adjust the height as needed.
                    },
                    itemBuilder: (context, index) {
                      final item = categoryList[index];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (BuildContext context) {
                                ApiService.deleteCategory(item.categoryId, onDeleteCategorySuccess: () {
                                  refreshCategoryList();
                                });
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Iconsax.trash,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (BuildContext context) {
                                _addCategoryBottomSheet(item.categoryId, item.categoryName);
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Iconsax.edit,
                              label: 'Edit',
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(15.0),
                                bottomRight: Radius.circular(15.0),
                              ),
                            )
                          ],
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    Iconsax.stickynote,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(item.categoryName),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                )
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _addCategoryBottomSheet('', '');
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add,))
    );
  }

  void _addCategoryBottomSheet(String categoryId, String categoryName) {
    String buttonText = '';
    if(categoryName != '') {
      _categoryNameController.text = categoryName;
      buttonText = 'Update';
    } else {
      _categoryNameController.text = '';
      buttonText = 'Save';
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom + 300,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
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
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: CustomTextField(
                                controller: _categoryNameController,
                                labelText: 'Category Name',
                                hintText: 'Set category name',
                                keyboardType: TextInputType.text,
                                prefixIcon: const Icon(Iconsax.task_square),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: FilledButton(
                          onPressed: _categoryNameController.text.isEmpty
                              ? null
                              : () {
                            if (categoryName != '') {
                              ApiService.editCategory(categoryId, _categoryNameController.text, onSuccessEditCategory: () {
                                refreshCategoryList();
                                Navigator.pop(context);
                              });
                            } else {
                              ApiService.createCategory(_categoryNameController.text, onCategoryCreated: () {
                                refreshCategoryList();
                                Navigator.pop(context);
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
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
                          child: Text(buttonText),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _categoryNameController.clear();
    });
  }
}