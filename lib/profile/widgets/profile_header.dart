import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:instagram_clone/profile/bloc/profile_bloc.dart';
import 'package:instagram_related_ui/instagram_related_ui.dart';
import 'package:ui/ui.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.userId, super.key});
  final String userId;
  void _pushToStatsTapped(BuildContext context, {required int tabIndex}) =>
      context.pushNamed(
        'user_stats',
        extra: tabIndex,
        queryParameters: {'user_id': userId},
      );
  @override
  Widget build(BuildContext context) {
    final user = context.select((ProfileBloc bloc) => bloc.state.user);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage(
                    user.avatarUrl ?? '',
                  ),
                  radius: 32,
                ),
                ProfileStatistics(
                  onTap: (value) =>
                      _pushToStatsTapped(context, tabIndex: value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileStatistics extends StatelessWidget {
  const ProfileStatistics({super.key, required this.onTap});
  final ValueSetter<int> onTap;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: ProfileStatsWidget(
            value: 0,
            name: l10n.postsCount(0),
          ),
        ),
        Expanded(
          child: ProfileStatsWidget(
            name: l10n.followersText,
            value: 0,
            onTap: () => onTap.call(0),
          ),
        ),
        Expanded(
          child: ProfileStatsWidget(
            name: l10n.followingsText,
            value: 0,
            onTap: () => onTap.call(1),
          ),
        ),
      ],
    );
  }
}
