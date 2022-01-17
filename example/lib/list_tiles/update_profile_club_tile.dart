import 'package:example/club.dart';
import 'package:flutter/material.dart';

class UpdateProfileClubTile extends StatelessWidget {
  const UpdateProfileClubTile({
    Key? key,
    required this.onTap,
    required this.currentClub,
    required this.isSelected,
    required this.showSeparator,
  }) : super(key: key);
  final void Function() onTap;
  final Club currentClub;
  final bool isSelected;
  final bool showSeparator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          // setState(() {
          //   selected = currentValue;
          // });
          // onListTapHandler(currentValue);
          // },
          child: Container(
            key: UniqueKey(),
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor : Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isSelected
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.cases_outlined,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    currentClub.name,
                    style: TextStyle(
                      fontSize: 15.45,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showSeparator) ...{
          const Divider(),
        }
      ],
    );
  }
}
