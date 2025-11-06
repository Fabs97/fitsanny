import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormStepper extends StatefulWidget {
  final String name;
  final String label;
  final num step;
  final num initialValue;
  final bool isInteger;

  const FormStepper({
    required this.name,
    required this.label,
    this.step = 0.1,
    this.initialValue = 0,
    this.isInteger = false,
    super.key,
  });

  @override
  State<FormStepper> createState() => _FormStepperState();
}

class _FormStepperState extends State<FormStepper> {
  late TextEditingController _controller;
  late num _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller = TextEditingController(text: _formatValue(_currentValue));
  }

  String _formatValue(num value) {
    return widget.isInteger
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }

  void _increment() {
    setState(() {
      _currentValue += widget.step;
      if (widget.isInteger) {
        _currentValue = _currentValue.toInt();
      }
      _controller.text = _formatValue(_currentValue);
    });
  }

  void _decrement() {
    setState(() {
      _currentValue = (_currentValue - widget.step).clamp(0, double.infinity);
      if (widget.isInteger) {
        _currentValue = _currentValue.toInt();
      }
      _controller.text = _formatValue(_currentValue);
    });
  }

  void _onChanged(String value) {
    final val = widget.isInteger ? int.tryParse(value) : double.tryParse(value);
    if (val != null && val >= 0) {
      _currentValue = val;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<num>(
      name: widget.name,
      initialValue: _currentValue,
      validator: (val) => val == null || val < 0 ? 'Invalid number' : null,
      builder: (field) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
            border: const OutlineInputBorder(),
            errorText: field.errorText,
          ),
          child: Row(
            children: [
              _buildIconButton(Icons.remove, _decrement, field),
              Expanded(
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: (val) {
                    _onChanged(val);
                    field.didChange(_currentValue);
                  },
                  onEditingComplete: () {
                    // Format the text after editing
                    _controller.text = _currentValue.toStringAsFixed(1);
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              _buildIconButton(Icons.add, _increment, field),
            ],
          ),
        );
      },
    );
  }

  IconButton _buildIconButton(
    IconData icon,
    VoidCallback callback,
    FormFieldState<num> field,
  ) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(icon),
      onPressed: () {
        callback();
        field.didChange(_currentValue);
      },
    );
  }
}
