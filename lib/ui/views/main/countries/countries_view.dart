import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttervpndemo/core/controller/main/countries/countries_view_controller.dart';
import 'package:fluttervpndemo/core/enum/vpn_state.dart';
import 'package:fluttervpndemo/core/model/country/country_model.dart';
import 'package:fluttervpndemo/core/model/server/server_model.dart';
import 'package:fluttervpndemo/core/service/theme/theme_helper.dart';
import 'package:fluttervpndemo/core/service/vpn/vpn_service.dart';
import 'package:fluttervpndemo/generated/assets.dart';
import 'package:fluttervpndemo/ui/helper/base_view.dart';
import 'package:fluttervpndemo/ui/helper/ui_helpers.dart';
import 'package:fluttervpndemo/ui/widget/not_found_widget.dart';
import 'package:get/get.dart';

class CountriesView extends BaseView<CountriesViewController> {
  const CountriesView({super.key});

  @override
  CountriesViewController createController(BuildContext context) => CountriesViewController();

  @override
  Widget buildView(BuildContext context, CountriesViewController controller) {
    return Obx(
      () => controller.isBusy.value
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitRing(color: context.colorScheme.primary, size: 30.r),
                12.verticalSpace,
                Text(
                  'Yükleniyor...',
                  style: TextStyle(
                    fontSize: FontSizeValue.normal,
                    color: context.customColorScheme.txtDarkGrey,
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 0.1.sh),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const _ConnectionInfoCard(),
                  _LocationListWidget(
                    title: 'Free Locations',
                    dataList: controller.freeServerList,
                    onSelectedVpn: (CountryModel val, ServerModel sw) async => await Get.find<VpnService>().startVpn(val, sw),
                  ),
                ],
              ),
            ),
    );
  }
}

class _LocationListWidget extends StatefulWidget {
  const _LocationListWidget({required this.title, required this.dataList, required this.onSelectedVpn});

  final String title;
  final List<CountryModel> dataList;
  final Future<void> Function(CountryModel, ServerModel) onSelectedVpn;

  @override
  State<_LocationListWidget> createState() => _LocationListWidgetState();
}

class _LocationListWidgetState extends State<_LocationListWidget> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.title} (${widget.dataList.length})',
                  style: TextStyle(
                    fontSize: FontSizeValue.normal,
                    color: context.customColorScheme.txtDarkGrey,
                  ),
                ),
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: 'Bla bla bla bla',
                  child: Icon(
                    size: 15.r,
                    color: context.customColorScheme.txtGrey,
                    Icons.info_rounded,
                  ),
                ),
              ],
            ),
            4.verticalSpace,
            widget.dataList.where((element) => element.isVisible).toList().isEmpty
                ? const NotFoundWidget()
                : ListView.separated(
                    itemCount: widget.dataList.where((element) => element.isVisible).toList().length,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => 8.verticalSpace,
                    itemBuilder: (context, index) {
                      CountryModel model = widget.dataList.where((element) => element.isVisible).toList()[index];
                      return _LocationCard(model, (country, server) async => await widget.onSelectedVpn(country, server));
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class _LocationCard extends StatefulWidget {
  const _LocationCard(this.model, this.connectVpn);

  final CountryModel model;
  final Future<void> Function(CountryModel, ServerModel) connectVpn;

  @override
  State<_LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<_LocationCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => widget.model.isExpand = !widget.model.isExpand),
      child: Obx(
        () {
          var vpnService = Get.find<VpnService>();
          var connectionStat = vpnService.connectionStats.value;
          return Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: context.colorScheme.onSurfaceVariant,
              boxShadow: [
                BoxShadow(
                  color: context.customColorScheme.shadowColor.withOpacity(0.12),
                  blurRadius: 24,
                  spreadRadius: 0,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    widget.model.flag == null ? const SizedBox.shrink() : SvgPicture.asset(widget.model.flag!, height: 32.h, width: 42.w),
                    8.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.model.name ?? '-',
                            style: TextStyle(
                              fontSize: FontSizeValue.normal,
                              color: context.customColorScheme.txtDarkGrey,
                              fontWeight: FontWeight.w500,
                              height: 0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${widget.model.locationCount?.toString() ?? '0'} Locations',
                            style: TextStyle(
                              fontSize: FontSizeValue.small,
                              color: context.customColorScheme.txtGrey,
                              height: 0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    8.horizontalSpace,
                    GestureDetector(
                      onTap: () async {
                        final strongestServer = widget.model.serverList!.reduce((a, b) => a.strength! > b.strength! ? a : b);
                        await widget.connectVpn(widget.model, strongestServer);
                      },
                      child: SvgPicture.asset(
                        connectionStat?.connectedCountry?.id == widget.model.id ? Assets.svgOn : Assets.svgOff,
                        height: 28.h,
                        width: 28.h,
                        colorFilter: connectionStat?.connectedCountry?.id == widget.model.id ? null : ColorFilter.mode(context.customColorScheme.black, BlendMode.srcIn),
                      ),
                    ),
                    8.horizontalSpace,
                    GestureDetector(
                      onTap: () => setState(() => widget.model.isExpand = !widget.model.isExpand),
                      child: Transform.rotate(
                        angle: widget.model.isExpand ? 1.5708 : 0,
                        child: SvgPicture.asset(
                          Assets.svgNext,
                          height: 28.h,
                          width: 28.h,
                          colorFilter: ColorFilter.mode(context.customColorScheme.black, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Visibility(
                    visible: widget.model.isExpand ? true : false,
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        shrinkWrap: true,
                        itemCount: widget.model.serverList?.length ?? 0,
                        separatorBuilder: (context, index) => 4.verticalSpace,
                        itemBuilder: (context, a) {
                          ServerModel swModel = widget.model.serverList![a];
                          return GestureDetector(
                            onTap: () async => await widget.connectVpn(widget.model, swModel),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: context.colorScheme.surface,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          swModel.name ?? '-',
                                          style: TextStyle(
                                            fontSize: FontSizeValue.normal,
                                            color: context.customColorScheme.txtDarkGrey,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          swModel.city ?? '-',
                                          style: TextStyle(
                                            fontSize: FontSizeValue.small,
                                            color: context.customColorScheme.txtDarkGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${swModel.strength?.toString() ?? '0'}%',
                                    style: TextStyle(
                                      fontSize: FontSizeValue.small,
                                      color: UIHelper.getConnectionQuality(swModel.strength ?? 0),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  12.horizontalSpace,
                                  SvgPicture.asset(
                                    connectionStat?.connectedCountry?.id == widget.model.id && connectionStat?.connectedServer?.id == swModel.id ? Assets.svgOn : Assets.svgOff,
                                    height: 28.h,
                                    width: 28.h,
                                    colorFilter: connectionStat?.connectedCountry?.id == widget.model.id && connectionStat?.connectedServer?.id == swModel.id ? null : ColorFilter.mode(context.customColorScheme.black, BlendMode.srcIn),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  crossFadeState: widget.model.isExpand ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 100),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ConnectionInfoCard extends StatelessWidget {
  const _ConnectionInfoCard();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var vpnService = Get.find<VpnService>();
      final vpnState = vpnService.vpnState.value;
      var connectionStat = vpnService.connectionStats.value;
      return AnimatedCrossFade(
        firstChild: vpnState == VpnState.initializing
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 56.w),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: context.colorScheme.onSurfaceVariant,
                    boxShadow: [
                      BoxShadow(
                        color: context.customColorScheme.shadowColor.withOpacity(0.12),
                        blurRadius: 24,
                        spreadRadius: 0,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SpinKitRing(color: context.colorScheme.primary, size: 30.r),
                      12.verticalSpace,
                      Text(
                        'Bağlantı Kuruluyor',
                        style: TextStyle(
                          fontSize: FontSizeValue.normal,
                          color: context.customColorScheme.txtDarkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
        secondChild: vpnState == VpnState.connected && connectionStat != null
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 56.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Connection Time',
                      style: TextStyle(
                        fontSize: FontSizeValue.normal,
                        color: context.customColorScheme.txtDarkGrey,
                      ),
                    ),
                    Text(
                      vpnService.formatDuration(),
                      style: TextStyle(
                        fontSize: FontSizeValue.xxxLarge,
                        color: context.customColorScheme.black,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                    24.verticalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: context.colorScheme.onSurfaceVariant,
                        boxShadow: [
                          BoxShadow(
                            color: context.customColorScheme.shadowColor.withOpacity(0.12),
                            blurRadius: 24,
                            spreadRadius: 0,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          connectionStat.connectedCountry?.flag == null ? const SizedBox.shrink() : SvgPicture.asset(connectionStat.connectedCountry!.flag!, height: 32.h, width: 42.w),
                          8.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  connectionStat.connectedCountry!.name ?? '-',
                                  style: TextStyle(
                                    fontSize: FontSizeValue.normal,
                                    color: context.customColorScheme.txtDarkGrey,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  connectionStat.connectedServer!.name ?? '-',
                                  style: TextStyle(
                                    fontSize: FontSizeValue.small,
                                    color: context.customColorScheme.txtGrey,
                                    height: 0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          8.horizontalSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Stealth',
                                style: TextStyle(
                                  fontSize: FontSizeValue.small,
                                  color: context.customColorScheme.txtGrey,
                                  height: 0,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${connectionStat.connectedServer?.strength?.toString() ?? '0'}%',
                                style: TextStyle(
                                  fontSize: FontSizeValue.small,
                                  color: UIHelper.getConnectionQuality(connectionStat.connectedServer?.strength ?? 0),
                                  height: 0,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    8.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: context.colorScheme.onSurfaceVariant,
                              boxShadow: [
                                BoxShadow(
                                  color: context.customColorScheme.shadowColor.withOpacity(0.12),
                                  blurRadius: 24,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(Assets.svgDownload, height: 32.h, width: 42.w),
                                8.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Download :',
                                        style: TextStyle(
                                          fontSize: FontSizeValue.xSmall,
                                          color: context.customColorScheme.txtGrey,
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '527 MB',
                                        style: TextStyle(
                                          fontSize: FontSizeValue.normal,
                                          color: context.customColorScheme.txtGrey,
                                          height: 0,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        8.horizontalSpace,
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: context.colorScheme.onSurfaceVariant,
                              boxShadow: [
                                BoxShadow(
                                  color: context.customColorScheme.shadowColor.withOpacity(0.12),
                                  blurRadius: 24,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(Assets.svgUpload, height: 32.h, width: 42.w),
                                8.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Upload :',
                                        style: TextStyle(
                                          fontSize: FontSizeValue.xSmall,
                                          color: context.customColorScheme.txtGrey,
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '49 MB',
                                        style: TextStyle(
                                          fontSize: FontSizeValue.normal,
                                          color: context.customColorScheme.txtGrey,
                                          height: 0,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
        crossFadeState: vpnState == VpnState.initializing ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 300),
      );
    });
  }
}
