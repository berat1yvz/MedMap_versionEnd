import 'package:flutter/material.dart';
import 'presentation/navigation/app_router.dart';

void main() {
  runApp(const MedMapApp());
}

class MedMapApp extends StatelessWidget {
  const MedMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedMap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.splashRoute,
    );
  }
}

class ModernInputScreen extends StatefulWidget {
  const ModernInputScreen({super.key});

  @override
  State<ModernInputScreen> createState() => _ModernInputScreenState();
}

class _ModernInputScreenState extends State<ModernInputScreen> {
  final TextEditingController _problemController = TextEditingController();
  String? _selectedLocation;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _locations = ['Istanbul', 'Antalya', 'Ankara'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3DBEC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'WHAT IS YOUR PROBLEM?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _problemController,
                      minLines: 2,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Describe your health issue',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: null,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide(
                            color: Color(0xFFB7E4C7),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Location Dropdown
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F7EF),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedLocation,
                        decoration: InputDecoration(
                          hintText: 'Select Location',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(24),
                        items:
                            _locations
                                .map(
                                  (loc) => DropdownMenuItem(
                                    value: loc,
                                    child: Text(loc),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (val) => setState(() => _selectedLocation = val),
                      ),
                    ),
                    // Start Date Picker
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F7EF),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          final now = DateTime.now();
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? now,
                            firstDate: now,
                            lastDate: DateTime(now.year + 2),
                          );
                          if (picked != null) {
                            setState(() => _startDate = picked);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _startDate == null
                                    ? 'Select Start Date'
                                    : '${_startDate!.day.toString().padLeft(2, '0')}.${_startDate!.month.toString().padLeft(2, '0')}.${_startDate!.year}',
                                style: TextStyle(
                                  color:
                                      _startDate == null
                                          ? Colors.grey[700]
                                          : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // End Date Picker
                    Container(
                      margin: const EdgeInsets.only(bottom: 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F7EF),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          final now = DateTime.now();
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _endDate ?? now,
                            firstDate: now,
                            lastDate: DateTime(now.year + 2),
                          );
                          if (picked != null) {
                            setState(() => _endDate = picked);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _endDate == null
                                    ? 'Select End Date'
                                    : '${_endDate!.day.toString().padLeft(2, '0')}.${_endDate!.month.toString().padLeft(2, '0')}.${_endDate!.year}',
                                style: TextStyle(
                                  color:
                                      _endDate == null
                                          ? Colors.grey[700]
                                          : Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/doctor_list');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 36,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF728DCA),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.10),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.search, color: Colors.white, size: 24),
                              SizedBox(width: 10),
                              Text(
                                'SEARCH',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final List<Map<String, String>> doctors = [
    {
      'name': 'Dr. John Doe',
      'profession': 'Cardiologist',
      'phone': '+1 589 676 485',
      'website': 'www.johndoc.com',
    },
    {
      'name': 'Dr. Emily Smith',
      'profession': 'Neurologist',
      'phone': '+1 555 123 456',
      'website': 'www.emilysmith.com',
    },
    {
      'name': 'Dr. Ali Kaya',
      'profession': 'Plastic Surgeon',
      'phone': '+90 532 111 2233',
      'website': 'www.alikaya.com',
    },
    {
      'name': 'Dr. Sofia Rossi',
      'profession': 'Dermatologist',
      'phone': '+39 06 1234 5678',
      'website': 'www.sofiarossi.it',
    },
  ];

  int? expandedIndex;
  int? acceptedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9E1F2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              children: [
                // Üstte ortalanmış dairesel ikon
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 28),
                  alignment: Alignment.center,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.18),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.medical_services_outlined,
                        size: 38,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                // Doktor kartları
                ...List.generate(doctors.length, (index) {
                  final doctor = doctors[index];
                  final isExpanded = expandedIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          expandedIndex = isExpanded ? null : index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.ease,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 18,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.account_circle,
                                size: 54,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child:
                                    isExpanded
                                        ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 2),
                                            Text(
                                              doctor['name'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              doctor['profession'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            if (doctor['phone'] != null) ...[
                                              const SizedBox(height: 16),
                                              Text(
                                                'Phone Number: \\${doctor['phone']}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                            if (doctor['website'] != null) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                'Website: \\${doctor['website']}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                            const SizedBox(height: 12),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      acceptedIndex == index
                                                          ? const Color(
                                                            0xFF2C3E75,
                                                          )
                                                          : const Color(
                                                            0xFF3D5AFE,
                                                          ),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          18,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 22,
                                                        vertical: 10,
                                                      ),
                                                  elevation: 0,
                                                ),
                                                onPressed:
                                                    acceptedIndex == index
                                                        ? () {
                                                          setState(() {
                                                            acceptedIndex =
                                                                null;
                                                          });
                                                        }
                                                        : () {
                                                          setState(() {
                                                            acceptedIndex =
                                                                index;
                                                          });
                                                          Navigator.pushNamed(
                                                            context,
                                                            '/plan_selection',
                                                          );
                                                        },
                                                child: Text(
                                                  acceptedIndex == index
                                                      ? 'REMOVE'
                                                      : 'ACCEPT',
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                        : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doctor['name'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              doctor['profession'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlanSelectionScreen extends StatelessWidget {
  const PlanSelectionScreen({super.key});

  static const List<Map<String, dynamic>> plans = [
    {
      "title": "PLAN A",
      "features": [
        "Date",
        "Accommodation",
        "Day Flow",
        "Companion",
        "1+ Surgery",
      ],
      "price": "\$100",
    },
    {
      "title": "PLAN B",
      "features": ["Date", "Accommodation", "Companion"],
      "price": "\$70",
    },
    {
      "title": "PLAN C",
      "features": ["Date", "Accommodation"],
      "price": "\$60",
    },
  ];

  static const Map<String, IconData> featureIcons = {
    "Date": Icons.calendar_today,
    "Accommodation": Icons.hotel,
    "Day Flow": Icons.route,
    "Companion": Icons.people,
    "1+ Surgery": Icons.medical_services,
    "Surgery": Icons.medical_services,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: Column(
            children: [
              ...plans.asMap().entries.map((entry) {
                final plan = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/payment',
                        arguments: plan['price'],
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF1F5FB), Color(0xFFDDE6F7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(22, 22, 22, 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan["title"] + ":",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...List.generate(
                                  (plan["features"] as List).length,
                                  (i) {
                                    final feature = plan["features"][i];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            featureIcons[feature] ??
                                                Icons.info_outline,
                                            color: Colors.black87,
                                            size: 22,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            feature +
                                                (feature.endsWith(":")
                                                    ? ""
                                                    : (feature == "Date" ||
                                                        feature ==
                                                            "Accommodation")
                                                    ? ":"
                                                    : ""),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 18,
                            bottom: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF728DCA),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Text(
                                plan["price"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final price = ModalRoute.of(context)?.settings.arguments as String?;
    final pastelBlue = const Color(0xFFDDE6F7);
    final pastelBlueGradient = const LinearGradient(
      colors: [Color(0xFFB7C8F7), Color(0xFFDDE6F7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final boxShadow = [
      BoxShadow(
        color: Colors.blueGrey.withOpacity(0.10),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ];

    InputDecoration inputDec(String hint) => InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: pastelBlue,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.blue.shade200, width: 1.5),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Başlık
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF728DCA), Color(0xFFB7C8F7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: boxShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.credit_card, color: Colors.white, size: 26),
                    SizedBox(width: 12),
                    Text(
                      'PAYMENT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (price != null) ...[
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F5FB),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.08),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Total: ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E75),
                        ),
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E75),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 36),
              // Name On Card
              Container(
                decoration: BoxDecoration(
                  color: pastelBlue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: boxShadow,
                ),
                child: TextField(decoration: inputDec('Name On Card')),
              ),
              const SizedBox(height: 22),
              // Card Number
              Container(
                decoration: BoxDecoration(
                  color: pastelBlue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: boxShadow,
                ),
                child: TextField(
                  decoration: inputDec('Card Number'),
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                ),
              ),
              const SizedBox(height: 22),
              // Month & Year
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: pastelBlue,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: boxShadow,
                      ),
                      child: TextField(
                        decoration: inputDec('Month'),
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: pastelBlue,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: boxShadow,
                      ),
                      child: TextField(
                        decoration: inputDec('Year'),
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              // CVC
              Row(
                children: [
                  Container(
                    width: 110,
                    decoration: BoxDecoration(
                      color: pastelBlue,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: boxShadow,
                    ),
                    child: TextField(
                      decoration: inputDec('CVC'),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        '3 or 4 digits usually found on the signature strip',
                        style: TextStyle(color: Colors.black38, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 38),
              // PAY butonu
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF728DCA), Color(0xFFB7C8F7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: boxShadow,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {}, // Şimdilik işlevsiz
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        child: Text(
                          'PAY',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
