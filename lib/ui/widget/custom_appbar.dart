import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttervpndemo/base/helper/debouncer/debouncer.dart';
import 'package:fluttervpndemo/core/service/theme/theme_helper.dart';
import 'package:fluttervpndemo/generated/assets.dart';
import 'package:fluttervpndemo/ui/helper/ui_helpers.dart';
import 'package:fluttervpndemo/ui/widget/svg_button.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.showSearchBar,
    required this.searchBarController,
    required this.onChanged,
    this.debouncerMilliseconds = 250,
    required this.categoryOnTap,
    required this.crownOnTap,
  });

  final String title;
  final bool showSearchBar;
  final TextEditingController searchBarController;
  final void Function(String?) onChanged;
  final int debouncerMilliseconds;
  final VoidCallback categoryOnTap;
  final VoidCallback crownOnTap;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool deleteBtn = false;
  late final Debouncer searchDebouncer;

  @override
  void initState() {
    super.initState();
    searchDebouncer = Debouncer(milliseconds: widget.debouncerMilliseconds);
    widget.searchBarController.addListener(_suffixIconListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.searchBarController.removeListener(_suffixIconListener);
  }

  void _suffixIconListener() => setState(() => deleteBtn = widget.searchBarController.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 110),
      height: widget.showSearchBar ? 190.h + MediaQuery.of(context).padding.top : 105.h + MediaQuery.of(context).padding.top,
      decoration: const BoxDecoration(
        image: DecorationImage(alignment: Alignment.bottomCenter, image: AssetImage(Assets.imagesAppbarBackground), fit: BoxFit.cover),
        color: Colors.transparent,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 38.h + MediaQuery.of(context).padding.top, left: 32.w, right: 32.w),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgButton(
                    svgPath: Assets.svgCategory,
                    onTap: widget.categoryOnTap,
                    svgColor: context.customColorScheme.alwaysWhite,
                    backgroundColor: context.colorScheme.primaryContainer,
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: FontSizeValue.large,
                      fontWeight: FontWeight.w600,
                      color: context.customColorScheme.alwaysWhite,
                    ),
                  ),
                  SvgButton(
                    svgPath: Assets.svgCrown,
                    onTap: widget.crownOnTap,
                    svgColor: context.customColorScheme.alwaysWhite,
                    backgroundColor: context.colorScheme.primaryContainer,
                  ),
                ],
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 85),
                opacity: widget.showSearchBar ? 1 : 0,
                curve: Curves.easeIn,
                child: Padding(
                  padding: EdgeInsets.only(top: 24.h),
                  child: SearchBar(
                    shadowColor: WidgetStatePropertyAll(context.customColorScheme.shadowColor),
                    elevation: const WidgetStatePropertyAll(0),
                    controller: widget.searchBarController,
                    onChanged: (value) async => await searchDebouncer.run(() => widget.onChanged(value)),
                    textInputAction: TextInputAction.done,
                    hintText: 'Search For Country or City',
                    hintStyle: WidgetStatePropertyAll(TextStyle(fontSize: FontSizeValue.normal, color: context.customColorScheme.txtGrey)),
                    backgroundColor: WidgetStatePropertyAll(context.customColorScheme.white),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))),
                    textStyle: WidgetStateProperty.resolveWith((states) => TextStyle(fontSize: FontSizeValue.normal)),
                    trailing: [
                      deleteBtn
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                size: 20.r,
                                color: context.customColorScheme.black,
                              ),
                              onPressed: () async {
                                widget.searchBarController.clear();
                                widget.onChanged(null);
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            )
                          : Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: SvgPicture.asset(
                                Assets.svgSearch,
                                height: UIHelper.defaultSquareIconSize,
                                width: UIHelper.defaultSquareIconSize,
                                colorFilter: ColorFilter.mode(
                                  context.customColorScheme.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
