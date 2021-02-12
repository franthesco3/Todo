import 'package:flutter/material.dart';

class TimeComponent extends StatefulWidget {
  DateTime date;
  ValueChanged<DateTime> onSelectedTime;

  TimeComponent({
    Key key,
    this.date,
    this.onSelectedTime,
  }) : super(key: key);
  @override
  _TimeComponentState createState() => _TimeComponentState();
}

class _TimeComponentState extends State<TimeComponent> {
  final List<String> _horas = List.generate(25, (index) => index++)
      .map((h) => '${h.toString().padLeft(2, '0')}')
      .toList();

  final List<String> _minutos = List.generate(61, (index) => index++)
      .map((m) => '${m.toString().padLeft(2, '0')}')
      .toList();

  final List<String> _segundos = List.generate(61, (index) => index++)
      .map((s) => '${s.toString().padLeft(2, '0')}')
      .toList();

  String _horaSelected = '00';
  String _minutoSelected = '00';
  String _segundoSelected = '00';

  void invokeCallBack() {
    var newDate = DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        int.parse(_horaSelected),
        int.parse(_minutoSelected),
        int.parse(_segundoSelected));

    widget.onSelectedTime(newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildBox(_horas, (value) {
            setState(() {
              _horaSelected = value;
              invokeCallBack();
            });
          }),
          _buildBox(_minutos, (value) {
            setState(() {
              _minutoSelected = value;
              invokeCallBack();
            });
          }),
          _buildBox(_segundos, (value) {
            setState(() {
              _segundoSelected = value;
              invokeCallBack();
            });
          }),
        ],
      ),
    );
  }

  Widget _buildBox(List<String> horas, ValueChanged<String> onChange) {
    return Container(
      height: 120,
      width: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                spreadRadius: 0,
                color: Theme.of(context).primaryColor,
                offset: Offset(2, 5))
          ]),
      child: ListWheelScrollView(
        itemExtent: 60,
        perspective: 0.007,
        onSelectedItemChanged: (value) =>
            onChange(value.toString().padLeft(2, '0')),
        physics: FixedExtentScrollPhysics(),
        children: horas
            .map<Text>((h) => Text(
                  h,
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ))
            .toList(),
      ),
    );
  }
}
