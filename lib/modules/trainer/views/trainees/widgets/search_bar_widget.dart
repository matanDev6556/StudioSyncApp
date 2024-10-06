import 'package:flutter/material.dart';
import 'package:studiosync/core/shared/widgets/custom_text_field.dart';
import 'package:studiosync/core/theme/app_style.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onFilterChanged;
  final String dropdownValue;

  const SearchBarWidget({
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.dropdownValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              icon: Icon(
                Icons.search,
                color: AppStyle.backGrey3,
              ),
              hintText: 'Search..',
              hintColor: AppStyle.backGrey3,
              fill: true,
              color: AppStyle.backGrey,
              onChanged: (val) => onSearchChanged(val),
            ),
          ),
          const SizedBox(width: 8.0),
          DropdownButton<String>(
            value: dropdownValue,
            items: ['All', 'Active', 'Inactive']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onFilterChanged,
          ),
        ],
      ),
    );
  }
}
