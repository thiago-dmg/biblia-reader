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

class CommunityPostDetailScreen extends ConsumerStatefulWidget {
  const CommunityPostDetailScreen({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<CommunityPostDetailScreen> createState() => _CommunityPostDetailScreenState();
}

class _CommunityPostDetailScreenState extends ConsumerState<CommunityPostDetailScreen> {
  final _commentCtrl = TextEditingController();
  String? _replyingToId;
  String? _replyingToName;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;
    final auth = ref.read(authProvider).valueOrNull;
    if (auth == null || !auth.isAuthenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entre na conta para comentar.')),
        );
      }
      return;
    }
    try {
      await ref.read(bibliaReaderApiProvider).communityAddComment(
            widget.postId,
            CreateCommentRequest(body: text, parentCommentId: _replyingToId),
          );
      _commentCtrl.clear();
      setState(() {
        _replyingToId = null;
        _replyingToName = null;
      });
      ref.invalidate(communityCommentsProvider(widget.postId));
      ref.invalidate(communityPostProvider(widget.postId));
      ref.invalidate(communityFeedProvider);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _toggleLike(PostDetailDto p) async {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth == null || !auth.isAuthenticated) {
      if (mounted) context.push('/auth/login');
      return;
    }
    final api = ref.read(bibliaReaderApiProvider);
    try {
      if (p.likedByMe) {
        await api.communityUnlike(widget.postId);
      } else {
        await api.communityLike(widget.postId);
      }
      ref.invalidate(communityPostProvider(widget.postId));
      ref.invalidate(communityFeedProvider);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final postAsync = ref.watch(communityPostProvider(widget.postId));
    final commentsAsync = ref.watch(communityCommentsProvider(widget.postId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicação'),
      ),
      body: Column(
        children: [
          Expanded(
            child: postAsync.when(
              data: (p) {
                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    AppSpacing.s12,
                    AppSpacing.page,
                    AppSpacing.s24,
                  ),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NameAvatar(
                          name: p.authorDisplayName,
                          photoUrl: p.authorAvatarUrl,
                          radius: 26,
                        ),
                        const SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.authorDisplayName,
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                formatRelativeTime(p.createdAt),
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
                    Text(p.body, style: theme.textTheme.bodyLarge?.copyWith(height: 1.55)),
                    const SizedBox(height: AppSpacing.s16),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => _toggleLike(p),
                          child: Row(
                            children: [
                              Icon(
                                p.likedByMe ? Icons.favorite : AppLucideUi.heart,
                                size: AppIconSizes.inline,
                                color: p.likedByMe ? scheme.primary : scheme.onSurface.withValues(alpha: 0.45),
                              ),
                              const SizedBox(width: AppSpacing.s6),
                              Text(
                                '${p.likeCount}',
                                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
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
                              '${p.commentCount}',
                              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: AppSpacing.s32),
                    Text(
                      'Comentários',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    commentsAsync.when(
                      data: (list) {
                        if (list.isEmpty) {
                          return Text(
                            'Nenhum comentário ainda. Seja o primeiro!',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurface.withValues(alpha: 0.6),
                            ),
                          );
                        }
                        return Column(
                          children: list.map((c) => _CommentBranch(
                                node: c,
                                depth: 0,
                                onReply: (id, name) {
                                  setState(() {
                                    _replyingToId = id;
                                    _replyingToName = name;
                                  });
                                },
                              )).toList(),
                        );
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator.adaptive()),
                      ),
                      error: (e, _) => Text('$e'),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator.adaptive()),
              error: (e, _) => Center(child: Text('Erro: $e')),
            ),
          ),
          Material(
            elevation: 8,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.s8, AppSpacing.page, AppSpacing.s12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_replyingToId != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Respondendo a $_replyingToName',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            TextButton(
                              onPressed: () => setState(() {
                                _replyingToId = null;
                                _replyingToName = null;
                              }),
                              child: const Text('Cancelar'),
                            ),
                          ],
                        ),
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentCtrl,
                            decoration: const InputDecoration(
                              hintText: 'Escreva um comentário…',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            minLines: 1,
                            maxLines: 4,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        IconButton.filled(
                          onPressed: _sendComment,
                          icon: const Icon(Icons.send_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentBranch extends StatelessWidget {
  const _CommentBranch({
    required this.node,
    required this.depth,
    required this.onReply,
  });

  final CommentThreadDto node;
  final int depth;
  final void Function(String id, String name) onReply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: EdgeInsets.only(left: depth * 14.0, bottom: AppSpacing.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NameAvatar(name: node.authorDisplayName, photoUrl: node.authorAvatarUrl, radius: 18),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            node.authorDisplayName,
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextButton(
                          onPressed: () => onReply(node.id, node.authorDisplayName),
                          child: const Text('Responder'),
                        ),
                      ],
                    ),
                    Text(
                      formatRelativeTime(node.createdAt),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    Text(node.body, style: theme.textTheme.bodyMedium?.copyWith(height: 1.45)),
                  ],
                ),
              ),
            ],
          ),
          ...node.replies.map(
            (r) => _CommentBranch(node: r, depth: depth + 1, onReply: onReply),
          ),
        ],
      ),
    );
  }
}
