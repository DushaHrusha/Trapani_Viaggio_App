import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/base_colors.dart';
import '../core/constants/custom_gradient_button.dart';
import '../core/constants/grey_line.dart';

class DatesGuestsScreen extends StatefulWidget {
  const DatesGuestsScreen({super.key});

  @override
  _DatesGuestsScreenState createState() => _DatesGuestsScreenState();
}

class _DatesGuestsScreenState extends State<DatesGuestsScreen> {
  String _checkInDate = '--/--/----';
  String _checkOutDate = '--/--/----';
  double _minPrice = 40;
  double _maxPrice = 100;
  static const double _absoluteMin = 0;
  static const double _absoluteMax = 200;
  static const _greyColor = Color.fromARGB(255, 109, 109, 109);
  static const _lightGreyColor = Color.fromARGB(255, 189, 189, 189);

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
        if (isCheckIn) {
          _checkInDate = formattedDate;
        } else {
          _checkOutDate = formattedDate;
        }
      });
    }
  }

  Widget _buildDateSelector(String label, String date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: _greyColor)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onTap,
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
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _greyColor,
                  ),
                ),
                Icon(
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

  Widget _buildGuestContainer(String text) {
    return Container(
      height: 40,
      width: 119,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: _greyColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      title: Column(
        children: [
          Container(
            width: 314,
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close, size: 32, color: BaseColors.background),
            ),
          ),
          Container(
            width: 297,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: BaseColors.background,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Dates and Guests',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: _greyColor,
                  ),
                ),
                const SizedBox(height: 24),
                GreyLine(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 37),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDateSelector(
                            'Check-in',
                            _checkInDate,
                            () => _selectDate(context, true),
                          ),
                          _buildDateSelector(
                            'Check-out',
                            _checkOutDate,
                            () => _selectDate(context, false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 17),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Guests',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _greyColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildGuestContainer('2 adults  '),
                            ],
                          ),
                          _buildGuestContainer('1 child'),
                        ],
                      ),
                      const SizedBox(height: 48),
                      Divider(
                        height: 1,
                        color: Color.fromARGB(255, 224, 224, 224),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 71,
                            child: Text(
                              'Price range per night',
                              style: TextStyle(fontSize: 12, color: _greyColor),
                            ),
                          ),
                          Text(
                            '${_minPrice.toInt()} € — ${_maxPrice.toInt()} €',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              color: _greyColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 1,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                          ),
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 0,
                          ),
                          activeTrackColor: _lightGreyColor,
                          inactiveTrackColor: Color.fromARGB(
                            255,
                            224,
                            224,
                            224,
                          ),
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
                      ),
                      const SizedBox(height: 46),
                      CustomGradientButton(text: "Go", path: "/sign-up"),
                      const SizedBox(height: 41),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
