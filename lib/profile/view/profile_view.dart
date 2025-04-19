import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/app/bloc/app_bloc.dart';
import 'package:instagram_clone/l10n/l10n.dart';
import 'package:instagram_clone/profile/profile.dart';
import 'package:instagram_clone/selector/selector.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:shared/shared.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:ui/ui.dart';
import 'package:user_repository/user_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.userId, super.key});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        userRepository: context.read<UserRepository>(),
        userId: userId,
        postsRepositroy: context.read<PostsRepository>(),
      )
        ..add(const UserProfileSubscriptionRequested())
        ..add(
          const UserProfileFollowersCountSubscriptionRequested(),
        )
        ..add(
          const UserProfileFollowingsCountSubscriptionRequested(),
        )
        ..add(const UserProfilePostsCountSubscriptionRequested()),
      child: ProfileView(
        userId: userId,
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({required this.userId, super.key});
  final String userId;
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late ScrollController _tabBarScrollController;
  @override
  void initState() {
    _tabBarScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _tabBarScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((ProfileBloc bloc) => bloc.state.user);
    return AppScaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: _tabBarScrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: MultiSliver(
                  children: [
                    const ProfileAppBar(),
                    if (!user.isAnonymous) ...[
                      ProfileHeader(
                        userId: widget.userId,
                      ),
                      SliverPersistentHeader(
                        pinned: !ModalRoute.of(context)!.isFirst,
                        delegate: const _ProfileSliverPersistentTabBarDelegate(
                          tabBar: TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorWeight: 1,
                            padding: EdgeInsets.zero,
                            labelPadding: EdgeInsets.zero,
                            tabs: [
                              Tab(
                                icon: Icon(
                                  Icons.grid_on,
                                ),
                                iconMargin: EdgeInsets.zero,
                              ),
                              Tab(
                                icon: Icon(
                                  Icons.person_outline,
                                ),
                                iconMargin: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              ProfilePostsPage(),
              ProfileMentionedPostsPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePostsPage extends StatelessWidget {
  const ProfilePostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ProfileMentionedPostsPage extends StatelessWidget {
  const ProfileMentionedPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _ProfileSliverPersistentTabBarDelegate
    extends SliverPersistentHeaderDelegate {
  const _ProfileSliverPersistentTabBarDelegate({required this.tabBar});
  final TabBar tabBar;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: context.theme.scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(
    covariant _ProfileSliverPersistentTabBarDelegate oldDelegate,
  ) {
    return tabBar != oldDelegate.tabBar;
  }
}

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((ProfileBloc bloc) => bloc.state.user);
    final isOwner = context.select((ProfileBloc bloc) => bloc.isOwner);

    return SliverPadding(
      padding: const EdgeInsets.only(right: AppSpacing.md),
      sliver: SliverAppBar(
        centerTitle: false,
        pinned: !ModalRoute.of(context)!.isFirst,
        floating: ModalRoute.of(context)!.isFirst,
        title: Row(
          children: [
            Flexible(
              flex: 12,
              child: Text(
                user.displayUsername,
                style:
                    context.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Assets.icons.verifiedUser.svg(
                width: AppSize.iconSizeSmall,
                height: AppSize.iconSizeSmall,
              ),
            ),
          ],
        ),
        actions: [
          if (!isOwner)
            const ProfileActions()
          else ...[
            const ProfileAddMediaButton(),
            if (ModalRoute.of(context)?.isFirst ?? false) ...const [
              Gap.h(AppSpacing.md),
              ProfileSettingsButton(),
            ],
          ],
        ],
      ),
    );
  }
}

class ProfileActions extends StatelessWidget {
  const ProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      onTap: () {},
      child: Icon(Icons.adaptive.more_outlined, size: AppSize.iconSize),
    );
  }
}

class ProfileAddMediaButton extends StatelessWidget {
  const ProfileAddMediaButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      onTap: () {},
      child: const Icon(
        Icons.add_box_outlined,
        size: AppSize.iconSize,
      ),
    );
  }
}

class ProfileSettingsButton extends StatelessWidget {
  const ProfileSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return Tappable.faded(
      onTap: () => context.showListOptionsModal(
        options: [
          ModalOption(child: const LocaleModalWidget()),
          ModalOption(child: const ThemeSelectorModalOption()),
          ModalOption(child: const LogoutModal()),
        ],
      ).then(
        (value) {
          if (value == null) return;
          void onTap() => value.onTap(context);
          onTap.call();
        },
      ),
      child: Assets.icons.setting.svg(
        height: AppSize.iconSize,
        width: AppSize.iconSize,
        colorFilter: ColorFilter.mode(
          context.adaptiveColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class LogoutModal extends StatelessWidget {
  const LogoutModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable.faded(
      onTap: () => context.confirmAction(
          fn: () {
            context.pop();
            context.read<AppBloc>().add(const AppLogoutRequested());
          },
          title: context.l10n.logOutText,
          noText: context.l10n.cancelText,
          content: context.l10n.logOutConfirmationText,
          yesText: context.l10n.logOutText),
      child: ListTile(
        title: Text(
          context.l10n.logOutText,
          style: context.bodyLarge?.apply(color: AppColors.red),
        ),
        leading: const Icon(Icons.logout, color: AppColors.red),
      ),
    );
  }
}
