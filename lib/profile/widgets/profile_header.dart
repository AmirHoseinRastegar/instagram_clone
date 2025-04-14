import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:instagram_clone/profile/profile.dart';
import 'package:instagram_related_ui/instagram_related_ui.dart';
import 'package:shared/shared.dart';
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
    final isOwner = context.select((ProfileBloc bloc) => bloc.isOwner);
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
            const Gap.v(AppSpacing.md),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                user.displayFullName,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.titleMedium
                    ?.copyWith(fontWeight: AppFontWeight.semiBold),
              ),
            ),
            const Gap.v(AppSpacing.md),
            Row(
              children: [
                if (isOwner)
                  ...[
                    const Flexible(flex: 3, child: ProfileEditButton()),
                    const Flexible(flex: 3, child: ShareProfileButton()),
                    const Flexible(child: ShowSuggestedPeopleButton()),
                  ].spacerBetween(width: AppSpacing.sm)
                else ...[
                  ProfileFollowButton(),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileFollowButton extends StatelessWidget {
  const ProfileFollowButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProfileBloc>();
    final user = context.select(
      (ProfileBloc bloc) => bloc.state.user,
    );
    final l10n = context.l10n;
    return CustomStreamBuilder<bool>(
      stream: bloc.followingStatus(),
      builder: (BuildContext context, bool isFollowed) {
        return ProfileButton(
          label: isFollowed ? '${l10n.followingUser} ▼' : l10n.followUser,
          color: isFollowed
              ? null
              : context.customReversedAdaptiveColor(
                  dark: AppColors.blue,
                  light: AppColors.lightBlue,
                ),
          onTap: isFollowed
              ? () async {
                  void callBack(ModalOption option) =>
                      option.onTap.call(context);
                  final option = await context.showListOptionsModal(
                    title: user.username,
                    options: followerModalOptions(
                      unfollowLabel: context.l10n.cancelFollowingText,
                      onUnfollowTap: () => bloc.add(
                        const UserProfileFollowUserRequested(),
                      ),
                    ),
                  );
                }
              : $AssetsAnimationsGen.new,
        );
      },
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

class ProfileEditButton extends StatelessWidget {
  const ProfileEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileButton(
      label: context.l10n.editProfileText,
      onTap: () => context.pushNamed('edit_profile'),
    );
  }
}

class ShareProfileButton extends StatelessWidget {
  const ShareProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileButton(
      label: context.l10n.shareProfileText,
      onTap: () {},
    );
  }
}

class ShowSuggestedPeopleButton extends StatefulWidget {
  const ShowSuggestedPeopleButton({super.key});

  @override
  State<ShowSuggestedPeopleButton> createState() =>
      _ShowSuggestedPeopleButtonState();
}

class _ShowSuggestedPeopleButtonState extends State<ShowSuggestedPeopleButton> {
  var _showPeople = false;
  @override
  Widget build(BuildContext context) {
    return ProfileButton(
      onTap: () => setState(() => _showPeople = !_showPeople),
      child: Icon(
        _showPeople ? Icons.person_add_rounded : Icons.person_add_outlined,
      ),
    );
  }
}
