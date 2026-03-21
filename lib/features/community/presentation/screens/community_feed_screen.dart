import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/api_dtos.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/auth/biblia_auth.dart';
import '../../../../core/formatting/relative_time.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../shared/icons/app_icons.dart';
import '../../../../shared/widgets/name_avatar.dart';
import '../providers/community_providers.dart';

class CommunityFeedScreen extends ConsumerWidget {
  const CommunityFeedScreen({super.key});

  Future<void> _compose(BuildContext context, WidgetRef ref) async {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth == null || !auth.isAuthenticated) {
      if (context.mounted) {
        await context.push('/auth/login');
      }
      return;
    }
    final controller = TextEditingController();
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.page,
            right: AppSpacing.page,
            top: AppSpacing.s12,
            bottom: MediaQuery.paddingOf(ctx).bottom + MediaQuery.viewInsetsOf(ctx).bottom + AppSpacing.s16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Nova publicação', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.s12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Compartilhe uma reflexão ou versículo…',
                  border: OutlineInputBorder(),
                ),
                minLines: 4,
                maxLines: 10,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: AppSpacing.s16),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Publicar'),
              ),
            ],
          ),
        );
      },
    );
    final text = controller.text.trim();
    controller.dispose();
    if (ok != true || text.isEmpty || !context.mounted) return;
    try {
      await ref.read(bibliaReaderApiProvider).communityCreatePost(CreatePostRequest(body: text));
      ref.invalidate(communityFeedProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Publicado!')));
      }
    } on ApiException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _toggleLike(BuildContext context, WidgetRef ref, FeedPostDto post) async {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth == null || !auth.isAuthenticated) {
      if (context.mounted) await context.push('/auth/login');
      return;
    }
    final api = ref.read(bibliaReaderApiProvider);
    try {
      if (post.likedByMe) {
        await api.communityUnlike(post.id);
      } else {
        await api.communityLike(post.id);
      }
      ref.invalidate(communityFeedProvider);
    } on ApiException catch (_) {}
  }

  Future<void> _toggleSave(BuildContext context, WidgetRef ref, FeedPostDto post) async {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth == null || !auth.isAuthenticated) {
      if (context.mounted) await context.push('/auth/login');
      return;
    }
    final api = ref.read(bibliaReaderApiProvider);
    try {
      if (post.savedByMe) {
        await api.communityUnsave(post.id);
      } else {
        await api.communitySave(post.id);
      }
      ref.invalidate(communityFeedProvider);
    } on ApiException catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final br = theme.brightness;
    final feedAsync = ref.watch(communityFeedProvider);
    final auth = ref.watch(authProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text('Comunidade', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(AppLucideUi.penLine),
            onPressed: () => _compose(context, ref),
            tooltip: 'Nova publicação',
          ),
        ],
      ),
      body: feedAsync.when(
        data: (page) {
          if (page.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.page),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nenhuma publicação ainda.',
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      auth?.isAuthenticated == true
                          ? 'Toque no ícone da caneta para postar.'
                          : 'Entre na conta para publicar e interagir.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    if (auth?.isAuthenticated != true) ...[
                      const SizedBox(height: AppSpacing.s18),
                      FilledButton(
                        onPressed: () => context.push('/auth/login'),
                        child: const Text('Entrar'),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(communityFeedProvider),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.s12,
                AppSpacing.page,
                AppSpacing.s48,
              ),
              itemCount: page.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.s18),
              itemBuilder: (context, i) {
                final post = page.items[i];
                return _PostCard(
                  post: post,
                  scheme: scheme,
                  theme: theme,
                  br: br,
                  onOpen: () => context.push('/community/post/${post.id}'),
                  onLike: () => _toggleLike(context, ref, post),
                  onSave: () => _toggleSave(context, ref, post),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.page),
            child: Text(
              'Não foi possível carregar o feed.\n$e',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.scheme,
    required this.theme,
    required this.br,
    required this.onOpen,
    required this.onLike,
    required this.onSave,
  });

  final FeedPostDto post;
  final ColorScheme scheme;
  final ThemeData theme;
  final Brightness br;
  final VoidCallback onOpen;
  final VoidCallback onLike;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        onTap: onOpen,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: scheme.outline.withValues(alpha: 0.72)),
            boxShadow: AppShadows.card(br),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NameAvatar(
                      name: post.authorDisplayName,
                      photoUrl: post.authorAvatarUrl,
                      radius: 22,
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.authorDisplayName,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            formatRelativeTime(post.createdAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s12),
                Text(
                  post.body,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.s12),
                Row(
                  children: [
                    InkWell(
                      onTap: onLike,
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s6,
                          vertical: AppSpacing.s6,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              post.likedByMe ? Icons.favorite : AppLucideUi.heart,
                              size: AppIconSizes.inline,
                              color: post.likedByMe
                                  ? scheme.primary
                                  : scheme.onSurface.withValues(alpha: 0.45),
                            ),
                            const SizedBox(width: AppSpacing.s6),
                            Text(
                              '${post.likeCount}',
                              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s18),
                    Row(
                      children: [
                        Icon(
                          AppLucideUi.messageCircle,
                          size: AppIconSizes.inline,
                          color: scheme.onSurface.withValues(alpha: 0.45),
                        ),
                        const SizedBox(width: AppSpacing.s6),
                        Text(
                          '${post.commentCount}',
                          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: onSave,
                      child: Icon(
                        post.savedByMe ? Icons.bookmark : Icons.bookmark_border,
                        size: AppIconSizes.inline,
                        color: post.savedByMe
                            ? scheme.primary
                            : scheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
