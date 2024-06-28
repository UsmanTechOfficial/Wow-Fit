part of 'widget.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
    required this.monthDate,
    this.margin = const EdgeInsets.only(
      left: 16.0,
      right: 8.0,
      top: 4.0,
      bottom: 4.0,
    ),
    this.onPressed,
    this.dateStyle,
    this.todayStyle,
    this.callback,
    required this.dateFormatter,
  }) : super(key: key);

  // static final _dateFormatter = DateFormat().add_yMMM();//jan 2022
  final dateFormatter; //jan 2022
  final DateTime monthDate;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onPressed;
  final void Function(DateTime)? callback;
  final TextStyle? dateStyle;
  final TextStyle? todayStyle;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.callback != null) widget.callback!(widget.monthDate);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Text(
              widget.dateFormatter.format(widget.monthDate),
              style: widget.dateStyle ?? theme.textTheme.subtitle1!,
            ),
          ),
          InkWell(
            onTap: widget.onPressed,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
              ),
              child: SizedBox(
                height: 25,
                width: 25,
                child: Image.asset(
                  'assets/calendar_icon.png',
                  color: Color(0xFF130F26),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
