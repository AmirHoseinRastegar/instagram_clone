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
                Expanded(
                  child: ProfileStatistics(
                    onTap: (value) =>
                        _pushToStatsTapped(context, tabIndex: value),
                  ),
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
  const ProfileStatistics({required this.onTap, super.key});
  final ValueSetter<int> onTap;
  @override
  Widget build(BuildContext context) {
    final postsCount =
        context.select((ProfileBloc bloc) => bloc.state.postsCount);
    final followersCount =
        context.select((ProfileBloc bloc) => bloc.state.followersCount);
    final followingsCount =
        context.select((ProfileBloc bloc) => bloc.state.followingsCount);
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: ProfileStatsWidget(
            value: postsCount,
            name: l10n.postsCount(0),
          ),
        ),
        Expanded(
          child: ProfileStatsWidget(
            name: l10n.followersText,
            value: followersCount,
            onTap: () => onTap.call(0),
          ),
        ),
        Expanded(
          child: ProfileStatsWidget(
            name: l10n.followingsText,
            value: followingsCount,
            onTap: () => onTap.call(1),
          ),
        ),
      ].spacerBetween(width: AppSpacing.sm),
    );
  }
}
