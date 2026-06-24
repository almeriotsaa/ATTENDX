import 'package:flutter/material.dart';

class SupportFaqPage extends StatefulWidget {
  const SupportFaqPage({super.key});

  @override
  State<SupportFaqPage> createState() => _SupportFaqPageState();
}

class _SupportFaqPageState extends State<SupportFaqPage> {
  // Controller untuk fitur pencarian FAQ secara real-time
  final _searchController = TextEditingController();

  // Data master FAQ aplikasi ATTENDX
  final List<Map<String, String>> _allFaqs = [
    {
      'question': 'Mengapa Face Detection gagal mengenali wajah saya?',
      'answer': 'Pastikan Anda berada di ruangan dengan pencahayaan yang cukup, tidak memakai masker/kacamata hitam, dan posisi wajah tegak lurus menatap kamera harian Anda.',
      'category': 'Attendance'
    },
    {
      'question': 'Bagaimana cara mengubah pengajuan cuti yang salah tanggal?',
      'answer': 'Pengajuan yang sudah dikirim tidak bisa diubah jika statusnya masih Pending. Anda harus berkoordinasi dengan HRD untuk menolak (Reject) pengajuan lama, lalu Anda bisa membuat pengajuan baru.',
      'category': 'Request'
    },
    {
      'question': 'Berapa lama batas waktu toleransi keterlambatan?',
      'answer': 'Aturan standar jam masuk adalah pukul 09:00 AM. Sistem tidak memiliki batas toleransi, jadi keterlambatan 1 menit pun akan otomatis tercatat sebagai "Late" oleh server Laravel.',
      'category': 'Attendance'
    },
    {
      'question': 'Bagaimana jika saya lupa melakukan Check-Out saat pulang?',
      'answer': 'Jika Anda lupa Check-Out, sistem akan otomatis mencatat jam pulang kosong. Anda wajib mengisi form pengajuan "Remote/Lupa Absen" di halaman Request pada keesokan harinya.',
      'category': 'Attendance'
    },
    {
      'question': 'Apakah saya bisa login di dua perangkat HP berbeda?',
      'answer': 'Demi keamanan data personal kepegawaian, satu akun ATTENDX hanya diizinkan aktif di satu perangkat smartphone saja dalam satu waktu.',
      'category': 'Account'
    },
  ];

  // List penampung hasil filter pencarian
  List<Map<String, String>> _filteredFaqs = [];

  @override
  void initState() {
    super.initState();
    _filteredFaqs = _allFaqs; // Di awal, tampilkan semua FAQ
  }

  void _filterSearch(String query) {
    setState(() {
      _filteredFaqs = _allFaqs
          .where((faq) =>
      faq['question']!.toLowerCase().contains(query.toLowerCase()) ||
          faq['answer']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Support & FAQ',
          style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. KOTAK PENCARIAN (STAY FIXED DI ATAS)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterSearch,
                decoration: InputDecoration(
                  hintText: 'Search for questions...',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // 2. LIST FAQ DAN HUBUNGI SUPPORT (BISA DI-SCROLL)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // Jika hasil pencarian kosong
                  if (_filteredFaqs.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Text(
                          'No FAQ found matching your keywords.',
                          style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                  // Looping Accordion FAQ
                  ..._filteredFaqs.map((faq) => _buildFaqTile(faq['question']!, faq['answer']!)),

                  const SizedBox(height: 32),

                  // 3. SEKSI HUBUNGI BANTUAN LANGSUNG
                  const Text(
                    'Still need help?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'If you can\'t find answers in FAQ, feel free to contact us.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _buildContactCard(Icons.headset_mic_outlined, 'IT Support', 'Report Bugs', Colors.blueAccent),
                      const SizedBox(width: 16),
                      _buildContactCard(Icons.assignment_ind_outlined, 'HR Dept', 'Ask Policies', Colors.purpleAccent),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper Pembuat Accordion Expandable yang Rapi
  Widget _buildFaqTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.015), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Theme(
        // Menghilangkan garis pembatas bawaan ExpansionTile agar tidak merusak tema minimalis
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: Colors.blueAccent,
          collapsedIconColor: Colors.grey.shade400,
          title: Text(
            question,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                answer,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper Kotak Kontak Support di Bagian Bawah
  Widget _buildContactCard(IconData icon, String title, String subtitle, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}