import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/features/landing/presentation/providers/home_scroll_notif_provider.dart';

class OrderbookAppBarWidget extends StatelessWidget {
  const OrderbookAppBarWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          kToolbarHeight - context.read<HomeScrollNotifProvider>().appbarValue,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          transform: Matrix4.identity()
            ..translate(
                0.0, -context.read<HomeScrollNotifProvider>().appbarValue),
          height: kToolbarHeight,
          child: _ThisBaseAppbar(
            // animation: this._appbarAnimation,
            assetImg: 'user_icon.png'.asAssetImg(),
            actions: [
              InkWell(
                onTap: () => Scaffold.of(context).openEndDrawer(),
                child: Container(
                  width: 40,
                  height: 40,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppColors.color558BA1BE, shape: BoxShape.circle),
                  child: SvgPicture.asset(
                    'notifications'.asAssetSvg(),
                    color: Colors.white,
                    fit: BoxFit.contain,
                  ),
                ),
                // ),
              )
            ],
            onAvatarTapped: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
    );
  }
}

class _ThisBaseAppbar extends StatelessWidget with PreferredSizeWidget {
  final String assetImg;
  final List<Widget> actions;
  // final Animation<double> animation;

  /// The call back listner for avatar onTap
  final VoidCallback onAvatarTapped;

  const _ThisBaseAppbar({
    required this.assetImg,
    required this.actions,
    required this.onAvatarTapped,
    // this.animation,
  });
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (assetImg.isNotEmpty) _buildAvatar(),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: SvgPicture.asset(
                    'title'.asAssetSvg(),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            if (actions.isNotEmpty) _buildNotification(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);

  Widget _buildAvatar() {
    return InkWell(
      onTap: onAvatarTapped,
      child: Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: AppColors.color558BA1BE, shape: BoxShape.circle),
        child: SvgPicture.asset(
          'profile'.asAssetSvg(),
          color: Colors.white,
          fit: BoxFit.contain,
        ),
      ),
      // ),
    );
  }

  Widget _buildNotification() {
    return Row(children: actions);
  }
}
