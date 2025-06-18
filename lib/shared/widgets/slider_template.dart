import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TemplateSlider extends StatefulWidget {
  final String label; // New: Label for the slider
  final Color color;
  final int divisions;
  final double min;
  final double max;
  final double initialValue;
  final ValueChanged<double> onChanged;

  const TemplateSlider({
    super.key,
    required this.label, // Required label
    required this.color,
    required this.divisions,
    required this.min,
    required this.max,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  _TemplateSliderState createState() => _TemplateSliderState();
}

class _TemplateSliderState extends State<TemplateSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "${widget.label}: ${_currentValue.toStringAsFixed(1)}", // Label with current value
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: kIsWeb
              ? const EdgeInsets.symmetric(horizontal: 350)
              : const EdgeInsets.symmetric(horizontal: 25),
          child: Slider(
            value: _currentValue,
            min: widget.min,
            max: widget.max,
            divisions: widget.divisions,
            activeColor: widget.color,
            inactiveColor: widget.color.withOpacity(0.3),
            onChanged: (val) {
              setState(() {
                _currentValue = val;
              });
              widget.onChanged(val);
            },
          ),
        ),
      ],
    );
  }
}
