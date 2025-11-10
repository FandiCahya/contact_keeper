import 'package:contact_keeper/contact_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Notifier
class ContactNotifier extends Notifier<List<Contact>> {
  @override
  List<Contact> build() {
    // State awal, bisa diisi data dummy jika perlu
    return []; 
  }

  // Method untuk menambah kontak
  void addContact(Contact contact) {
    state = [...state, contact];
  }

  // Method untuk update kontak
  void updateContact(Contact updatedContact) {
    state = [
      for (final contact in state)
        if (contact.id == updatedContact.id) updatedContact else contact,
    ];
  }

  // Method untuk menghapus kontak
  void deleteContact(String id) {
    state = state.where((contact) => contact.id != id).toList();
  }
}

// 2. Provider
final contactProvider = NotifierProvider<ContactNotifier, List<Contact>>(() {
  return ContactNotifier();
});