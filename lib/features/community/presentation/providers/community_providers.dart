import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_dtos.dart';
import '../../../../core/auth/biblia_auth.dart';

final communityFeedProvider = FutureProvider<FeedPageDto>((ref) async {
  final api = ref.watch(bibliaReaderApiProvider);
  return api.communityFeed();
});

final communityPostProvider = FutureProvider.family<PostDetailDto, String>((ref, postId) async {
  final api = ref.read(bibliaReaderApiProvider);
  return api.communityPost(postId);
});

final communityCommentsProvider =
    FutureProvider.family<List<CommentThreadDto>, String>((ref, postId) async {
  final api = ref.read(bibliaReaderApiProvider);
  return api.communityComments(postId);
});
