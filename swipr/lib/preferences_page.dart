import 'package:flutter/material.dart';

class PreferencesPage extends StatefulWidget {
  Set<String> selectedPreferences = {};

  PreferencesPage({Key? key, required this.selectedPreferences}) : super(key: key);


  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  bool _checkBoxValue1 = false;
  bool _checkBoxValue2 = false;
  bool _checkBoxValue3 = false;

  Map<String, bool> _checkboxValues = {};


  @override
  void initState() {
    super.initState();

    // Initialize the checkbox values based on the selected preferences
    for (String preference in widget.selectedPreferences) {
      _checkboxValues[preference] = false;
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        title: const Text('Preferences'),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: const Color(0xFFCCCCCC),
        ),
        child: Column(
          children: [
            ListTile(
              title: const Text('Action'),
              titleTextStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 24, fontWeight: FontWeight.bold),
              trailing: Checkbox(
                value: _checkBoxValue1,
                onChanged: (bool? value) {
                  setState(() {
                    _checkBoxValue1 = value!;
                    _onCheckboxChanged(value, "Action");
                  });
                },
                activeColor: const Color(0xFF2B3A67), // color when checked
                checkColor: const Color(0xFFCCCCCC), // color of the check
              ),
            ),
            ListTile(
              title: const Text('Adventure'),
              titleTextStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 24, fontWeight: FontWeight.bold),
              trailing: Checkbox(
                value: _checkBoxValue2,
                onChanged: (value) {
                  setState(() {
                    _checkBoxValue2 = value!;
                    _onCheckboxChanged(value, "Adventure");
                  });
                },
                activeColor: const Color(0xFF2B3A67), // color when checked
                checkColor: const Color(0xFFCCCCCC), // color of the check
              ),
            ),
            ListTile(
              title: const Text('Fiction'),
              titleTextStyle: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 24, fontWeight: FontWeight.bold),
              trailing: Checkbox(
                value: _checkBoxValue3,
                onChanged: (value) {
                  setState(() {
                    _checkBoxValue3 = value!;
                    _onCheckboxChanged(value, "Fiction");
                  });
                },
                activeColor: const Color(0xFF2B3A67), // color when checked
                checkColor: const Color(0xFFCCCCCC), // color of the check
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCheckboxChanged(bool value, String preference) {
    setState(() {
      _checkboxValues[preference] = value;

      if (value) {
        widget.selectedPreferences.add(preference);
      } else {
        widget.selectedPreferences.remove(preference);
      }
    });
  }



}
