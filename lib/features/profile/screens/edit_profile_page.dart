import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController(text: 'Almerio');
  final _emailController = TextEditingController(text: 'almerio@company.com');

  final Map<String, List<String>> _divisionalPositions = {
    'IT Division': ['Flutter Developer', 'UI/UX Designer', 'System Analyst', 'QA Engineer'],
    'Finance': ['Accountant', 'Finance Auditor', 'Tax Officer', 'Treasurer'],
    'Human Resources': ['HR Recruiter', 'Compensation Specialist', 'Training Manager'],
    'Marketing': ['Social Media Specialist', 'SEO Specialist', 'Content Creator'],
    'Operations': ['Operations Staff', 'Logistics Coordinator', 'Branch Supervisor'],
  };

  late List<String> _divisions;
  String _selectedDivision = 'IT Division';
  String _selectedPosition = 'Flutter Developer'; 

  @override
  void initState() {
    super.initState();
    _divisions = _divisionalPositions.keys.toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> currentPositions = _divisionalPositions[_selectedDivision] ?? [];

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
          'Edit Profile',
          style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent, width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            _buildInputLabel('Full Name'),
            _buildTextField(controller: _nameController, icon: Icons.person_outline),

            const SizedBox(height: 20),

            _buildInputLabel('Email Address'),
            _buildTextField(controller: _emailController, icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),

            const SizedBox(height: 20),

            _buildInputLabel('Division'),
            _buildDropdownField(
              value: _selectedDivision,
              items: _divisions,
              icon: Icons.business_outlined,
              onChanged: (newValue) {
                setState(() {
                  _selectedDivision = newValue!;
                  _selectedPosition = _divisionalPositions[_selectedDivision]!.first;
                });
              },
            ),

            const SizedBox(height: 20),

            _buildInputLabel('Job Position'),
            _buildDropdownField(
              value: _selectedPosition,
              items: currentPositions,
              icon: Icons.badge_outlined,
              onChanged: (newValue) {
                setState(() {
                  _selectedPosition = newValue!;
                });
              },
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  final Map<String, dynamic> updatedData = {
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'division': _selectedDivision,
                    'position': _selectedPosition,
                  };

                  debugPrint("Data Profile Siap Diupdate: $updatedData");

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully!')),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required IconData icon, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey.shade400),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.grey.shade400),
        ),
        items: items.map((String val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(val, style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}