import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '機車保養紀錄',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const MaintenanceListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MaintenanceRecord {
  final String date;
  final int mileage;
  final String item;
  final String remark;

  MaintenanceRecord({
    required this.date,
    required this.mileage,
    required this.item,
    required this.remark,
  });
}

class MaintenanceListPage extends StatefulWidget {
  const MaintenanceListPage({super.key});

  @override
  State<MaintenanceListPage> createState() => _MaintenanceListPageState();
}

class _MaintenanceListPageState extends State<MaintenanceListPage> {
  final List<MaintenanceRecord> _records = [];

  void _addNewRecord() async {
    final result = await showDialog<Map<String,dynamic>>(
      context: context,
      builder: (context) {
        final dateCtrl = TextEditingController();
        final mileCtrl = TextEditingController();
        final itemCtrl = TextEditingController();
        final noteCtrl = TextEditingController();
        return AlertDialog(
          title: const Text("新增保養紀錄"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: "保養日期")),
                TextField(controller: mileCtrl, decoration: const InputDecoration(labelText: "當時里程(km)"), keyboardType: TextInputType.number),
                TextField(controller: itemCtrl, decoration: const InputDecoration(labelText: "保養項目：換機油/濾芯/輪胎等")),
                TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: "備註")),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("取消")),
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context,{
                  "date":dateCtrl.text,
                  "mile":int.tryParse(mileCtrl.text)??0,
                  "item":itemCtrl.text,
                  "remark":noteCtrl.text
                });
              },
              child: const Text("儲存"),
            )
          ],
        );
      },
    );
    if(result!=null){
      setState(() {
        _records.add(MaintenanceRecord(
          date: result["date"],
          mileage: result["mile"],
          item: result["item"],
          remark: result["remark"],
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🏍️ 機車保養紀錄本")),
      floatingActionButton: FloatingActionButton(onPressed:_addNewRecord,child: const Icon(Icons.add)),
      body: _records.isEmpty
          ? const Center(child:Text("尚無保養紀錄\n點右下角 + 新增第一筆",textAlign: TextAlign.center,style: TextStyle(fontSize:16)))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _records.length,
        itemBuilder: (ctx,i){
          final r = _records[i];
          return Card(
            margin: const EdgeInsets.symmetric(vertical:6),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.date,style: const TextStyle(fontWeight: FontWeight.bold,fontSize:17)),
                  const SizedBox(height:4),
                  Text("里程：${r.mileage} km"),
                  const SizedBox(height:2),
                  Text("保養：${r.item}"),
                  const SizedBox(height:2),
                  Text("備註：${r.remark}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
