import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomWidgets {

  static Widget textField({
    String title = "",
    String? hinttext,
    bool isNumber = false,
    bool ischange = false,
    var prefixIcon,
    var onchanged,
    bool secure = false,
    int? length,
    TextEditingController? textController,
    int lines = 1,
    var cornerRadius = 0.0,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Oppen-sans',
                color: Color(0xff355070),
                fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            onChanged: onchanged,
            maxLines: lines,
            controller: textController,
            maxLength: length,
            obscureText: secure,
            obscuringCharacter: '*',
            inputFormatters: [
              LengthLimitingTextInputFormatter(length),
            ],
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: hinttext,
              hintStyle: const TextStyle(color: Color(0xff909091), fontWeight: FontWeight.normal),
              prefixIcon: prefixIcon,
              suffixIcon: ischange
                  ? TextButton(
                      onPressed: () {
                        
                      },
                      child: const Text(
                        "Ubah",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          color: Color(0xffFFB575),
                        ),
                      ),
                    )
                  : null,
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(cornerRadius),
              ),
              fillColor: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }
}
class CustomPassword {
  static Widget textField(
      {String title = "",
        var hinttext,
        bool isNumber = false,
        bool autofocus = false,
        var onchanged,
        var key,
        var validator,
        var prefixIcon,
        bool secure = false,
        int? length,
        TextEditingController? textController,
        int lines = 1,
        var cornerRadius = 0.0,
        var suffixicon}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Oppen-sans',
                color: Color(0xff355070),
                fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            key: key,
            onChanged: onchanged,
            autofocus: autofocus,
            maxLines: lines,
            controller: textController,
            maxLength: length,
            obscureText: secure,
            obscuringCharacter: '*',
            validator: validator,
            inputFormatters: [
              LengthLimitingTextInputFormatter(length),
            ],
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: hinttext,
              hintStyle: const TextStyle(color: Color(0xff0A6DED)),
              prefixIcon: prefixIcon,
              suffixIcon: suffixicon,
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(cornerRadius),
              ),
              fillColor: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }
}

