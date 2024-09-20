import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:red/screens/home.dart';
import 'package:red/widgets/button.dart';
import 'package:red/widgets/heading_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookServiceMap extends StatefulWidget {
  final LatLng location;
  final String address;
  const BookServiceMap(
      {Key? key, required this.location, required this.address})
      : super(key: key);

  @override
  State<BookServiceMap> createState() => _BookServiceMapState();
}

class _BookServiceMapState extends State<BookServiceMap> {
  bool isUpdating = false;
  bool isLoading = true;
  Map<String, int> serviceMap = {};
  String? selectedService;
  String? selectedValue;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  late TextEditingController _addressController;
  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.address);
    _fetchServices();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _bookService() async {
    setState(() {
      isUpdating = true;
    });
    if (_addressController.text.isEmpty ||
        _houseController.text.isEmpty ||
        selectedService == null ||
        (selectedService?.isEmpty ?? true) ||
        _selectedDate == null ||
        _selectedTime == null) {
      Fluttertoast.showToast(msg: "Please fill all the fields");
      setState(() {
        isUpdating = false;
      });
      return;
    }

    final url =
        Uri.parse('http://feniceshieldchemical.bwsoft.in/api/api/book-now/');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? id = prefs.getInt('id');
    final serviceId = serviceMap[selectedService];
    final data = {
      "user_id": id,
      "service_id": serviceId,
      "service_address": '${_houseController.text}, ${_addressController.text}',
      "latitude": widget.location.latitude.toStringAsFixed(6),
      "longitude": widget.location.longitude.toStringAsFixed(6),
      "comments": _commentsController.text,
      "service_date": _selectedDate?.toString().split(' ')[0],
      "service_time": "${_selectedTime?.hour}:${_selectedTime?.minute}",
      "status": "pending"
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Center(child: HeadingText(text: 'Booked')),
            content: Image.asset(
              'assets/images/booked.png',
              height: 250,
              width: 250,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
            ],
          ),
        );
      } else {
        if (kDebugMode) {
          print('Failed to book service: ${response.body}');
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            // content: Text('Failed to book service: ${response.body}'),
            content: const Text('Failed to book service'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error booking service: $e");
      }
    } finally {
      setState(() {
        isUpdating = false;
      });
    }
  }

  Future<void> _fetchServices() async {
    setState(() {
      isLoading = true; // Start loading
    });

    final url =
        Uri.parse('http://feniceshieldchemical.bwsoft.in/api/api/services/');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> services = json.decode(response.body);
        setState(() {
          serviceMap = {
            for (var service in services)
              service['name'].toString(): service['id'] as int
          };
          isLoading = false; // Stop loading when data is available
        });
      } else {
        setState(() {
          isLoading = false; // Stop loading on failure
        });
        Fluttertoast.showToast(msg: "Failed to load services");
        if (kDebugMode) {
          print('Failed to load services: ${response.body}');
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading on error
      });
      Fluttertoast.showToast(msg: "Error fetching services");
      if (kDebugMode) {
        print("Error fetching services: $e");
      }
    }
  }

  Future<void> _pickDate() async {
    DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? currentDate,
      firstDate: DateTime(currentDate.year - 1),
      lastDate: DateTime(currentDate.year + 1),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay currentTime = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? currentTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No date selected';
    return "${date.day}/${date.month}/${date.year}";
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'No time selected';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour:${time.minute.toString().padLeft(2, '0')} $period";
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeadingText(text: 'Book site visit'),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Services',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(15),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 49, 121, 46),
                                width: 2),
                          ),
                        ),
                        hint: const Text(
                          'Select the service',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        items: serviceMap.keys
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ),
                                ))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a service.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            selectedService = value;
                          });
                        },
                        onSaved: (value) {
                          selectedService = value.toString();
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black45,
                          ),
                          iconSize: 24,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Comments',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(15),
                child: TextFormField(
                  controller: _commentsController,
                  cursorColor: const Color.fromARGB(255, 49, 121, 46),
                  maxLines: 3,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'Enter Your Comments!',
                    hintStyle:
                        const TextStyle(fontSize: 18, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 49, 121, 46), width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(15),
                child: TextFormField(
                  controller: _houseController,
                  cursorColor: const Color.fromARGB(255, 49, 121, 46),
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'House/Flat/Block No',
                    hintStyle:
                        const TextStyle(fontSize: 18, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 49, 121, 46), width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: const [
                  Text(
                    'Address',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    '(choosed from map)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(15),
                child: TextFormField(
                  enabled: false,
                  controller: _addressController,
                  cursorColor: const Color.fromARGB(255, 49, 121, 46),
                  maxLines: 3,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'Apartment/Road/Area',
                    hintStyle:
                        const TextStyle(fontSize: 18, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 49, 121, 46), width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 12, left: 40, right: 40),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 5),
                    onPressed: _pickDate,
                    child: Text(
                      _selectedDate == null
                          ? 'Date'
                          : _formatDate(_selectedDate),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 12, left: 40, right: 40),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 5),
                    onPressed: _pickTime,
                    child: Text(
                      _selectedTime == null
                          ? 'Time'
                          : _formatTime(_selectedTime),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Center(
                child: CustomElevatedButton(
                  isLoading: isUpdating,
                  onPressed: () {
                    _bookService();
                  },
                  text: 'Book',
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
