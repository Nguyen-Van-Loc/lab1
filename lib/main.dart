import 'package:flutter/material.dart';
import 'package:lab1/model/User.dart';

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
  final check = GlobalKey<FormState>();
  int selectedIndex = -1;
  List<User> list = [];
  int id = 1;
  String name = "", address = "", phone = "";
  final nameControler = TextEditingController();
  final addressControler = TextEditingController();
  final phoneControler = TextEditingController();
  final RegExp _phoneNumberRegExp = RegExp(r'^(03|09)[0-9]{8}$');

  void addList(User user) {
    if (selectedIndex == -1) {
      setState(() {
        user.id = id;
        id++;
        list.add(user);
      });
    }else{
      update(selectedIndex, name, address, phone);
    }
  Navigator.of(context).pop();
  }
  void reset(){
    selectedIndex=-1;
    nameControler.clear();
    addressControler.clear();
    phoneControler.clear();
  }
  void update(int id,String name,String address,String phone){
    setState(() {
      User userUd=list[id];
      userUd.name=name;
      userUd.address=address;
      userUd.phone=phone;
    });
  }
  void remove(int id) {
    setState(() {
      list.removeWhere((user) => user.id == id);
    });
    Navigator.of(context).pop();
  }

  void _dialogBuilder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(selectedIndex ==-1 ? "Thêm khách hàng": "Sửa khách hàng"),
          content: SingleChildScrollView(
            child: Form(
              key: check,
              child: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextFormField(
                      controller: nameControler,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Tên khách hàng không được để trống";
                        }
                      },
                      style: TextStyle(fontSize: 18),
                      onChanged: (value) => name = value,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          border: OutlineInputBorder(),
                          labelText: "Tên khách hàng"),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: addressControler,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Địa chỉ không được để trống";
                        }
                      },
                      style: TextStyle(fontSize: 18),
                      onChanged: (value) => address = value,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          border: OutlineInputBorder(),
                          labelText: "Địa chỉ"),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Số điện thoại không được để trống";
                        } else if (!_phoneNumberRegExp.hasMatch(value)) {
                          return 'Số điện thoại không đúng định dạng';
                        }
                      },
                      controller: phoneControler,
                      style: TextStyle(fontSize: 18),
                      onChanged: (value) => phone = value,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          border: OutlineInputBorder(),
                          labelText: "Số điện thoại"),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      padding: EdgeInsets.symmetric(vertical: 2,horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  child: Text("Cancel")),
                              ElevatedButton(
                                  onPressed: () {
                                    if (check.currentState!.validate()) {
                                      User newUser = User(id, name, address, phone);
                                      addList(newUser);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20))),
                                  child: Text("Submit"))
                            ]))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  void _diadelete(BuildContext context, User user) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(
                "Thông báo",
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.left,
              ),
              content: Text(
                "Bạn có chắc chắn muốn xóa ${user.name} không ?",
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(
                              vertical: 13, horizontal: 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Hủy"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 13, horizontal: 30),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        remove(user.id);
                      },
                      child: Text("Xác nhận"),
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
                      setState(() {
                        selectedIndex=index;
                        nameControler.text = item.name;
                        addressControler.text = item.address;
                        phoneControler.text = item.phone;
                      });
                      _dialogBuilder();
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
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_sharp),
                      onPressed: () {
                        _diadelete(context, item);
                      },
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
                    reset();
                    _dialogBuilder();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add"),
                )),
          ],
        ));
  }

  @override
  void dispose() {
    nameControler.dispose();
    addressControler.dispose();
    phoneControler.dispose();
    super.dispose();
  }
}
