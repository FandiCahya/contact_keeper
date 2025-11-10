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

  // Getter untuk menghitung umur
  int get umur {
    final now = DateTime.now();
    int age = now.year - tanggalLahir.year;
    if (now.month < tanggalLahir.month ||
        (now.month == tanggalLahir.month && now.day < tanggalLahir.day)) {
      age--;
    }
    return age;
  }

  // TAMBAHAN: Getter untuk inisial
  String get initials {
    if (nama.isEmpty) return '?';
    final names = nama.trim().split(' ');
    if (names.length > 1 && names.last.isNotEmpty) {
      // Ambil huruf pertama dari nama pertama dan nama terakhir
      return '${names.first[0]}${names.last[0]}'.toUpperCase();
    } else if (names.first.isNotEmpty) {
      // Jika hanya satu kata, ambil huruf pertama
      return names.first[0].toUpperCase();
    }
    return '?';
  }

  // copyWith untuk memudahkan proses update (immutable)
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