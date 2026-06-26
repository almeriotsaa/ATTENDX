import 'package:attandance_app/features/camera/screens/check_in_camera_screen.dart';
import 'package:camera/camera.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> officeLocations = [
    {
      'name': 'Margo City Branch',
      'lat': -6.3728395,
      'lng': 106.8320354,
    },
    {
      'name': 'Kantor Kos Ananda',
      'lat': -6.3606356,
      'lng': 106.8218872,
    },
    {
      'name': 'Kantor Kos Elba',
      'lat': -6.3584565,
      'lng': 106.8185717,
    },
  ];

  final double maxRadiusInMeters = 300.0;

  bool _isLoadingLocation = false;
  bool _hasCheckedIn = false;

  Future<void> _validateLocationCheckIn() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please turn on your GPS.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      bool isWithinAnyOffice = false;
      double shortestDistance = double.infinity;
      String nearestOfficeName = '';

      for (var office in officeLocations) {
        double distance = Geolocator.distanceBetween(
          office['lat'],
          office['lng'],
          position.latitude,
          position.longitude,
        );

        if (distance < shortestDistance) {
          shortestDistance = distance;
          nearestOfficeName = office['name'];
        }

        if (distance <= maxRadiusInMeters) {
          isWithinAnyOffice = true;
          break;
        }
      }

      if (isWithinAnyOffice) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckInCameraScreen(camera: widget.camera),
            ),
          );
        }
      } else {
        if (mounted) {
          double extraDistance = shortestDistance - maxRadiusInMeters;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Absen Gagal! Anda berada ${extraDistance.toStringAsFixed(0)} meter di luar jangkauan kantor terdekat ($nearestOfficeName).',
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 1. APP BAR ESTETIK
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu, color: Colors.black87, size: 22),
                      ),
                    ),
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.black, Colors.blueAccent],
                      ).createShader(bounds),
                      child: Text(
                        'ATTENDX',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87, size: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 2. GREETING PROFILE CARD (Lebih Compact & Modern)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/foto_profile.jpeg'),
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning,',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Almerio Tsany',
                          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        Text(
                          'Mobile Developer',
                          style: GoogleFonts.poppins(fontSize: 13, color: Colors.blueAccent, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 3. TODAY'S STATUS CARD
                Text(
                  'Today\'s Status',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTimeStatus('Check In', '--:--', Icons.login_rounded, Colors.green),
                          Container(width: 1, height: 40, color: Colors.grey.shade200), // Garis pembatas vertikal
                          _buildTimeStatus('Check Out', '--:--', Icons.logout_rounded, Colors.orangeAccent),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1, color: Colors.black12),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Working Hours',
                            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '09:00 - 17:00 WIB',
                            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // TOMBOL ABSEN DENGAN EFEK GEOFENCING
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _hasCheckedIn ? Colors.orangeAccent : Colors.blueAccent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: _isLoadingLocation ? null : _validateLocationCheckIn,
                          child: _isLoadingLocation
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_hasCheckedIn ? Icons.logout_rounded : Icons.fingerprint_rounded, size: 22),
                              const SizedBox(width: 10),
                              Text(
                                _hasCheckedIn ? 'CLOCK OUT NOW' : 'CLOCK IN NOW',
                                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // 4. ATTENDANCE SUMMARY (DIBUAT HORIZONTAL AGAR RAPI)
                Text(
                  'Attendance Summary',
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Chart di Kiri
                          SizedBox(
                            height: 120,
                            width: 120,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: 30,
                                sectionsSpace: 4,
                                sections: [
                                  PieChartSectionData(color: Colors.green, value: 60, title: '', radius: 20),
                                  PieChartSectionData(color: Colors.orangeAccent, value: 30, title: '', radius: 20),
                                  PieChartSectionData(color: Colors.redAccent, value: 10, title: '', radius: 20),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Keterangan Legend di Kanan
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLegendItem(Colors.green, 'On Time', '60%'),
                                const SizedBox(height: 12),
                                _buildLegendItem(Colors.orangeAccent, 'Late', '30%'),
                                const SizedBox(height: 12),
                                _buildLegendItem(Colors.redAccent, 'Leave / Absent', '10%'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const Divider(height: 1, color: Colors.black12),
                      const SizedBox(height: 24),

                      // Box Ringkasan Kecil di Bawah
                      Row(
                        children: [
                          Expanded(child: _buildSummaryBox('12', 'Present', Colors.green)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildSummaryBox('3', 'Late', Colors.orangeAccent)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildSummaryBox('0', 'Leave', Colors.redAccent)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBox(String count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeStatus(String label, String time, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(
              time,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text, String percentage) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.grey.shade600, fontSize: 13),
          ),
        ),
        Text(
          percentage,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13),
        ),
      ],
    );
  }
}