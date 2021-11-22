import 'package:flutter/material.dart';
import 'package:random_name_generator/firebase_analytics.dart';

class Setting extends StatefulWidget {
  final String? gender;
  final String? nationality;
  const Setting({Key? key, this.gender, this.nationality}) : super(key: key);

  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  String selectedGender = "All";
  List<DropdownMenuItem<String>> gender = [
    const DropdownMenuItem(value: "All", child: Text('All')),
    const DropdownMenuItem(value: "Male", child: Text('Male')),
    const DropdownMenuItem(value: "Female", child: Text('Female')),
  ];

  String selectedNationality = "All";
  // "AU, BR, CA, CH, DE, DK, ES, FI, FR, GB, IE, IR, NO, NL, NZ, TR, US"'
  List<DropdownMenuItem<String>> nationality = [
    const DropdownMenuItem(value: "All", child: Text('All')),
    const DropdownMenuItem(value: "US", child: Text('American')),
    const DropdownMenuItem(value: "AU", child: Text('Australian')),
    const DropdownMenuItem(value: "BR", child: Text('Brazilian')),
    const DropdownMenuItem(value: "GB", child: Text('British')),
    const DropdownMenuItem(value: "CA", child: Text('Canadian')),
    const DropdownMenuItem(value: "DK", child: Text('Danish')),
    const DropdownMenuItem(value: "NL", child: Text('Dutch')),
    const DropdownMenuItem(value: "FI", child: Text('Finnish')),
    const DropdownMenuItem(value: "FR", child: Text('French')),
    const DropdownMenuItem(value: "IR", child: Text('Iranian')),
    const DropdownMenuItem(value: "IE", child: Text('Irish')),
    const DropdownMenuItem(value: "DE", child: Text('German')),
    const DropdownMenuItem(value: "NZ", child: Text('New Zealander')),
    const DropdownMenuItem(value: "NO", child: Text('Norwegian')),
    const DropdownMenuItem(value: "ES", child: Text('Spanish')),
    const DropdownMenuItem(value: "CH", child: Text('Swiss')),
    const DropdownMenuItem(value: "TR", child: Text('Turkish'))
  ];

  @override
  void initState() {
    super.initState();
    if (widget.gender != null) {
      selectedGender = widget.gender!;
    }
    if (widget.nationality != null) {
      selectedNationality = widget.nationality!;
    }
    analyticsSetCurrentScreen("Setting Page", "Setting");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Setting"),
            backgroundColor: const Color(0xFF9277d0)),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text("Gender",
                            style: Theme.of(context).textTheme.headline6),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    items: gender,
                                    value: selectedGender,
                                    icon: Transform.scale(
                                        scale: 0.8,
                                        child: const Icon(
                                            Icons.keyboard_arrow_down)),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGender = value.toString();
                                      });
                                    }))),
                        const SizedBox(height: 10),
                        Text("Nationality",
                            style: Theme.of(context).textTheme.headline6),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    items: nationality,
                                    value: selectedNationality,
                                    icon: Transform.scale(
                                        scale: 0.8,
                                        child: const Icon(
                                            Icons.keyboard_arrow_down)),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedNationality = value.toString();
                                      });
                                    }))),
                      ]))),
          Container(
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
                    Navigator.pop(context, {
                      "gender": selectedGender,
                      "nationality": selectedNationality
                    });
                    analyticsSendEvent(
                        "button_pressed", {"button_name": "Save"});
                    analyticsSendEvent("setting_saved", {
                      "gender": selectedGender,
                      "nationality": selectedNationality
                    });
                  },
                  child: Text('Save',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500))))
        ]));
  }
}
