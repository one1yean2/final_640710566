import 'dart:convert';

import 'package:final_640710566/helpers/my_list_tile.dart';
import 'package:final_640710566/helpers/my_text_field.dart';
import 'package:final_640710566/models/web_types.dart';
import 'package:flutter/material.dart';

import '../helpers/api_caller.dart';
import '../helpers/dialog_utils.dart';

class FonduePage extends StatefulWidget {
  const FonduePage({super.key});

  @override
  State<FonduePage> createState() => FonduePageState();
}

class FonduePageState extends State<FonduePage> {
  TextEditingController _urlTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();
  List<WebType> _webTypeItems = [];
  int selectedIndex = -1;
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadWebTypes();
  }

  Future<void> _loadWebTypes() async {
    try {
      final data = await ApiCaller().get("web_types");

      List list = jsonDecode(data);
      setState(() {
        _webTypeItems = list.map((e) => WebType.fromJson(e)).toList();
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Webby Fondue'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(100, 30, 100, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Text('* ต้องกรอกข้อมูล')),
            const SizedBox(height: 16),
            MyTextField(controller: _urlTextController, hintText: 'URL *'),
            const SizedBox(height: 16),
            MyTextField(controller: _descriptionTextController, hintText: 'รายละเอียด'),
            const SizedBox(height: 20),
            Text('ระบุประเภทเว็บเลว *', style: TextStyle(fontSize: 17)),
            Expanded(
              child: ListView.builder(
                itemCount: _webTypeItems.length,
                itemBuilder: (context, index) {
                  final item = _webTypeItems[index];
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: MyListTile(
                      title: item.title,
                      subtitle: item.subtitle,
                      imageUrl: ApiCaller.host + item.image,
                      selectedIndex: selectedIndex,
                      onSelect: (int selected) {
                        setState(() {
                          selectedIndex = selected;
                        });
                        // print(selectedIndex);
                      },
                      index: index,
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _handleApiPost,
              child: const Text('ส่งข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleApiPost() async {
    try {
      final data = await ApiCaller().post(
        "report_web",
        params: {
          "url": _urlTextController.text,
          "description": _descriptionTextController.text,
          "type": _webTypeItems[selectedIndex].id,
        },
      );
      Map map = jsonDecode(data);
      var summary = map['summary'];
      String text = 'ขอบคุณสำหรับการแจ้งข้อมูล รหัสข้อมูลของคุณคือ ' + map['insertItem']['id'].toString();
      for (int i = 0; i < 4; i++) {
        text += '\n' + summary[i]['title'] + ' : ' + summary[i]['count'].toString();
      }

      showOkDialog(context: context, title: "Success", message: text);
    } catch (e) {
      showOkDialog(context: context, title: "Error", message: 'ต้องกรอก URL และเลือกประเภทเว็บ');
    }
  }
}
