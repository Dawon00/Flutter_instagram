import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

final firestore = FirebaseFirestore.instance;

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  getData() async {
    var result = await firestore.collection('product').get();
    if (result.docs.isNotEmpty) {
      for (var doc in result.docs) {
        print(doc['name']);
      }
    }
    //회원가입 시키기
    try {
      var result = await auth.createUserWithEmailAndPassword(
        email: "kim@test.com",
        password: "123456",
      );
      result.user?.updateDisplayName('john');
    } catch (e) {
      print(e);
    }

    if (auth.currentUser?.uid == null) {
      print('로그인 상태');
    } else {
      print('로그인 하지 않은 상태');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('shop page'),
    );
  }
}
