import 'package:flutter/foundation.dart';

@immutable
class Contact {
  final String id;
  final String nama;
  final String nomorTelepon;
  final String alamat;
  final DateTime tanggalLahir;

  const Contact({
    required this.id,
    required this.nama,
    required this.nomorTelepon,
    required this.alamat,
    required this.tanggalLahir,
  });

  int get umur {
    final now = DateTime.now();
    int age = now.year - tanggalLahir.year;
    if (now.month < tanggalLahir.month ||
        (now.month == tanggalLahir.month && now.day < tanggalLahir.day)) {
      age--;
    }
    return age;
  }

  String get initials {
    if (nama.isEmpty) return '?';
    final names = nama.trim().split(' ');
    if (names.length > 1 && names.last.isNotEmpty) {
      return '${names.first[0]}${names.last[0]}'.toUpperCase();
    } else if (names.first.isNotEmpty) {
      return names.first[0].toUpperCase();
    }
    return '?';
  }

  Contact copyWith({
    String? id,
    String? nama,
    String? nomorTelepon,
    String? alamat,
    DateTime? tanggalLahir,
  }) {
    return Contact(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      nomorTelepon: nomorTelepon ?? this.nomorTelepon,
      alamat: alamat ?? this.alamat,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
    );
  }
}