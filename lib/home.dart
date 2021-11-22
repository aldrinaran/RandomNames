import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:random_name_generator/firebase_analytics.dart';
import 'package:random_name_generator/main.dart';
import 'package:random_name_generator/setting.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final String? gender;
  final String? nationality;
  const MyHomePage(
      {Key? key, required this.title, this.gender, this.nationality})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<http.Response> fetchFullName({String? gender, String? nationality}) {
  String url = 'https://randomuser.me/api/';
  if (gender != null &&
      gender != "All" &&
      nationality != null &&
      nationality != "All") {
    url = url + "?gender=$gender&nat=$nationality";
  } else if (gender != null && gender != "All" && nationality == null) {
    url = url + "?gender=$gender";
  } else if (gender == null && nationality != null && nationality != "All") {
    url = url + "?nat=$nationality";
  }
  log(url);
  return http.get(Uri.parse(url));
}

class _MyHomePageState extends State<MyHomePage> {
  String? gender;
  String? nationality;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    gender = widget.gender;
    nationality = widget.nationality;
    analyticsSetCurrentScreen("Home Page", "Home");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    Widget fullNameCard(Map fullname) {
      return Stack(children: [
        Align(
            alignment: Alignment.center,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(fullname["first"],
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: Colors.black)),
              Text(fullname["last"],
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: Colors.black))
            ])),
        Positioned(
            top: height * 0.45,
            right: 20.0,
            child: IconButton(
                iconSize: 35,
                padding: const EdgeInsets.all(10),
                icon: const Icon(Icons.copy, color: Colors.grey),
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                          text: fullname["first"] + " " + fullname["last"]))
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to Clipboard')));
                  });
                  analyticsSendEvent("button_pressed", {
                    "button_name": "Icon Copy",
                    "name": fullname["first"] + " " + fullname["last"]
                  });
                }))
      ]);
    }

    Widget errorCard(String error) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(error,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: Colors.black)));
    }

    Widget newNameButton() {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: 70,
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0))),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF9977d0))),
              onPressed: () {
                if (!isLoading) {
                  setState(() {});
                  analyticsSendEvent(
                      "button_pressed", {"button_name": "New Name"});
                }
              },
              child: Text(isError ? "Try Again" : 'New Name',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w500))));
    }

    return Scaffold(
        body: Container(
            color: const Color(0xFF9277d0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: height * 0.1,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Text("Random Names",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)))),
                        Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: IconButton(
                                icon: const Icon(Icons.settings,
                                    color: Colors.white),
                                onPressed: () async {
                                  final setting = await Navigator.of(context)
                                      .push(createRoute(Setting(
                                          key: widget.key,
                                          gender: gender,
                                          nationality: nationality)));
                                  setState(() {
                                    if (setting != null) {
                                      gender = setting["gender"];
                                      nationality = setting["nationality"];
                                    }
                                  });
                                  analyticsSendEvent("button_pressed",
                                      {"button_name": "Icon Setting"});
                                }))
                      ])),
              Expanded(
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(48),
                              topRight: Radius.circular(48))),
                      child: Column(children: [
                        Expanded(
                            child: Center(
                                child: FutureBuilder<http.Response>(
                                    future: fetchFullName(
                                        gender: gender,
                                        nationality:
                                            nationality), // a previously-obtained Future<String> or null
                                    builder: (BuildContext context,
                                        AsyncSnapshot<http.Response> snapshot) {
                                      if (snapshot.hasData) {
                                        isLoading = false;
                                        if (snapshot.data!.statusCode == 200) {
                                          dynamic result =
                                              jsonDecode(snapshot.data!.body);
                                          Map fullname =
                                              result["results"][0]["name"];

                                          return fullNameCard(fullname);
                                        } else {
                                          isError = true;

                                          return errorCard(
                                              snapshot.data!.reasonPhrase ??
                                                  "Internal Server Error");
                                        }
                                      } else {
                                        isLoading = true;
                                        return const CircularProgressIndicator(
                                            color: Color(0xFF9277d0));
                                      }
                                    }))),
                        newNameButton()
                      ])))
            ])));
  }
}
