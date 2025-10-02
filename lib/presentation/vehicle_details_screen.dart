import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../bloc/cubits/vehicle_cubit.dart';
import '../bloc/state/vehicle_state.dart';
import '../core/adaptive_size_extension.dart';
import '../core/constants/bottom_bar.dart';
import '../core/constants/custom_app_bar.dart';
import '../core/constants/custom_background_with_gradient.dart';
import '../core/constants/custom_text_field_with_gradient_button.dart';
import '../core/constants/date_picker.dart';
import '../core/constants/grey_line.dart';
import '../data/models/vehicle.dart';
import '../data/repositories/vehicle_repository.dart';

class _AnimationTiming {
  final double start;
  final double end;
  const _AnimationTiming(this.start, this.end);
}

class VehicleAnimations {
  final AnimationController controller;

  static const _timings = {
    'appBar': _AnimationTiming(0.17, 0.33),
    'header': _AnimationTiming(0.33, 0.5),
    'content': _AnimationTiming(0.5, 0.67),
    'bottom': _AnimationTiming(0.33, 0.5),
  };

  VehicleAnimations(this.controller);

  Animation<double> _fade(String key) {
    final timing = _timings[key]!;
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(timing.start, timing.end, curve: Curves.easeOut),
      ),
    );
  }

  Animation<Offset> _slide(String key, Offset begin) {
    final timing = _timings[key]!;
    return Tween<Offset>(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(timing.start, timing.end, curve: Curves.easeOut),
      ),
    );
  }

  late final appBar = _fade('appBar');
  late final header = _fade('header');
  late final content = _fade('content');
  late final imageSlide = _slide('content', const Offset(1, 0));
  late final bottomBarSlide = _slide('bottom', const Offset(0, 1));
}

class VehicleDetailsScreen extends StatefulWidget {
  final VehicleRepository vehicleRepository;
  final String label;

  const VehicleDetailsScreen({
    super.key,
    required this.vehicleRepository,
    required this.label,
  });

  @override
  createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen>
    with SingleTickerProviderStateMixin {
  static const _greyColor = Color.fromARGB(255, 130, 130, 130);
  static const _darkGreyColor = Color.fromARGB(255, 109, 109, 109);
  static const _accentColor = Color.fromARGB(255, 255, 127, 80);
  static const _lightBlueColor = Color.fromARGB(255, 85, 97, 178);
  static const _borderColor = Color.fromARGB(255, 224, 224, 224);

  static const _vehicleIcons = {
    'type_transmission': 'assets/icons/Automatic.svg',
    'number_seats': 'assets/icons/Seats.svg',
    'type_fuel': 'assets/icons/Gasoline.svg',
    'insurance': 'assets/icons/Insurance.svg',
  };

  late final AnimationController _animController;
  late final VehicleAnimations _animations;
  late final PageController _pageController;

  String _selectedDateRange = '--/--/----';
  int _currentIndex = 0;
  int _sumDays = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _animations = VehicleAnimations(_animController);
    _pageController = PageController();
    context.read<VehicleCubit>().loadExcursions(widget.vehicleRepository);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateVehicle(bool isNext, int maxIndex) {
    if ((isNext && _currentIndex < maxIndex) ||
        (!isNext && _currentIndex > 0)) {
      if (isNext) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        if (state is VehicleInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! VehicleLoaded) return const SizedBox.shrink();

        final vehicles = state.vehicles;
        return Scaffold(
          body: CustomBackgroundWithGradient(
            child: Column(
              children: [
                _buildAnimatedHeader(),
                _buildVehicleContent(vehicles),
                const Spacer(),
                _buildDateSelector(),
                const Spacer(),
                _buildBookingPanel(),
                const Spacer(),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomBar(),
        );
      },
    );
  }

  Widget _buildAnimatedHeader() {
    return Column(
      children: [
        FadeTransition(
          opacity: _animations.appBar,
          child: CustomAppBar(label: widget.label),
        ),
        FadeTransition(opacity: _animations.appBar, child: GreyLine()),
      ],
    );
  }

  Widget _buildVehicleContent(List<Vehicle> vehicles) {
    final vehicle = vehicles[_currentIndex];

    return Column(
      children: [
        _buildNavigationHeader(vehicles.length - 1),
        SizedBox(height: context.adaptiveSize(27)),
        _buildVehicleInfo(vehicle),
        _buildVehicleImage(vehicles),
        SizedBox(height: context.adaptiveSize(16)),
        _buildSpecsList(vehicle),
      ],
    );
  }

  Widget _buildNavigationHeader(int maxIndex) {
    return FadeTransition(
      opacity: _animations.header,
      child: Padding(
        padding: EdgeInsets.only(
          top: context.adaptiveSize(20),
          left: context.adaptiveSize(10),
          right: context.adaptiveSize(10),
        ),
        child: SizedBox(
          height: context.adaptiveSize(26),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavButton(
                Icons.chevron_left,
                () => _navigateVehicle(true, maxIndex),
              ),
              Text(
                'Select vehicle',
                style: context.adaptiveTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _greyColor,
                ),
              ),
              _buildNavButton(
                Icons.chevron_right,
                () => _navigateVehicle(false, maxIndex),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(icon, size: 28, color: const Color.fromRGBO(189, 189, 189, 1)),
      onPressed: onPressed,
    );
  }

  Widget _buildVehicleInfo(Vehicle vehicle) {
    return FadeTransition(
      opacity: _animations.content,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnimatedRow(vehicle.year.toString(), 'from:', _greyColor),
            SizedBox(height: context.adaptiveSize(7)),
            _buildAnimatedRow(
              vehicle.brand,
              '${vehicle.pricePerHour} €',
              _accentColor,
              fontSize: 24,
            ),
            SizedBox(height: context.adaptiveSize(8)),
            _buildAnimatedText(
              'Max speed: ${vehicle.maxSpeed} km/h',
              _greyColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedRow(
    String left,
    String right,
    Color rightColor, {
    double fontSize = 14,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      child: Row(
        key: ValueKey('$left-$right'),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            left,
            style: context.adaptiveTextStyle(
              fontSize: fontSize,
              fontWeight: fontSize > 14 ? FontWeight.w700 : FontWeight.w400,
              color: fontSize > 14 ? _darkGreyColor : _greyColor,
            ),
          ),
          Text(
            right,
            style: context.adaptiveTextStyle(
              fontSize: fontSize,
              fontWeight: fontSize > 14 ? FontWeight.w700 : FontWeight.w400,
              color: rightColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedText(String text, Color color) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      child: Text(
        key: ValueKey(text),
        text,
        style: context.adaptiveTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: color,
        ),
      ),
    );
  }

  Widget _buildVehicleImage(List<Vehicle> vehicles) {
    return SlideTransition(
      position: _animations.imageSlide,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: context.adaptiveSize(212),
            margin: EdgeInsets.symmetric(horizontal: context.adaptiveSize(30)),
            child: SvgPicture.asset(
              'assets/icons/form-bg.svg',
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fill(
            child: SizedBox(
              height: context.adaptiveSize(210),
              child: PageView.builder(
                controller: _pageController,
                itemCount: vehicles.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) => Image.asset(
                  vehicles[index].image,
                  fit: BoxFit.contain,
                  height: context.adaptiveSize(210),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsList(Vehicle vehicle) {
    return SlideTransition(
      position: _animations.imageSlide,
      child: SizedBox(
        height: context.adaptiveSize(80),
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          children: [
            _buildSpecCircle(vehicle.type_transmission, 'type_transmission'),
            SizedBox(width: context.adaptiveSize(24)),
            _buildSpecCircle('${vehicle.number_seats} Seats', 'number_seats'),
            SizedBox(width: context.adaptiveSize(24)),
            _buildSpecCircle(vehicle.type_fuel, 'type_fuel'),
            SizedBox(width: context.adaptiveSize(24)),
            _buildSpecCircle(vehicle.insurance, 'insurance'),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecCircle(String label, String iconKey) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      child: Container(
        key: ValueKey('$_currentIndex-$iconKey'),
        width: context.adaptiveSize(80),
        height: context.adaptiveSize(80),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 235, 241, 244),
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(_vehicleIcons[iconKey]!, color: _lightBlueColor),
            SizedBox(height: context.adaptiveSize(6)),
            Text(
              label,
              style: context.adaptiveTextStyle(
                fontSize: 10,
                color: _lightBlueColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return FadeTransition(
      opacity: _animations.content,
      child: Container(
        height: context.adaptiveSize(56),
        margin: EdgeInsets.symmetric(horizontal: context.adaptiveSize(30)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.adaptiveSize(30)),
          border: Border.all(color: _borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Choose dates:',
                  style: context.adaptiveTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _darkGreyColor,
                  ),
                ),
              ),
            ),
            Container(
              height: context.adaptiveSize(56),
              width: 1,
              color: _borderColor,
            ),
            SizedBox(
              width: context.adaptiveSize(170),
              child: GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => DatePickerWidget(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _selectedDateRange,
                      style: context.adaptiveTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _darkGreyColor,
                      ),
                    ),
                    SizedBox(width: context.adaptiveSize(8)),
                    Icon(
                      Icons.calendar_today,
                      size: context.adaptiveSize(16),
                      color: _darkGreyColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingPanel() {
    return FadeTransition(
      opacity: _animations.content,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.adaptiveSize(30)),
        child: CustomTextFieldWithGradientButton(
          text: "${49 * _sumDays} € / $_sumDays days",
          style: context.adaptiveTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _darkGreyColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return SlideTransition(
      position: _animations.bottomBarSlide,
      child: BottomBar(currentScreen: widget),
    );
  }
}
