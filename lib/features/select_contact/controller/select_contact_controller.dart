import 'package:chat_app/features/select_contact/repository/select_contact_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContacRepo = ref.watch(selectContactRepoProvider);
  return selectContacRepo.getContact();
});

final selectConatctControllerProvider = Provider((ref) {
  final slectContactRepository = ref.watch(selectContactRepoProvider);
  return SelectContactController(
      ref: ref, selectContactRepo: slectContactRepository);
});

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepo selectContactRepo;

  SelectContactController({required this.ref, required this.selectContactRepo});

  void selectContact(Contact selectContact, BuildContext context) {
    selectContactRepo.selectContact(selectContact, context);
  }
}
