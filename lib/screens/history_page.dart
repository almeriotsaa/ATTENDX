import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<Map<String, dynamic>> _historyData = [
    {
      'date': '15', 'day': 'Mon', 'month': 'Jun',
      'checkIn': '08:50', 'checkOut': '17:05',
      'status': 'On Time', 'color': Colors.green
    },
    {
      'date': '14', 'day': 'Sun', 'month': 'Jun',
      'checkIn': '--:--', 'checkOut': '--:--',
      'status': 'Day Off', 'color': Colors.grey
    },
    {
      'date': '13', 'day': 'Sat', 'month': 'Jun',
      'checkIn': '--:--', 'checkOut': '--:--',
      'status': 'Day Off', 'color': Colors.grey
    },
    {
      'date': '12', 'day': 'Fri', 'month': 'Jun',
      'checkIn': '09:15', 'checkOut': '17:10',
      'status': 'Late', 'color': Colors.orangeAccent
    },
    {
      'date': '11', 'day': 'Thu', 'month': 'Jun',
      'checkIn': '--:--', 'checkOut': '--:--',
      'status': 'Sick Leave', 'color': Colors.blueAccent
    },
    {
      'date': '10', 'day': 'Wed', 'month': 'Jun',
      'checkIn': '08:45', 'checkOut': '17:00',
      'status': 'On Time', 'color': Colors.green
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Attendance History',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, color: Colors.black87),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chevron_left),
                ),
                const Text(
                  'June 2026',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),

          Container(height: 1, color: Colors.grey.shade200),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _historyData.length,
              itemBuilder: (context, index) {
                final data = _historyData[index];
                return _buildHistoryCard(data);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 70,
            decoration: BoxDecoration(
              color: data['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data['date'],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: data['color'],
                  ),
                ),
                Text(
                  data['day'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: data['color'],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.login, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      'In: ${data['checkIn']}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.logout, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      'Out: ${data['checkOut']}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: data['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data['status'],
              style: TextStyle(
                color: data['color'],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
