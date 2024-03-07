import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final List<T> items;
  final T selectedItem;
  final String label;
  final IconData iconPrefix;
  final FormFieldValidator<T> validator;
  final FormFieldSetter<T> onSaved;

  const CustomDropdownButton({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.label,
    required this.iconPrefix,
    required this.validator,
    required this.onSaved, required Function(dynamic value) onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: selectedItem,
      validator: validator,
      onSaved: onSaved,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            InputDecorator(
              decoration: InputDecoration(
                prefixIcon: Icon(iconPrefix),
                errorText: state.hasError ? state.errorText : null,
                border: UnderlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  value: state.value,
                  items: items.map((item) {
                    return DropdownMenuItem(
                      child: Text(item.toString()),
                      value: item,
                    );
                  }).toList(),
                  onChanged: (value) {
                    state.didChange(value);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
