import 'package:daily_buddy/model/activity_model.dart';
import 'package:daily_buddy/widget/bottom_sheet_component.dart';
import 'package:daily_buddy/widget/custom_expandable_item.dart';
import 'package:daily_buddy/widget/empty_screen.dart';
import 'package:daily_buddy/widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconsax/iconsax.dart';
import '../api/api_service.dart';
import '../widget/src/calendar_timeline.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DateTime _selectedDate;
  late Future<List<ActivityModel>> activityList;
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    getActivityListToday();
  }

  Future<void> getActivityList(String selectedDate) async {
    activityList = ApiService.getActivityListByDate(selectedDate, onSuccessGetList: () {
      setState(() {});
    });
  }

  Future<void> getActivityListToday() async {
    _selectedDate = DateTime.now();
    formattedDate = Utils.formatDateTime(_selectedDate, 'yyyy-MM-dd');
    await getActivityList(formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CalendarTimeline(
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 10)),
                    lastDate: DateTime.now().add(const Duration(days: 155)),
                    onDateSelected: (date) async {
                      setState(() => _selectedDate = date);
                      formattedDate = Utils.formatDateTime(_selectedDate, 'yyyy-MM-dd');
                      await getActivityList(formattedDate);
                    },
                    leftMargin: 20,
                    monthColor: Colors.blue,
                    dayColor: Colors.white,
                    dayNameColor: Colors.white,
                    activeDayColor: Colors.blue,
                    activeBackgroundDayColor: Colors.white,
                    locale: 'id',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  child: FutureBuilder<List>(
                    future: activityList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        Utils.getLogger().e(snapshot.error);
                        return const Center(child: Text('Error loading categories'));
                      } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return const EmptyScreen();
                      } else {
                        List<ActivityModel> activityListResult = snapshot.data as List<ActivityModel>;
                        List<ActivityModel> completedActivities = [];
                        List<ActivityModel> incompleteActivities = [];

                        for (var activity in activityListResult) {
                          if (activity.isComplete == 'true') {
                            completedActivities.add(activity);
                          } else {
                            incompleteActivities.add(activity);
                          }
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            await getActivityList(Utils.formatDateTime(_selectedDate, 'yyyy-MM-dd'));
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // In progress Activity
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      if (incompleteActivities.isNotEmpty)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'In Progress Activities',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              margin: const EdgeInsets.only(top: 10),
                                              child: ListView.separated(
                                                padding: EdgeInsets.zero,
                                                itemCount: incompleteActivities.length,
                                                separatorBuilder: (BuildContext context, int index) {
                                                  return const SizedBox(height: 10);
                                                },
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  final item = incompleteActivities[index];
                                                  return Slidable(
                                                    endActionPane: ActionPane(
                                                      motion: const ScrollMotion(),
                                                      children: [
                                                        SlidableAction(
                                                          onPressed: (BuildContext context) {
                                                            ApiService.deleteActivity(item.id, onSuccessDelete: () {
                                                              getActivityList(Utils.formatDateTime(_selectedDate, 'yyyy-MM-dd'));
                                                            });
                                                          },
                                                          backgroundColor: Colors.red,
                                                          foregroundColor: Colors.white,
                                                          icon: Iconsax.trash,
                                                          label: 'Delete',
                                                        ),
                                                        SlidableAction(
                                                          onPressed: (BuildContext context) {
                                                            ActivityModel activityModel = ActivityModel(
                                                              item.id,
                                                              item.title,
                                                              item.desc,
                                                              item.date,
                                                              item.time,
                                                              item.categoryId,
                                                              item.isComplete,
                                                            );

                                                            BottomSheetComponent.showActivityBottomSheet(
                                                              context: context,
                                                              activityModel: activityModel,
                                                              onComplete: () {
                                                                setState(() {
                                                                  getActivityList(Utils.formatDateTime(_selectedDate, 'yyyy-MM-dd'));
                                                                });
                                                              },
                                                            );
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
                                                    startActionPane: ActionPane(
                                                      motion: const ScrollMotion(),
                                                      children: [
                                                        SlidableAction(
                                                          onPressed: (BuildContext context) {
                                                            ActivityModel activityModel = ActivityModel(item.id, '', '', '', '', '', 'true');
                                                            ApiService.updateActivity(activityModel, onSuccessUpdateActivity: () {
                                                              getActivityList(Utils.formatDateTime(_selectedDate, 'yyyy-MM-dd'));
                                                            });
                                                          },
                                                          backgroundColor: Colors.green,
                                                          foregroundColor: Colors.white,
                                                          icon: Iconsax.tick_circle,
                                                          label: 'Complete',
                                                          borderRadius: const BorderRadius.only(
                                                            topLeft: Radius.circular(15.0),
                                                            bottomLeft: Radius.circular(15.0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: CustomExpandableItem(
                                                      item: incompleteActivities[index],
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  // Completed Activities
                                  if (completedActivities.isNotEmpty)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Completed Activities',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          margin: const EdgeInsets.only(top: 10),
                                          child: ListView.separated(
                                            padding: EdgeInsets.zero,
                                            itemCount: completedActivities.length,
                                            separatorBuilder: (BuildContext context, int index) {
                                              return const SizedBox(height: 10);
                                            },
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              final item = completedActivities[index];
                                              return Slidable(
                                                endActionPane: ActionPane(
                                                  motion: const ScrollMotion(),
                                                  children: [
                                                    SlidableAction(
                                                      onPressed: (BuildContext context) {
                                                        ApiService.deleteActivity(item.id, onSuccessDelete: () {
                                                          getActivityList(Utils.formatDateTime(_selectedDate, 'yyyy-MM-dd'));
                                                        });
                                                      },
                                                      backgroundColor: Colors.red,
                                                      foregroundColor: Colors.white,
                                                      icon: Iconsax.trash,
                                                      label: 'Delete',
                                                      borderRadius: const BorderRadius.only(
                                                        topRight: Radius.circular(15.0),
                                                        bottomRight: Radius.circular(15.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: CustomExpandableItem(
                                                  item: completedActivities[index],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BottomSheetComponent.showActivityBottomSheet(
                context: context);
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          child: const Icon(Iconsax.add4),
        ),
      ),
    );
  }

}