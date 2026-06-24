import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  // State untuk masing-masing pengaturan notifikasi
  bool _masterPushNotifications = true;
  bool _attendanceReminders = true;
  bool _requestUpdates = true;
  bool _companyAnnouncements = false;

  bool _emailNotifications = true;
  bool _weeklyReport = false;

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
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori 1: Push Notifications (Notifikasi HP)
            const Text(
              'Push Notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  _buildSwitchTile(
                    icon: Icons.notifications_active_outlined,
                    title: 'Allow Push Notifications',
                    subtitle: 'Master switch for all app notifications',
                    value: _masterPushNotifications,
                    onChanged: (val) {
                      setState(() {
                        _masterPushNotifications = val;
                        // Jika master dimatikan, matikan juga anak-anaknya (opsional)
                        if (!val) {
                          _attendanceReminders = false;
                          _requestUpdates = false;
                          _companyAnnouncements = false;
                        }
                      });
                    },
                    isMaster: true, // Warna teks jadi biru agar terlihat seperti pengaturan utama
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.alarm_on_outlined,
                    title: 'Attendance Reminders',
                    subtitle: 'Remind me to check-in & check-out',
                    value: _attendanceReminders,
                    onChanged: _masterPushNotifications ? (val) => setState(() => _attendanceReminders = val) : null,
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.fact_check_outlined,
                    title: 'Request Updates',
                    subtitle: 'Notify when HR approves/rejects my requests',
                    value: _requestUpdates,
                    onChanged: _masterPushNotifications ? (val) => setState(() => _requestUpdates = val) : null,
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.campaign_outlined,
                    title: 'Company Announcements',
                    subtitle: 'News and updates from the HR department',
                    value: _companyAnnouncements,
                    onChanged: _masterPushNotifications ? (val) => setState(() => _companyAnnouncements = val) : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Kategori 2: Email Notifications
            const Text(
              'Email Notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  _buildSwitchTile(
                    icon: Icons.email_outlined,
                    title: 'Receive Emails',
                    subtitle: 'Get notifications sent to your inbox',
                    value: _emailNotifications,
                    onChanged: (val) {
                      setState(() => _emailNotifications = val);
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.insert_chart_outlined,
                    title: 'Weekly Attendance Report',
                    subtitle: 'Send a summary of my working hours every Friday',
                    value: _weeklyReport,
                    onChanged: _emailNotifications ? (val) => setState(() => _weeklyReport = val) : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Kirim preferensi user (true/false) ke API Laravel
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification settings saved!')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Preferences',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk Baris Sakelar (Toggle)
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    bool isMaster = false,
  }) {
    // Jika onChanged null, berarti master switch sedang mati (disabled)
    final bool isDisabled = onChanged == null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDisabled
                  ? Colors.grey.shade100
                  : (isMaster ? Colors.blueAccent.withOpacity(0.1) : Colors.grey.shade100),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDisabled ? Colors.grey.shade400 : (isMaster ? Colors.blueAccent : Colors.black87),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isMaster ? FontWeight.bold : FontWeight.w600,
                    color: isDisabled ? Colors.grey.shade400 : (isMaster ? Colors.blueAccent : Colors.black87),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDisabled ? Colors.grey.shade300 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: Colors.blueAccent,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  // Pembatas Garis Tipis Antar-menu
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 16),
      child: Container(height: 1, color: Colors.grey.shade100),
    );
  }
}