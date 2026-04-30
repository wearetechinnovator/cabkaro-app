import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
<<<<<<< HEAD
import 'driver_home_screen.dart';
=======
import 'vendor_home_screen.dart';
>>>>>>> a64f8e0 (Edit vendor and user profile)
import '../../widgets/action_button.dart';
import '../../widgets/gradient_background.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/icons/cabkaroLogo.svg',
                    width: 205,
                    height: 86,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 28),
                const _TopDashedCurve(),
                const SizedBox(height: 40),
                Text(
                  'Upload Photos',
                  style: TextStyle(
                    fontSize: screenHeight * 0.056,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D2F35),
                    height: 1,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Upload Your Photo',
                  style: TextStyle(
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF3C3D42),
                  ),
                ),
                const SizedBox(height: 10),
                _PhotoUploadBox(
                  onTap: () => _showUploadHint(context, 'your photo'),
                ),
                const SizedBox(height: 24),
                Text(
                  'Upload Your Car Photo',
                  style: TextStyle(
                    fontSize: screenHeight * 0.03,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF3C3D42),
                  ),
                ),
                const SizedBox(height: 10),
                _PhotoUploadBox(
                  onTap: () => _showUploadHint(context, 'car photo'),
                ),
                const Spacer(),
                ActionButton(
                  label: 'Submit',
                  backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                  textColor: Colors.black,
                  borderColor: const Color(0xFF1F1F1F),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
<<<<<<< HEAD
                        builder: (context) => const DriverHomeScreen(),
=======
                        builder: (context) => const VendorHomeScreen(),
>>>>>>> a64f8e0 (Edit vendor and user profile)
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _showUploadHint(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2D2F35),
        content: Text('Upload $label'),
      ),
    );
  }
}

class _PhotoUploadBox extends StatefulWidget {
  const _PhotoUploadBox({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_PhotoUploadBox> createState() => _PhotoUploadBoxState();
}

class _PhotoUploadBoxState extends State<_PhotoUploadBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: 102,
        decoration: BoxDecoration(
          color: const Color(0x10FFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0x8F2D2F35),
            width: 1,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Center(
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFF2D2F35),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Color(0xFFF2F2F2), size: 26),
          ),
        ),
      ),
    );
  }
}

class _TopDashedCurve extends StatefulWidget {
  const _TopDashedCurve();

  @override
  State<_TopDashedCurve> createState() => _TopDashedCurveState();
}

class _TopDashedCurveState extends State<_TopDashedCurve> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: CustomPaint(painter: _DashedWavePainter()),
    );
  }
}

class _DashedWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0x6B9FB2BA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Path path = Path()
      ..moveTo(0, 45)
      ..quadraticBezierTo(size.width * 0.15, 28, size.width * 0.28, 42)
      ..quadraticBezierTo(size.width * 0.42, 56, size.width * 0.58, 38)
      ..quadraticBezierTo(size.width * 0.72, 25, size.width * 0.86, 36)
      ..quadraticBezierTo(size.width * 0.93, 42, size.width, 20);

    const double dashWidth = 5;
    const double dashSpace = 4;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double end = (distance + dashWidth).clamp(0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
