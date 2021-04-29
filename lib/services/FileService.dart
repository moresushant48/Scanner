import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_context/one_context.dart';

class FileService {
  static final String EXTENSION_PDF = ".pdf";

  TextEditingController fileNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<String> getFileName(String defName) async {
    fileNameController.text = defName;
    return OneContext().showDialog(
      builder: (ctx) => AlertDialog(
        title: Text(
          "Rename",
          textAlign: TextAlign.center,
        ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            validator: (value) {
              return value.isEmpty ? "File Name cannot be Blank." : null;
            },
            controller: fileNameController,
            keyboardType: TextInputType.name,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_-]')),
            ],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.blue)),
              labelText: 'Enter File Name',
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
          TextButton(
              onPressed: () {
                // if (fileNameController.value.text != "" &&
                //     fileNameController.value.text != null) {
                final FormState form = _formKey.currentState;
                if (form.validate()) {
                  print('Form is valid');
                  Navigator.pop(ctx, fileNameController.value.text);
                } else {
                  print('Form is invalid');
                }
                // } else {}
              },
              child: Text("Save")),
        ],
      ),
    );
  }
}

final fileService = FileService();
