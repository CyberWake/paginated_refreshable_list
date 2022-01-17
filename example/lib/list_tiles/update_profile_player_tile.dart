import 'package:example/player.dart';
import 'package:flutter/material.dart';

class UpdateProfilePlayerTile extends StatelessWidget {
  const UpdateProfilePlayerTile({
    Key? key,
    required this.onTap,
    required this.currentPlayer,
    required this.isSelected,
    required this.showSeparator,
  }) : super(key: key);
  final void Function() onTap;
  final Player currentPlayer;
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
                      Icons.person,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    "${currentPlayer.firstName}\n${currentPlayer.lastName}",
                    style: TextStyle(
                      fontSize: 15.45,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'HCP ${currentPlayer.handicap}',
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  )
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
