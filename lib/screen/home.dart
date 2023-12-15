import 'package:daily_buddy/model/activity_model.dart';
import 'package:daily_buddy/screen/add_list.dart';
import 'package:daily_buddy/widget/custom_expandable_item.dart';
import 'package:daily_buddy/widget/empty_screen.dart';
import 'package:daily_buddy/widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconsax/iconsax.dart';
import '../api/api_service.dart';
import '../widget/custom_page_route.dart';
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
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
            Flexible(
              child: FutureBuilder<List>(
                future: activityList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    Utils.getLogger().e(snapshot.error);
                    return const Text('Error loading categories');
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
                      onRefresh: getActivityListToday,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // In progress Activity
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  const Text(
                                    'In Progress',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                                                onPressed: (BuildContext context) {},
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                icon: Iconsax.trash,
                                                label: 'Delete',
                                              ),
                                              SlidableAction(
                                                onPressed: (BuildContext context) {},
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
                                          child: CustomExpandableItem(
                                            item: incompleteActivities[index],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Completed Activities
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
                                                onPressed: (BuildContext context) {},
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                icon: Iconsax.trash,
                                                label: 'Delete',
                                              ),
                                              SlidableAction(
                                                onPressed: (BuildContext context) {},
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
                                                  const SizedBox(width: 15),
                                                  Text(item.title),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: navigateToAddList,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          child: const Icon(Iconsax.add4),
        ),
      ),
    );
  }

  void navigateToAddList() {
    final route = CustomPageRoute(
      child: const AddList(),
      direction: AxisDirection.left,
    );
    Navigator.push(context, route);
  }
}