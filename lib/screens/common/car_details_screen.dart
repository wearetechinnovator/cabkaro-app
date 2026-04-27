import 'package:cabkaro/controllers/car_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cabkaro/widgets/gradient_background.dart';
import 'package:cabkaro/widgets/action_button.dart';
import 'package:cabkaro/widgets/signup_input.dart';
import 'package:provider/provider.dart';

class CarDetailsScreenScreen extends StatefulWidget {
  const CarDetailsScreenScreen({super.key});

  @override
  State<CarDetailsScreenScreen> createState() => _CarDetailsScreenScreenState();
}

class _CarDetailsScreenScreenState extends State<CarDetailsScreenScreen> {
  Widget _buildRadioButton(
    String title,
    String currentVal,
    Function(String?) onChange,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text("Yes"),
                value: "Yes",
                groupValue: currentVal,
                activeColor: const Color(0xFFF2CA2A),
                onChanged: onChange,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text("No"),
                value: "No",
                groupValue: currentVal,
                activeColor: const Color(0xFFF2CA2A),
                onChanged: onChange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSeaterSelector(int index) {
    final car = Provider.of<CarDetailsController>(
      context,
      listen: false,
    ).cars[index];
    final options = ['2', '4', '5', '6', '7', '8', '10', '12+'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Number of Seats",
          style: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((seat) {
            final isSelected = car.seaterCount == seat;
            return GestureDetector(
              onTap: () => setState(() => car.seaterCount = seat),
              child: Container(
                width: 52,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFF2CA2A)
                      : const Color.fromARGB(25, 242, 202, 42),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey[300]!,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    seat,
                    style: GoogleFonts.oswald(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCarCard(int index) {
    final car = Provider.of<CarDetailsController>(
      context,
      listen: false,
    ).cars[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Car ${index + 1}",
                style: GoogleFonts.oswald(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (Provider.of<CarDetailsController>(
                    context,
                    listen: true,
                  ).cars.length >
                  1)
                IconButton(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => Provider.of<CarDetailsController>(
                    context,
                    listen: false,
                  ).removeCar(index),
                ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
          SignupInput(
            hint: 'Car Number',
            icon: Icons.directions_car,
            controller: car.carNumberController,
          ),
          const SizedBox(height: 20),

          _buildSeaterSelector(index),
          const SizedBox(height: 20),

          Text(
            "Car Image",
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => Provider.of<CarDetailsController>(
              context,
              listen: false,
            ).pickImage(index),
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(25, 242, 202, 42),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: car.carImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(car.carImage!, fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_upload_outlined,
                          size: 40,
                          color: Colors.black54,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Upload Photo",
                          style: GoogleFonts.nunitoSans(color: Colors.black54),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),
          _buildRadioButton(
            "Is AC Available?",
            car.isAc,
            (val) => setState(() => car.isAc = val!),
          ),
          _buildRadioButton(
            "Is SOS Facility?",
            car.isSos,
            (val) => setState(() => car.isSos = val!),
          ),
          _buildRadioButton(
            "Is First Aid Kit?",
            car.isFirstAid,
            (val) => setState(() => car.isFirstAid = val!),
          ),
          const SizedBox(height: 15),
          Text(
            "Other Facilities",
            style: GoogleFonts.nunitoSans(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: car.facilitiesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "E.g. WiFi, Water Bottles, Phone Charger",
              fillColor: const Color.fromARGB(46, 242, 202, 42),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        showGlow: false,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Vehicle Details",
                      style: GoogleFonts.oswald(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: Provider.of<CarDetailsController>(
                    context,
                    listen: false,
                  ).cars.length,
                  itemBuilder: (context, index) => _buildCarCard(index),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 119, 67, 67),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        label: 'Save All Vehicles',
                        backgroundColor: const Color(0xFF1F1F1F),
                        textColor: Colors.white,
                        borderColor: const Color(0xFF1F1F1F),
                        onTap: () {
                          Provider.of<CarDetailsController>(
                            context,
                            listen: false,
                          ).saveVehicle(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: Provider.of<CarDetailsController>(
                        context,
                        listen: false,
                      ).addNewCar,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2CA2A),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var car in Provider.of<CarDetailsController>(
      context,
      listen: false,
    ).cars) {
      car.dispose();
    }
    super.dispose();
  }
}
