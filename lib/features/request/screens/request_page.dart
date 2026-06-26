import 'package:flutter/material.dart';
import 'add_request_page.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  // SIMULASI ROLE DARI BACKEND: Ubah ke 'Employee' atau 'HRD'
  final String currentUserRole = 'HRD';

  // Data Dummy Request dari Karyawan (Untuk tab Approvals)
  final List<Map<String, dynamic>> _employeePendingRequests = [
    {
      'id': 101,
      'employeeName': 'Rian Sitorus',
      'type': 'Annual Leave',
      'date': '02 - 05 Jul 2026',
      'notes': 'Acara pernikahan keluarga di luar kota.',
      'icon': Icons.flight_takeoff,
      'color': Colors.blue,
    },
    {
      'id': 102,
      'employeeName': 'Siti Aminah',
      'type': 'Sick Leave',
      'date': '29 Jun 2026',
      'notes': 'Sakit demam berdarah, butuh istirahat total.',
      'icon': Icons.medical_services_outlined,
      'color': Colors.redAccent,
    },
  ];

  // Data Dummy milik HRD/Employee sendiri (Untuk tab My Requests)
  final List<Map<String, dynamic>> _myRecentRequests = [
    {
      'type': 'Annual Leave',
      'date': '25 - 26 Jun 2026',
      'submitDate': '20 Jun 2026',
      'status': 'Pending',
      'icon': Icons.flight_takeoff,
      'color': Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    bool isHRD = currentUserRole == 'HRD';

    // Jika HRD, gunakan DefaultTabController dengan 2 Tab
    if (isHRD) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Requests',
              style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            bottom: TabBar(
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.grey.shade400,
              indicatorColor: Colors.blueAccent,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              tabs: const [
                Tab(text: 'My Requests'),
                Tab(text: 'Approvals'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildMyRequestsView(), // Tab 1: Pengajuan Milik Sendiri
              _buildApprovalsView(),  // Tab 2: Halaman Persetujuan Anak Buah
            ],
          ),
        ),
      );
    }

    // Jika Employee biasa, tampilkan Scaffold normal tanpa Tab
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Requests',
          style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _buildMyRequestsView(),
    );
  }

  // ================= 1. HALAMAN PENGAJUAN SENDIRI (MY REQUESTS) =================
  Widget _buildMyRequestsView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Create Request', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 110,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildCategoryCard('Leave', Icons.flight_takeoff, Colors.blue),
                _buildCategoryCard('Sick', Icons.medical_services_outlined, Colors.redAccent),
                _buildCategoryCard('Overtime', Icons.timer_outlined, Colors.orange),
                _buildCategoryCard('Remote', Icons.laptop_mac_outlined, Colors.purpleAccent),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Recent Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _myRecentRequests.length,
            itemBuilder: (context, index) => _buildStatusCard(_myRecentRequests[index]),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ================= 2. HALAMAN PERSETUJUAN (APPROVALS) =================
  Widget _buildApprovalsView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Pending Approvals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
          const SizedBox(height: 16),
          if (_employeePendingRequests.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text('No pending requests to approve 🎉', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _employeePendingRequests.length,
            itemBuilder: (context, index) {
              return _buildApprovalCard(_employeePendingRequests[index]);
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: KARTU APPROVAL UNTUK HRD ---
  Widget _buildApprovalCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: data['color'].withOpacity(0.1),
                child: Icon(data['icon'], color: data['color'], size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['employeeName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(data['type'], style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Date Request:', style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.bold)),
          Text(data['date'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Text('Reason:', style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.bold)),
          Text(data['notes'], style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.4)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _employeePendingRequests.removeWhere((req) => req['id'] == data['id']);
                    });
                  },
                  icon: const Icon(Icons.close_rounded, size: 16, color: Colors.redAccent),
                  label: const Text('Reject', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _employeePendingRequests.removeWhere((req) => req['id'] == data['id']);
                    });
                  },
                  icon: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
                  label: const Text('Approve', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // --- WIDGET HELPER LAMA ---
  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddRequestPage(requestType: title)));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(Map<String, dynamic> data) {
    Color statusColor = data['status'] == 'Approved' ? Colors.green : (data['status'] == 'Rejected' ? Colors.red : Colors.amber.shade700);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: data['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
            child: Icon(data['icon'], color: data['color'], size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['type'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(data['date'], style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Text('Submitted: ${data['submitDate']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(data['status'], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}