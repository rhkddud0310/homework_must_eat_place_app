import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:homework_must_eat_place_app/model/custom_dialog.dart';
import 'package:homework_must_eat_place_app/view/gps_location.dart';
import 'package:homework_must_eat_place_app/view/sqlite_insert.dart';
import 'package:homework_must_eat_place_app/view/sqlite_update.dart';
import 'package:homework_must_eat_place_app/vm/database_handler.dart';

class SQLiteHome extends StatefulWidget {
  const SQLiteHome({super.key});

  @override
  State<SQLiteHome> createState() => _SQLiteHomeState();
}

class _SQLiteHomeState extends State<SQLiteHome> {
  // Property
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  // ---------------------------------------------------------------------------

  // --- Functions ----
  reloadData() {
    handler.queryEatPlace();
    setState(() {});
  }

  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '나만의 맛집 탐방',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => const SQLiteInsert(),
                transition: Transition.zoom,
              )!
                  .then((value) => reloadData());
            },
            icon: const Icon(Icons.add_outlined),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
      ),
      body: FutureBuilder(
        future: handler.queryEatPlace(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        () => const GPSLocation(),
                        transition: Transition.circularReveal,
                        arguments: [
                          snapshot.data![index].lat,
                          snapshot.data![index].lng,
                        ],
                      )!
                          .then((value) => reloadData());
                    },
                    child: Slidable(
                      startActionPane: ActionPane(
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.green,
                            icon: Icons.edit,
                            label: '수정',
                            onPressed: (context) {
                              Get.to(
                                () => const SQLiteUpdate(),
                                transition: Transition.fade,
                                arguments: [
                                  snapshot.data![index].seq,
                                  snapshot.data![index].name,
                                  snapshot.data![index].phone,
                                  snapshot.data![index].lat,
                                  snapshot.data![index].lng,
                                  snapshot.data![index].image,
                                  snapshot.data![index].estimate,
                                  snapshot.data![index].initdate
                                ],
                              )!
                                  .then((value) => reloadData());
                            },
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.red,
                            icon: Icons.delete_forever_outlined,
                            label: '삭제',
                            onPressed: (context) async {
                              int? seq = snapshot.data![index].seq;

                              await handler.deleteEatPlace(seq!);
                              CustomDialog.sqliteDeleteDialog(
                                  '삭제 결과', '삭제가 완료 되었습니다.', context);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      child: Card(
                        color: index % 2 == 0
                            ? Theme.of(context).colorScheme.secondaryContainer
                            : Theme.of(context).colorScheme.tertiaryContainer,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.blue.shade100,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  snapshot.data![index].image,
                                  fit: BoxFit.fill,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          '상호명 : ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data![index].name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          '연락처 : ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data![index].phone,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
} // End
