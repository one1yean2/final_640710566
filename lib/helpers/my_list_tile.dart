import 'package:flutter/material.dart';

class MyListTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final int index;
  final int selectedIndex;
  final ValueChanged<int>? onSelect;

  MyListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.index,
    required this.selectedIndex,
    this.onSelect,
  }) : super(key: key);

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        if (widget.onSelect != null) {
          widget.onSelect!(widget.index);
        }
      },
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: widget.selectedIndex == widget.index ? colorScheme.primary.withOpacity(0.8) : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: Container(
                    width: 100.0,
                    height: 80.0,
                    child: Image.network(widget.imageUrl),
                  ),
                ),
                SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: textTheme.bodyText1),
                    SizedBox(height: 4.0),
                    Text(widget.subtitle),
                  ],
                ),
              ],
            ),
            if (widget.selectedIndex == widget.index)
              Positioned(
                top: 8.0,
                right: 8.0,
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16.0),
                ),
              )
          ],
        ),
      ),
    );
  }
}
