import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework_must_eat_place_app/model/custom_dialog.dart';
import 'package:homework_must_eat_place_app/model/eatplace.dart';
import 'package:homework_must_eat_place_app/vm/database_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';

class SQLiteUpdate extends StatefulWidget {
  const SQLiteUpdate({super.key});

  @override
  State<SQLiteUpdate> createState() => _SQLiteUpdateState();
}

class _SQLiteUpdateState extends State<SQLiteUpdate> {
  // Property
  late DatabaseHandler handler;

  late String name;
  late String phone;
  late String lat;
  late String lng;
  late String estimate;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController latController;
  late TextEditingController lngController;
  late TextEditingController estimateController;

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  var value = Get.arguments ?? '___';

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();

    nameController = TextEditingController();
    phoneController = TextEditingController();
    latController = TextEditingController();
    lngController = TextEditingController();
    estimateController = TextEditingController();

    nameController.text = value[1];
    phoneController.text = value[2];
    latController.text = value[3];
    lngController.text = value[4];
    estimateController.text = value[6];

    name = '';
    phone = '';
    lat = '';
    lng = '';
    estimate = '';
  }

  // ---------------------------------------------------------------------------

  // --- Functions ----

  _getImageFromGallery(imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) {
      return;
    } else {
      imageFile = XFile(pickedFile.path);
      setState(() {});
    }
  }

  // ---------------------------------------------------------------------------

  _updateAction(context) async {
    name = nameController.text.toString();
    phone = phoneController.text.toString();
    lat = latController.text.toString();
    lng = lngController.text.toString();
    estimate = estimateController.text.toString();

    var eatPlace = EatPlace(
        seq: value[0],
        name: name,
        phone: phone,
        lat: lat,
        lng: lng,
        image: value[5],
        estimate: estimate,
        initdate: value[7]);
    await handler.updateEatPlace(eatPlace);

    if (!mounted) return;

    CustomDialog.sqliteInsertDialog('수정 결과', '수정이 완료 되었습니다.', context);
  }

  // ---------------------------------------------------------------------------

  _updateActionAll(context) async {
    name = nameController.text.toString();
    phone = phoneController.text.toString();
    lat = latController.text.toString();
    lng = lngController.text.toString();
    estimate = estimateController.text.toString();

    // File Type을 Byte Type으로 변환하기.
    File imageFile1 = File(imageFile!.path);
    Uint8List getImage = await imageFile1.readAsBytesSync();

    var eatPlace = EatPlace(
        seq: value[0],
        name: name,
        phone: phone,
        lat: lat,
        lng: lng,
        image: getImage,
        estimate: estimate,
        initdate: value[7]);
    await handler.updateEatPlace(eatPlace);

    if (!mounted) return;

    CustomDialog.sqliteInsertDialog('수정 결과', '수정이 완료 되었습니다.', context);
  }

  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '맛집 수정 by. SQLite',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: ElevatedButton(
                    onPressed: () => _getImageFromGallery(ImageSource.gallery),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      foregroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '이미지 가져오기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    color: Colors.yellow.shade100,
                    child: Center(
                      child: imageFile == null
                          ? Image.memory(value[5])
                          : Image.file(
                              File(imageFile!.path),
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                ),

                // -----------------------------------------------------------------

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                '위도',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 170,
                              child: TextField(
                                maxLength: 20,
                                controller: latController,
                                decoration: InputDecoration(
                                  counterText: '', // 화면에 표시되는 maxLength 제거.
                                  labelText: '위도를 입력 하세요.',
                                  hintText: '위도를 입력 하세요.',
                                  hintFadeDuration:
                                      const Duration(milliseconds: 500),
                                  floatingLabelAlignment:
                                      FloatingLabelAlignment.center,
                                  floatingLabelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    fontSize: 15,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(20.0),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                '경도',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 170,
                              child: TextField(
                                maxLength: 20,
                                controller: lngController,
                                decoration: InputDecoration(
                                  counterText: '', // 화면에 표시되는 maxLength 제거.
                                  labelText: '경도를 입력 하세요.',
                                  hintText: '경도를 입력 하세요.',
                                  hintFadeDuration:
                                      const Duration(milliseconds: 500),
                                  floatingLabelAlignment:
                                      FloatingLabelAlignment.center,
                                  floatingLabelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    fontSize: 15,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(20.0),
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: TextField(
                    maxLength: 30,
                    controller: nameController,
                    decoration: InputDecoration(
                      counterText: '', // 화면에 표시되는 maxLength 제거.
                      labelText: '수정하고자 하는 상호명을 입력 하세요.',
                      hintText: '상호명을 입력해주시기 바랍니다.',
                      hintFadeDuration: const Duration(milliseconds: 500),
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      floatingLabelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSecondary,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(20.0),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: SizedBox(
                    child: TextField(
                      maxLength: 14,
                      controller: phoneController,
                      decoration: InputDecoration(
                        counterText: '', // 화면에 표시되는 maxLength 제거.
                        labelText: '수정하고자 하는 연락처를 입력 하세요.',
                        hintText: '연락처를 입력해주시기 바랍니다.',
                        hintFadeDuration: const Duration(milliseconds: 500),
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        floatingLabelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSecondary,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(20.0),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MultiMaskedTextInputFormatter(
                          masks: [
                            'xx-xxx-xxxx',
                            'xxx-xxx-xxxx',
                            'xxx-xxxx-xxxx'
                          ],
                          separator: '-',
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SizedBox(
                    height: 150,
                    child: Flexible(
                      child: TextField(
                        maxLength: 50,
                        minLines: 5,
                        maxLines: null,
                        controller: estimateController,
                        decoration: InputDecoration(
                          labelText: '수정하고자 하는 평가 및 후기를 입력 하세요.',
                          hintText: '평가 및 후기를 입력해주시기 바랍니다.',
                          hintFadeDuration: const Duration(milliseconds: 500),
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          floatingLabelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onSecondary,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(20.0),
                          // isCollapsed: true,
                        ),
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ),
                ),

                // -----------------------------------------------------------------

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    onPressed: () => imageFile == null
                        ? _updateAction(context)
                        : _updateActionAll(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      foregroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '수정',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} // End
