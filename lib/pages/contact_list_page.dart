import 'package:contact_keeper/contact_model.dart';
import 'package:contact_keeper/contact_provider.dart';
import 'package:contact_keeper/pages/contact_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactListPage extends ConsumerWidget {
  const ContactListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. "Tonton" provider. Build akan otomatis dijalankan ulang saat state berubah
    final contacts = ref.watch(contactProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Keeper'),
      ),
      body: contacts.isEmpty
          ? const Center(child: Text('Belum ada kontak.'))
          : ListView.builder(
              // TAMBAHAN: Padding untuk list
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                // PERUBAHAN: Bungkus ListTile dengan Card
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    // TAMBAHAN: CircleAvatar dengan inisial
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        contact.initials,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    title: Text(contact.nama,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '${contact.nomorTelepon}\nUmur: ${contact.umur} tahun',
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'edit') {
                          // Navigasi ke form edit
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ContactFormPage(contact: contact),
                            ),
                          );
                        } else if (value == 'delete') {
                          // Tampilkan dialog konfirmasi hapus
                          _showDeleteDialog(context, ref, contact);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Hapus'),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigasi ke form edit saat item di-tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ContactFormPage(contact: contact),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigasi ke form tambah (tanpa mengirim data kontak)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ContactFormPage()),
          );
        },
      ),
    );
  }

  // Helper untuk menampilkan dialog konfirmasi hapus
  void _showDeleteDialog(BuildContext context, WidgetRef ref, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus ${contact.nama}?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Hapus'),
            onPressed: () {
              // 2. "Baca" notifier untuk memanggil method
              ref.read(contactProvider.notifier).deleteContact(contact.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}