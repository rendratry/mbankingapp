import 'package:flutter/material.dart';
import 'package:mbanking_app/src/pages/token_listrik.dart';
import 'package:mbanking_app/src/widgets/lis_ewallet.dart';
import 'package:mbanking_app/src/widgets/register_sheet.dart';
import 'ewallet_draft.dart';

class ModalTrigger extends StatelessWidget {
  const ModalTrigger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        showModalBottomSheet(
          context: context,
          enableDrag: true,
          isDismissible: true,
          useRootNavigator: true,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return const MyBottomSheet();
          },
        );
      },
      label: const Text("Tambah Baru"),
      icon: const Icon(Icons.add),
      backgroundColor: Colors.blueAccent,
    );
  }
}

class MyBottomSheet extends StatelessWidget {
  const MyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: 650,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: const Listewallet(),
        ));
  }
}

class CreatePassword extends StatelessWidget {
  const CreatePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: 400,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: const PasswordCreate(),
        ));
  }
}
