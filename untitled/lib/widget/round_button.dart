import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool dbReport;
  const RoundButton({
    super.key,
    required this.onTap,
    this.dbReport=false,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: dbReport?
        const CircularProgressIndicator(strokeWidth: 3,color: Colors.white,):
        Text(title,style: const TextStyle(color: Colors.white),),),
      ),
    );
  }
}
