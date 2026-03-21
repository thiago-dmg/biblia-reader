import '../network/biblia_http_client.dart';
import 'api_dtos.dart';

/// Cliente tipado dos endpoints `/v1/*` da Biblia Reader API.
class BibliaReaderApi {
  BibliaReaderApi(this._http);

  final BibliaHttpClient _http;

  Future<TokenResponse> register(RegisterRequest body) async {
    final j = await _http.post('/v1/auth/register', body: body.toJson()) as Map<String, dynamic>;
    return TokenResponse.fromJson(j);
  }

  Future<TokenResponse> login(LoginRequest body) async {
    final j = await _http.post('/v1/auth/login', body: body.toJson()) as Map<String, dynamic>;
    return TokenResponse.fromJson(j);
  }

  Future<void> logout() async {
    await _http.post('/v1/auth/logout');
  }

  /// A API ainda retorna 501 — não usar em produção até o backend implementar.
  Future<void> refresh() async {
    await _http.post('/v1/auth/refresh');
  }

  Future<List<BibleVersionDto>> bibleVersions() async {
    final raw = await _http.get('/v1/bible/versions') as List<dynamic>;
    return raw.map((e) => BibleVersionDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<BibleBookRowDto>> bibleBooks({String? versionId, String? versionCode}) async {
    final q = <String, String>{};
    if (versionId != null) q['versionId'] = versionId;
    if (versionCode != null) q['versionCode'] = versionCode;
    final raw = await _http.get('/v1/bible/books', query: q.isEmpty ? null : q) as List<dynamic>;
    return raw.map((e) => BibleBookRowDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<BibleChapterContentDto> bibleChapter({
    String? versionId,
    String? versionCode,
    required String bookAbbrev,
    required int number,
  }) async {
    final q = <String, String>{
      'bookAbbrev': bookAbbrev,
      'number': '$number',
    };
    if (versionId != null) q['versionId'] = versionId;
    if (versionCode != null) q['versionCode'] = versionCode;
    final j = await _http.get('/v1/bible/chapters', query: q) as Map<String, dynamic>;
    return BibleChapterContentDto.fromJson(j);
  }

  Future<ReadingProgressDto> getReadingProgress() async {
    final j = await _http.get('/v1/me/reading-progress') as Map<String, dynamic>;
    return ReadingProgressDto.fromJson(j);
  }

  Future<ReadingProgressDto> putReadingProgress(PutReadingProgressRequest body) async {
    final j = await _http.put('/v1/me/reading-progress', body: body.toJson()) as Map<String, dynamic>;
    return ReadingProgressDto.fromJson(j);
  }

  Future<ReadingProgressDto> patchReadingProgress(PatchReadingProgressRequest body) async {
    final j = await _http.patch('/v1/me/reading-progress', body: body.toJson()) as Map<String, dynamic>;
    return ReadingProgressDto.fromJson(j);
  }

  Future<List<ReadingPlanResponseDto>> listReadingPlans() async {
    final raw = await _http.get('/v1/reading-plans') as List<dynamic>;
    return raw.map((e) => ReadingPlanResponseDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ReadingPlanResponseDto> createReadingPlan(CreateReadingPlanRequest body) async {
    final j = await _http.post('/v1/reading-plans', body: body.toJson()) as Map<String, dynamic>;
    return ReadingPlanResponseDto.fromJson(j);
  }

  Future<ReadingPlanResponseDto> getReadingPlan(String id) async {
    final j = await _http.get('/v1/reading-plans/$id') as Map<String, dynamic>;
    return ReadingPlanResponseDto.fromJson(j);
  }

  Future<ReadingPlanSnapshotDto> addReadingEvents(String planId, AddReadingEventsRequest body) async {
    final j =
        await _http.post('/v1/reading-plans/$planId/events', body: body.toJson()) as Map<String, dynamic>;
    return ReadingPlanSnapshotDto.fromJson(j);
  }

  Future<ReadingPlanSnapshotDto> getReadingPlanSnapshot(String planId) async {
    final j = await _http.get('/v1/reading-plans/$planId/snapshot') as Map<String, dynamic>;
    return ReadingPlanSnapshotDto.fromJson(j);
  }

  Future<List<FaqItemDto>> supportFaq() async {
    final raw = await _http.get('/v1/support/faq') as List<dynamic>;
    return raw.map((e) => FaqItemDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<FeedPageDto> communityFeed({String? cursor, int pageSize = 20}) async {
    final q = <String, String>{
      'pageSize': '$pageSize',
      if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
    };
    final j = await _http.get('/v1/community/feed', query: q) as Map<String, dynamic>;
    return FeedPageDto.fromJson(j);
  }

  Future<PostDetailDto> communityPost(String postId) async {
    final j = await _http.get('/v1/community/posts/$postId') as Map<String, dynamic>;
    return PostDetailDto.fromJson(j);
  }

  Future<List<CommentThreadDto>> communityComments(String postId) async {
    final raw = await _http.get('/v1/community/posts/$postId/comments') as List<dynamic>;
    return raw.map((e) => CommentThreadDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<String> communityCreatePost(CreatePostRequest body) async {
    final j = await _http.post('/v1/community/posts', body: body.toJson()) as Map<String, dynamic>;
    return '${j['id'] ?? ''}';
  }

  Future<void> communityAddComment(String postId, CreateCommentRequest body) async {
    await _http.post('/v1/community/posts/$postId/comments', body: body.toJson());
  }

  Future<void> communityLike(String postId) async {
    await _http.post('/v1/community/posts/$postId/like');
  }

  Future<void> communityUnlike(String postId) async {
    await _http.delete('/v1/community/posts/$postId/like');
  }

  Future<void> communitySave(String postId) async {
    await _http.post('/v1/community/posts/$postId/save');
  }

  Future<void> communityUnsave(String postId) async {
    await _http.delete('/v1/community/posts/$postId/save');
  }
}
