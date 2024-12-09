import 'dart:developer';

import 'package:fetch_custom_form/api_services.dart';
import 'package:fetch_custom_form/model.dart';
import 'package:flutter/material.dart';

class FetchformScreen extends StatefulWidget {
  const FetchformScreen({super.key});

  @override
  State<FetchformScreen> createState() => _FetchformScreenState();
}

class _FetchformScreenState extends State<FetchformScreen> {
  late Future<CustomFormModel> _futureData;

  // Controllers for Text Fields and Date Pickers
  final Map<String, TextEditingController> controllers = {};

  // Store selected values for Dropdowns
  final Map<String, String> dropdownValues = {};

  @override
  void initState() {
    super.initState();
    _futureData = ApiServices().fetchData();
  }

  @override
  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, String controllerKey) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        controllers[controllerKey]?.text =
            "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic Form with Dropdown"),
      ),
      body: FutureBuilder<CustomFormModel>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("No data available"),
            );
          }

          final formData = snapshot.data!;
          final formDetails = formData.data?.formDetails ?? [];

          return ListView(
            children: List.generate(
              formDetails.length,
              (index) {
                final singleRes = formDetails[index];

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: singleRes.sectionData?.length ?? 0,
                  itemBuilder: (context, i) {
                    final sectionData = singleRes.sectionData![i];

                    // Unique key for each controller or dropdown value
                    final controllerKey = "controller_${index}_$i";

                    // Initialize controller if it doesn't exist
                    if (!controllers.containsKey(controllerKey)) {
                      controllers[controllerKey] = TextEditingController();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (sectionData.typeOfWidget == "Text Field")
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextField(
                              controller: controllers[controllerKey],
                              decoration: InputDecoration(
                                labelText: sectionData.label ?? "Enter text",
                              ),
                            ),
                          ),
                        if (sectionData.typeOfWidget == "Date Picker")
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextField(
                              controller: controllers[controllerKey],
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: sectionData.label ?? "Select a date",
                                suffixIcon: const Icon(Icons.calendar_today),
                              ),
                              onTap: () => _selectDate(context, controllerKey),
                            ),
                          ),
                        if (sectionData.typeOfWidget == "Drop Down")
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: DropdownButtonFormField<String>(
                              value: dropdownValues[controllerKey],
                              items: List.generate(sectionData.options!.length,
                                  (index) {
                                return DropdownMenuItem(
                                    value: sectionData.options![index],
                                    child: Text(sectionData.options![index]));
                              }),
                              onChanged: (value) {
                                setState(() {
                                  dropdownValues[controllerKey] = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText:
                                    sectionData.heading ?? "Select an option",
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
