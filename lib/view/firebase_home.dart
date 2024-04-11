import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:homework_must_eat_place_app/model/custom_dialog.dart';
import 'package:homework_must_eat_place_app/model/global_eatplace.dart';
import 'package:homework_must_eat_place_app/view/firebase_insert.dart';
import 'package:homework_must_eat_place_app/view/firebase_update.dart';
import 'package:homework_must_eat_place_app/view/gps_location.dart';

class FirebaseHome extends StatefulWidget {
  const FirebaseHome({super.key});

  @override
  State<FirebaseHome> createState() => _FirebaseHomeState();
}

class _FirebaseHomeState extends State<FirebaseHome> {
  // --- Widget Functions ----
  Widget _buildItemWidget(doc) {
    final eatPlace = GlobalEatPlace(
      name: doc['name'],
      phone: doc['phone'],
      lat: doc['lat'],
      lng: doc['lng'],
      image: doc['image'],
      estimate: doc['estimate'],
      initdate: doc['initdate'],
    );
    return GestureDetector(
      onTap: () {
        Get.to(
          () => const GPSLocation(),
          transition: Transition.zoom,
          arguments: [
            doc['lat'],
            doc['lng'],
          ],
        );
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
                  () => const FirebaseUpdate(),
                  transition: Transition.fade,
                  arguments: [
                    doc.id,
                    doc['name'],
                    doc['phone'],
                    doc['lat'],
                    doc['lng'],
                    doc['image'],
                    doc['estimate'],
                    doc['initdate'],
                  ],
                );
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
                FirebaseFirestore.instance
                    .collection('musteatplace')
                    .doc(doc.id)
                    .delete();
                CustomDialog.firebaseDeleteDialog(
                    '삭제 결과', '삭제가 완료 되었습니다.', context);
                await deleteImage(eatPlace.name);
              },
            ),
          ],
        ),
        child: Card(
          // color: index % 2 == 0
          //     ? Theme.of(context).colorScheme.secondaryContainer
          //     : Theme.of(context).colorScheme.tertiaryContainer,
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
                  child: Image.network(
                    eatPlace.image,
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
                            eatPlace.name,
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
                            eatPlace.phone,
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
    );
  }

  // ---------------------------------------------------------------------------

  // --- Functions ----
  deleteImage(deleteCode) async {
    final firebaseStorage =
        FirebaseStorage.instance.ref().child('images').child('$deleteCode.png');
    await firebaseStorage.delete();
  }

  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '전 세계 맛집 탐방',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => const FirebaseInsert(),
                transition: Transition.fadeIn,
              );
            },
            icon: const Icon(Icons.add_outlined),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('musteatplace')
              .orderBy('initdate', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final documents = snapshot.data!.docs;
            return ListView(
              children: documents.map((e) => _buildItemWidget(e)).toList(),
            );
          },
        ),
      ),
    );
  }
} // End
