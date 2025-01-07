import 'package:flutter/material.dart';
import 'package:studiosync/core/presentation/theme/app_style.dart';

class DateSelectionContainer extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;
  final Color? bacColor;
  final Color? txxColor;

  const DateSelectionContainer(
      {super.key,
      this.initialDate,
      this.onDateSelected,
      this.bacColor,
      this.txxColor});

  @override
  _DateSelectionContainerState createState() => _DateSelectionContainerState();
}

class _DateSelectionContainerState extends State<DateSelectionContainer> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2029),
    );

    if (picked != null) {
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _selectDate(context);
          },
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.bacColor ?? AppStyle.backGrey2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              selectedDate != null
                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : widget.initialDate != null
                      ? '${widget.initialDate!.day}/${widget.initialDate!.month}/${widget.initialDate!.year}'
                      : 'Select Date',
              style: TextStyle(
                color: widget.txxColor ?? AppStyle.backGrey3.withOpacity(0.8),
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
