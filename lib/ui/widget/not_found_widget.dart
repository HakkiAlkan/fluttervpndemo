import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttervpndemo/core/service/theme/theme_helper.dart';
import 'package:fluttervpndemo/ui/helper/ui_helpers.dart';
import 'package:lottie/lottie.dart';

class NotFoundWidget extends StatefulWidget {
  const NotFoundWidget({
    super.key,
    this.title,
    this.subTitle,
    this.notTitle = false,
    this.notImage = false,
    this.mainAxisSize,
  });

  final String? title;
  final String? subTitle;
  final bool notTitle;
  final bool notImage;
  final MainAxisSize? mainAxisSize;

  @override
  State<NotFoundWidget> createState() => _NotFoundWidgetState();
}

class _NotFoundWidgetState extends State<NotFoundWidget> {
  late final Future<LottieComposition> _composition;

  @override
  void initState() {
    super.initState();
    _composition = _loadComposition();
  }

  Future<LottieComposition> _loadComposition() async {
    return UIHelper.getCompositionByNotFound();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LottieComposition>(
      future: _composition,
      builder: (context, snapshot) {
        var composition = snapshot.data;
        if (composition != null) {
          return Column(mainAxisSize: widget.mainAxisSize ?? MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
            widget.notImage ? Container() : Center(child: Lottie(composition: composition)),
            widget.notTitle ? Container() : Text(widget.title ?? 'Opps!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: FontSizeValue.normal, color: context.customColorScheme.txtDarkGrey)),
            const SizedBox(height: 3),
            Text(widget.subTitle ?? "Gösterilecek herhangi bir kayıt bulunamadı", textAlign: TextAlign.center, style: TextStyle(fontSize: FontSizeValue.normal, color: context.customColorScheme.txtDarkGrey)),
            const SizedBox(height: 3),
          ]);
        } else {
          return Center(child: SpinKitRing(color: context.colorScheme.primary.withOpacity(0.5), size: 30.r));
        }
      },
    );
  }
}
