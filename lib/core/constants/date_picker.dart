import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trapani_viaggio_app/core/constants/grey_line.dart';

import 'base_colors.dart';
import 'custom_gradient_button.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({super.key});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  static const double _absoluteMin = 0;
  static const double _absoluteMax = 200;
  static const String _placeholder = '--/--/----';
  static const _greyColor = Color.fromARGB(255, 109, 109, 109);
  static const _lightGreyColor = Color.fromARGB(255, 189, 189, 189);
  static const _borderColor = Color.fromARGB(255, 224, 224, 224);

  DateTime? _startDate;
  DateTime? _endDate;
  double _minPrice = 40;
  double _maxPrice = 100;

  Future<void> _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => isStart ? _startDate = picked : _endDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildCloseButton(), _buildDialogContent()],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Container(
      width: 314,
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.close, size: 32, color: BaseColors.background),
      ),
    );
  }

  Widget _buildDialogContent() {
    return Container(
      width: 297,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: BaseColors.background,
      ),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 41),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(),
          const SizedBox(height: 24),
          const GreyLine(),
          const SizedBox(height: 37),
          _buildDateFields(),
          const SizedBox(height: 48),
          const GreyLine(),
          const SizedBox(height: 22),
          _buildPriceSection(),
          const SizedBox(height: 126),
          const CustomGradientButton(text: "Go", path: "/sign-up"),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Booking Dates',
      style: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: _greyColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDateFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateField("Start", _startDate, true),
        const SizedBox(width: 8),
        _buildDateField("Finish", _endDate, false),
      ],
    );
  }

  Widget _buildDateField(String label, DateTime? date, bool isStart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _greyColor,
          ),
        ),
        GestureDetector(
          onTap: () => _selectDate(isStart),
          child: Container(
            height: 40,
            width: 119,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date != null
                      ? DateFormat('dd/MM/yyyy').format(date)
                      : _placeholder,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _greyColor,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: _lightGreyColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: _greyColor,
              ),
            ),
            Text(
              '${_minPrice.toInt()} € — ${_maxPrice.toInt()} €',
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: _greyColor,
              ),
            ),
          ],
        ),
        _buildPriceSlider(),
      ],
    );
  }

  Widget _buildPriceSlider() {
    return SliderTheme(
      data: const SliderThemeData(
        trackHeight: 1,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 8,
          disabledThumbRadius: 8,
        ),
        trackShape: RoundedRectSliderTrackShape(),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
        activeTrackColor: _lightGreyColor,
        inactiveTrackColor: _borderColor,
        thumbColor: Color.fromARGB(221, 224, 224, 224),
      ),
      child: RangeSlider(
        values: RangeValues(_minPrice, _maxPrice),
        min: _absoluteMin,
        max: _absoluteMax,
        divisions: (_absoluteMax - _absoluteMin).toInt(),
        onChanged: (values) => setState(() {
          _minPrice = values.start;
          _maxPrice = values.end;
        }),
      ),
    );
  }
}
