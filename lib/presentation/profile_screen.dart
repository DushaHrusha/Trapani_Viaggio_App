import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/adaptive_size_extension.dart';
import '../core/constants/base_colors.dart';
import '../core/constants/bottom_bar.dart';
import '../core/constants/custom_app_bar.dart';
import '../core/constants/custom_background_with_gradient.dart';
import '../core/constants/grey_line.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.background,
      body: CustomBackgroundWithGradient(
        child: Column(
          children: [
            const CustomAppBar(label: "profile"),
            const GreyLine(),
            SizedBox(height: context.adaptiveSize(32)),
            _buildAnimatedProfileHeader(context),
            Expanded(child: _buildAnimatedMenuList(context)),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(currentScreen: ProfileScreen()),
    );
  }

  Widget _buildAnimatedProfileHeader(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: 'profile_avatar',
            child: CircleAvatar(
              radius: context.adaptiveSize(36),
              backgroundImage: AssetImage('assets/images/avatars/me.jpg'),
            ),
          ),
          SizedBox(height: context.adaptiveSize(16)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Alex',
                style: context.adaptiveTextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: BaseColors.text,
                ),
              ),
              Text(
                'Moscow, Russia',
                style: context.adaptiveTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: BaseColors.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMenuList(BuildContext context) {
    final menuItems = [
      {'title': 'Personal information'},
      {'title': 'Payment method'},
      {'title': 'Booking history'},
      {'title': 'Bookmarks'},
      {'title': 'Online assistant'},
      {'title': 'Settings'},
      {'title': 'Log Out'},
    ];

    return ListView.separated(
      padding: EdgeInsets.only(top: context.adaptiveSize(40)),
      itemCount: menuItems.length,
      separatorBuilder: (context, index) => Padding(
        padding: context.adaptivePadding(EdgeInsets.symmetric(horizontal: 30)),
        child: GreyLine(),
      ),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return Padding(
          padding: context.adaptivePadding(
            EdgeInsets.symmetric(horizontal: 30),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            title: Text(
              item['title'] as String,
              style: context.adaptiveTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: BaseColors.text,
              ),
            ),
            trailing: index == menuItems.length - 1
                ? Icon(
                    Icons.logout_rounded,
                    size: context.adaptiveSize(16),
                    color: BaseColors.text,
                  )
                : Icon(
                    Icons.arrow_forward_ios,
                    size: context.adaptiveSize(14),
                    color: Color.fromARGB(255, 189, 189, 189),
                  ),
            onTap: () {
              context.go('/chat');
            }, // Navigate to ChatScreen},
          ),
        );
      },
    );
  }
}
