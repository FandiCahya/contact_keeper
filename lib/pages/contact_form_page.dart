import 'package:contact_keeper/contact_model.dart';
import 'package:contact_keeper/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ContactFormPage extends ConsumerStatefulWidget {
  final Contact? contact;

  const ContactFormPage({super.key, this.contact});

  @override
  ConsumerState<ContactFormPage> createState() => _ContactFormPageState();
}

class _ContactFormPageState extends ConsumerState<ContactFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _teleponController;
  late final TextEditingController _alamatController;
  DateTime? _tanggalLahir;

  bool get _isEditMode => widget.contact != null;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.contact?.nama);
    _teleponController =
        TextEditingController(text: widget.contact?.nomorTelepon);
    _alamatController = TextEditingController(text: widget.contact?.alamat);
    _tanggalLahir = widget.contact?.tanggalLahir;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _tanggalLahir) {
      setState(() {
        _tanggalLahir = picked;
      });
    }
  }

  void _saveContact() {
    if (_formKey.currentState!.validate() && _tanggalLahir != null) {
      final nama = _namaController.text;
      final telepon = _teleponController.text;
      final alamat = _alamatController.text;

      if (_isEditMode) {
        final updatedContact = widget.contact!.copyWith(
          nama: nama,
          nomorTelepon: telepon,
          alamat: alamat,
          tanggalLahir: _tanggalLahir,
        );
        ref.read(contactProvider.notifier).updateContact(updatedContact);
      } else {
        final newContact = Contact(
          id: const Uuid().v4(),
          nama: nama,
          nomorTelepon: telepon,
          alamat: alamat,
          tanggalLahir: _tanggalLahir!,
        );
        ref.read(contactProvider.notifier).addContact(newContact);
      }

      Navigator.pop(context);
    } else if (_tanggalLahir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap pilih tanggal lahir.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Kontak' : 'Tambah Kontak'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveContact,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _teleponController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Nomor telepon tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                maxLines: 3,
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Alamat tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),
              Text(
                'Tanggal Lahir',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                )
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _tanggalLahir == null
                          ? 'Belum dipilih'
                          : DateFormat('dd MMMM yyyy').format(_tanggalLahir!),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today_outlined, size: 18),
                    label: const Text('Pilih Tanggal'),
                    onPressed: () => _selectDate(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}