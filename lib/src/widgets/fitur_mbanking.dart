import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbanking_app/src/theme/mbanking_typography.dart';

class FiturMbanking extends StatelessWidget {
  const FiturMbanking(
      {Key? key,
      required this.iconFitur,
      required this.textFitur,
      required this.onTap})
      : super(key: key);

  final String iconFitur;
  final String textFitur;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 45,
          width: 45,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: SvgPicture.asset(iconFitur),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          textFitur,
          textAlign: TextAlign.center,
          style: MbankingTypography.fiturText,
        )
      ],
    );
  }
}
