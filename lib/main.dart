import 'package:flutter/material.dart';
import 'package:lab1/model/User.dart';
import 'package:lab1/validate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          title: const Text("Danh sách khách hàng"),
        ),
        body: viewList(),
      )),
      debugShowCheckedModeBanner: false,
    );
  }
}

class viewList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return listView();
  }
}
class listView extends State<viewList> {
  List<User> list = [];
  int id = 1;
  void remove(int id) {
    setState(() {
      list.removeWhere((user) => user.id == id);
    });
    Navigator.of(context).pop();
  }
  void _showDialog({User? itemEdit}) {
    showDialog(
        context: context,
        builder: (context) {
          return show(
            onAdd: (User item){
              setState(() {
                if(itemEdit==null){
                  item.id =id++;
                  list.add(item);
                }else{
                  final index =list.indexWhere((element) => element.id == itemEdit.id);
                  if(index != -1){
                    list[index]=item;
                  }
                }
              });
            },
            isEditing: itemEdit !=null,
            initialItem: itemEdit,
          );
        });
  }

  void _diadelete(BuildContext context, User user) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text(
                "Thông báo",
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.left,
              ),
              content: Text(
                "Bạn có chắc chắn muốn xóa ${user.name} không ?",
                style: const TextStyle(fontSize: 18),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Hủy"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 30),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        remove(user.id);
                      },
                      child: const Text("Xác nhận"),
                    )
                  ],
                ),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        child: Stack(
          children: [
            ListView.builder(
              itemBuilder: (context, index) {
                final item = list[index];
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side:
                          const BorderSide(width: 1, color: Color(0xFFC9C9C9))),
                  child: ListTile(
                    onTap: () {
                      _showDialog(itemEdit: item);
                    },
                    title: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text(
                            item.id.toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const Text(
                          "Tên khách hàng :",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 120,
                          child: Text(
                            item.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        InkWell(
                          onTap: ()=>_diadelete(context, item),
                          child: const Icon(Icons.delete),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: list.length,
            ),
            Positioned(
                bottom: 15,
                right: 15,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    _showDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add"),
                )),
          ],
        ));
  }
}
class show extends StatefulWidget {
  final Function(User) onAdd;
  final User? initialItem;
  final bool isEditing;
  const show({super.key, required this.onAdd, this.initialItem,required this.isEditing});
  @override
  showDialogAddandUpdate createState() => showDialogAddandUpdate();
}

class showDialogAddandUpdate extends State<show> {
  final nameControler = TextEditingController();
  final addressControler = TextEditingController();
  final phoneControler = TextEditingController();

  String errorTextName = '';
  String errorTextAddress = '';
  String errorTextPhone = '';

  void onAdd(){
    setState(() {
      errorTextName=validateName(nameControler.text);
    });
    if(errorTextName.isEmpty){
      setState(() {
        errorTextAddress=validateAddress(addressControler.text);
      });
      if(errorTextAddress.isEmpty){
        setState(() {
          errorTextPhone=validatePhone(phoneControler.text);
        });
        if(errorTextPhone.isEmpty){
          User user =User(widget.isEditing?widget.initialItem!.id:-1,nameControler.text,addressControler.text,phoneControler.text);
          widget.onAdd(user);
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initialItem != null) {
      nameControler.text = widget.initialItem!.name;
      addressControler.text = widget.initialItem!.address;
      phoneControler.text = widget.initialItem!.phone;
    }
  }
  @override
  Widget build(BuildContext context) {
    final actionText = widget.isEditing ? 'Cập nhật ' : 'Thêm ';
    return AlertDialog(
          title:
          Text(widget.isEditing ? 'Cập nhật khách hàng' : 'Thêm khách hàng'),
          content: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
                      controller: nameControler,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        errorText: errorTextName.isNotEmpty?errorTextName:null,
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          border: const OutlineInputBorder(),
                          labelText: "Tên khách hàng"),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: addressControler,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                          errorText: errorTextAddress.isNotEmpty?errorTextAddress:null,
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          border: const OutlineInputBorder(),
                          labelText: "Địa chỉ"),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: phoneControler,
                      style: const TextStyle(fontSize: 18),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(

                          errorText: errorTextPhone.isNotEmpty?errorTextPhone:null,
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          border: const OutlineInputBorder(),
                          labelText: "Số điện thoại"),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20))),
                                  child: const Text("Cancel")),
                              ElevatedButton(
                                  onPressed: () {
                                    onAdd();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20))),
                                  child: Text(actionText))
                            ]))
                  ],
                ),
              ),
            ),
    );
  }
  @override
  void dispose() {
    nameControler.dispose();
    addressControler.dispose();
    phoneControler.dispose();
    super.dispose();
  }
}
