import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TimeInputField extends StatefulWidget {
  MaskTextInputFormatter? inputFormator;
  TimeInputField({Key? key, this.inputFormator}) : super(key: key);

  @override
  _TimeInputFieldState createState() => _TimeInputFieldState();
}

class _TimeInputFieldState extends State<TimeInputField> {
  TextEditingController _txtTimeController = TextEditingController();

  MaskTextInputFormatter timeMaskFormatter =
      MaskTextInputFormatter(mask: 'a#', filter: {
    "#": RegExp(r'[0-9]'),
    "a": RegExp(r'[0-2]'),
  });

  @override
  void initState() {
    _txtTimeController.addListener(() {
      var s = _txtTimeController.value.text.toString();
      if (s.isNotEmpty && s.length == 1) {
        if (s[0] == "2") {
          _txtTimeController.value = timeMaskFormatter.updateMask(
              mask: 'a#',
              filter: {"#": RegExp(r'[0-4]'), "a": RegExp(r'[0-2]')});
        } else if (s[0] == "1" || (s[0] == "0")) {
          _txtTimeController.value = timeMaskFormatter.updateMask(
              mask: 'a#',
              filter: {"#": RegExp(r'[0-9]'), "a": RegExp(r'[0-2]')});
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _txtTimeController,
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      decoration: InputDecoration(
        hintText: '00',
      ),
      inputFormatters: <TextInputFormatter>[timeMaskFormatter],
      onChanged: (va) {
        var s = va;
      },
    );
  }
}
