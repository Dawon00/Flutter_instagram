import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart'; //for scroll
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (c) => Store1(),
    child: MaterialApp(theme: style.theme, home: MyApp()),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0; //현재 탭
  var data = []; //게시물 데이터
  var userImage;
  var userContent; //유저가 입력한 글

  saveData() async {
    var storage = await SharedPreferences.getInstance();

    var map = {'age': 20};
    storage.setString('map', jsonEncode(map));
    var result = storage.getString('map') ?? '없음';
    print(jsonDecode(result)['age']);
  }

  setUserContent(a) {
    setState(() {
      userContent = a;
    });
  }

  addMyData() {
    var myData = {
      "id": data.length,
      "image": userImage,
      "likes": 5,
      "date": "July 25",
      "content": userContent,
      "liked": false,
      "user": "John Kim"
    };
    setState(() {
      data.insert(0, myData);
    });
  }

  addData(a) {
    setState(() {
      data.add(a);
    });
  }

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));

    var result2 = jsonDecode(result.body);
    setState(() {
      data = result2;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instagram"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setState(() {
                  userImage = File(image.path);
                });
              }

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => Upload(
                            userImage: userImage,
                            setUserContent: setUserContent,
                            addMyData: addMyData,
                          )));
            },
            iconSize: 30,
          )
        ],
      ),
      body: [Home(data: data), Text('shop page')][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() {
            tab = i;
          });
        },
        iconSize: 25,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: 'shop'),
        ],
      ),
    );
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData})
      : super(key: key);
  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                addMyData();
              },
              icon: Icon(Icons.send))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          Text('이미지 업로드 화면'),
          TextField(
            onChanged: (text) {
              setUserContent(text);
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close)),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
    this.data,
  }) : super(key: key);
  final data;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        print('바닥');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      return ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (c, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.data[i]['image'].runtimeType == String
                    ? Image.network(widget.data[i]['image'])
                    : Image.file(widget.data[i][
                        'image']), //user가 추가한 데이터               Text(widget.data[i]['user']),
                GestureDetector(
                  child: Text(widget.data[i]['user']),
                  onTap: () {
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (c) => Profile()));
                  },
                ),
                Text('좋아요 ${widget.data[i]['likes'].toString()}'),
                Text(widget.data[i]['content']),
              ],
            );
          });
    } else {
      return Text('loading...');
    }
  }
}

class Store1 extends ChangeNotifier {
  //state 보관
  var name = 'john kim';
  var follower = 0;
  bool followed = false;
  var followed_string = '팔로우';
  changeName() {
    name = 'john park';
    notifyListeners(); //rerendering
  }

  addfollower() {
    if (followed == false) {
      follower += 1;
      followed = true;
      followed_string = '팔로잉';
      notifyListeners();
    } else {
      follower -= 1;
      followed = false;
      followed_string = '팔로우';
      notifyListeners();
    }
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<Store1>().name),
      ),
      body: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
          ),
          Text('팔로워 ${context.watch<Store1>().follower.toString()} 명'),
          ElevatedButton(
              onPressed: () {
                context.read<Store1>().changeName();
                context.read<Store1>().addfollower();
              },
              child: Text(context.watch<Store1>().followed_string))
        ],
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      ),
    );
  }
}
