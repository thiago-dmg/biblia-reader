// DTOs alinhados ao Swagger/OpenAPI da BibliaReader API (camelCase).

class TokenResponse {
  const TokenResponse({
    required this.accessToken,
    required this.userId,
    required this.displayName,
  });

  final String accessToken;
  final String userId;
  final String displayName;

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    final uid = json['userId'];
    return TokenResponse(
      accessToken: json['accessToken'] as String? ?? '',
      userId: uid == null ? '' : '$uid',
      displayName: json['displayName'] as String? ?? '',
    );
  }
}

class RegisterRequest {
  const RegisterRequest({
    required this.email,
    required this.password,
    required this.displayName,
  });

  final String email;
  final String password;
  final String displayName;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'displayName': displayName,
      };
}

class LoginRequest {
  const LoginRequest({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class ReadingProgressDto {
  const ReadingProgressDto({
    required this.selectedPlanId,
    required this.planStartedAt,
    required this.completedChapterIds,
    required this.updatedAt,
  });

  final String selectedPlanId;
  final DateTime planStartedAt;
  final List<String> completedChapterIds;
  final DateTime updatedAt;

  factory ReadingProgressDto.fromJson(Map<String, dynamic> json) {
    return ReadingProgressDto(
      selectedPlanId: json['selectedPlanId'] as String? ?? 'one-year',
      planStartedAt: DateTime.tryParse(json['planStartedAt'] as String? ?? '') ??
          DateTime.now().toUtc(),
      completedChapterIds: (json['completedChapterIds'] as List<dynamic>?)
              ?.map((e) => '$e')
              .toList() ??
          const [],
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toJson() => {
        'selectedPlanId': selectedPlanId,
        'planStartedAt': planStartedAt.toUtc().toIso8601String(),
        'completedChapterIds': completedChapterIds,
        'updatedAt': updatedAt.toUtc().toIso8601String(),
      };
}

class PutReadingProgressRequest {
  const PutReadingProgressRequest({
    required this.selectedPlanId,
    required this.planStartedAt,
    required this.completedChapterIds,
  });

  final String selectedPlanId;
  final DateTime planStartedAt;
  final List<String> completedChapterIds;

  Map<String, dynamic> toJson() => {
        'selectedPlanId': selectedPlanId,
        'planStartedAt': planStartedAt.toUtc().toIso8601String(),
        'completedChapterIds': completedChapterIds,
      };
}

class PatchReadingProgressRequest {
  const PatchReadingProgressRequest({
    this.selectedPlanId,
    this.planStartedAt,
    this.completedChapterIds,
  });

  final String? selectedPlanId;
  final DateTime? planStartedAt;
  final List<String>? completedChapterIds;

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{};
    if (selectedPlanId != null) m['selectedPlanId'] = selectedPlanId;
    if (planStartedAt != null) {
      m['planStartedAt'] = planStartedAt!.toUtc().toIso8601String();
    }
    if (completedChapterIds != null) {
      m['completedChapterIds'] = completedChapterIds;
    }
    return m;
  }
}

class ReadingPlanResponseDto {
  const ReadingPlanResponseDto({
    required this.id,
    required this.title,
    required this.scopeType,
    required this.paceMode,
    this.chaptersPerDay,
    this.targetEndDate,
    required this.totalChapters,
    required this.completedChapters,
    required this.startedOn,
    required this.paused,
    required this.createdAt,
  });

  final String id;
  final String title;
  final int scopeType;
  final int paceMode;
  final int? chaptersPerDay;
  final String? targetEndDate;
  final int totalChapters;
  final int completedChapters;
  final String startedOn;
  final bool paused;
  final String createdAt;

  factory ReadingPlanResponseDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return ReadingPlanResponseDto(
      id: rawId == null ? '' : '$rawId',
      title: json['title'] as String? ?? '',
      scopeType: (json['scopeType'] as num?)?.toInt() ?? 0,
      paceMode: (json['paceMode'] as num?)?.toInt() ?? 0,
      chaptersPerDay: (json['chaptersPerDay'] as num?)?.toInt(),
      targetEndDate: json['targetEndDate'] as String?,
      totalChapters: (json['totalChapters'] as num?)?.toInt() ?? 0,
      completedChapters: (json['completedChapters'] as num?)?.toInt() ?? 0,
      startedOn: json['startedOn'] as String? ?? '',
      paused: json['paused'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }
}

class CreateReadingPlanRequest {
  const CreateReadingPlanRequest({
    required this.title,
    required this.scopeType,
    this.bookIds,
    required this.paceMode,
    this.chaptersPerDay,
    this.targetEndDate,
    this.durationDays,
    this.bibleVersionId,
  });

  final String title;
  final int scopeType;
  final List<String>? bookIds;
  final int paceMode;
  final int? chaptersPerDay;
  final String? targetEndDate;
  final int? durationDays;
  final String? bibleVersionId;

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{
      'title': title,
      'scopeType': scopeType,
      'paceMode': paceMode,
    };
    if (bookIds != null) m['bookIds'] = bookIds;
    if (chaptersPerDay != null) m['chaptersPerDay'] = chaptersPerDay;
    if (targetEndDate != null) m['targetEndDate'] = targetEndDate;
    if (durationDays != null) m['durationDays'] = durationDays;
    if (bibleVersionId != null) m['bibleVersionId'] = bibleVersionId;
    return m;
  }
}

class AddReadingEventsRequest {
  const AddReadingEventsRequest({
    required this.occurredAt,
    required this.chapterKeys,
  });

  final DateTime occurredAt;
  final List<String> chapterKeys;

  Map<String, dynamic> toJson() => {
        'occurredAt': occurredAt.toUtc().toIso8601String(),
        'chapterKeys': chapterKeys,
      };
}

class ReadingPlanSnapshotDto {
  const ReadingPlanSnapshotDto({
    required this.planId,
    required this.percentComplete,
    required this.remainingChapters,
    required this.suggestedChaptersToday,
    required this.estimatedDaysRemaining,
    required this.effectiveTargetEnd,
    required this.isBehindSchedule,
    required this.streakDays,
  });

  final String planId;
  final double percentComplete;
  final int remainingChapters;
  final int suggestedChaptersToday;
  final int estimatedDaysRemaining;
  final String effectiveTargetEnd;
  final bool isBehindSchedule;
  final int streakDays;

  factory ReadingPlanSnapshotDto.fromJson(Map<String, dynamic> json) {
    final pid = json['planId'];
    return ReadingPlanSnapshotDto(
      planId: pid == null ? '' : '$pid',
      percentComplete: (json['percentComplete'] as num?)?.toDouble() ?? 0,
      remainingChapters: (json['remainingChapters'] as num?)?.toInt() ?? 0,
      suggestedChaptersToday: (json['suggestedChaptersToday'] as num?)?.toInt() ?? 0,
      estimatedDaysRemaining: (json['estimatedDaysRemaining'] as num?)?.toInt() ?? 0,
      effectiveTargetEnd: json['effectiveTargetEnd'] as String? ?? '',
      isBehindSchedule: json['isBehindSchedule'] as bool? ?? false,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
    );
  }
}

class BibleVersionDto {
  const BibleVersionDto({
    required this.id,
    required this.code,
    required this.name,
  });

  final String id;
  final String code;
  final String name;

  factory BibleVersionDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return BibleVersionDto(
      id: rawId == null ? '' : '$rawId',
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

/// Livro retornado por `GET /v1/bible/books`.
class BibleBookRowDto {
  const BibleBookRowDto({
    required this.id,
    required this.abbreviation,
    required this.name,
    required this.chapterCount,
    required this.canonicalOrder,
  });

  final String id;
  final String abbreviation;
  final String name;
  final int chapterCount;
  final int canonicalOrder;

  factory BibleBookRowDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return BibleBookRowDto(
      id: rawId == null ? '' : '$rawId',
      abbreviation: json['abbreviation'] as String? ?? '',
      name: json['name'] as String? ?? '',
      chapterCount: (json['chapterCount'] as num?)?.toInt() ?? 0,
      canonicalOrder: (json['canonicalOrder'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Capítulo retornado por `GET /v1/bible/chapters`.
class BibleChapterContentDto {
  const BibleChapterContentDto({
    required this.versionId,
    required this.versionCode,
    required this.versionName,
    required this.bookId,
    required this.bookAbbreviation,
    required this.bookName,
    required this.chapterNumber,
    this.contentHtml,
  });

  final String versionId;
  final String versionCode;
  final String versionName;
  final String bookId;
  final String bookAbbreviation;
  final String bookName;
  final int chapterNumber;
  final String? contentHtml;

  factory BibleChapterContentDto.fromJson(Map<String, dynamic> json) {
    return BibleChapterContentDto(
      versionId: '${json['versionId'] ?? ''}',
      versionCode: json['versionCode'] as String? ?? '',
      versionName: json['versionName'] as String? ?? '',
      bookId: '${json['bookId'] ?? ''}',
      bookAbbreviation: json['bookAbbreviation'] as String? ?? '',
      bookName: json['bookName'] as String? ?? '',
      chapterNumber: (json['chapterNumber'] as num?)?.toInt() ?? 1,
      contentHtml: json['contentHtml'] as String?,
    );
  }
}

// --- Comunidade (feed estilo rede social) ---

class FeedPageDto {
  const FeedPageDto({required this.items, this.nextCursor});

  final List<FeedPostDto> items;
  final String? nextCursor;

  factory FeedPageDto.fromJson(Map<String, dynamic> json) {
    final raw = json['items'] as List<dynamic>? ?? [];
    return FeedPageDto(
      items: raw.map((e) => FeedPostDto.fromJson(e as Map<String, dynamic>)).toList(),
      nextCursor: json['nextCursor'] == null ? null : '${json['nextCursor']}',
    );
  }
}

class FeedPostDto {
  const FeedPostDto({
    required this.id,
    required this.authorUserId,
    required this.authorDisplayName,
    this.authorAvatarUrl,
    required this.body,
    required this.createdAt,
    required this.likeCount,
    required this.commentCount,
    required this.likedByMe,
    required this.savedByMe,
  });

  final String id;
  final String authorUserId;
  final String authorDisplayName;
  final String? authorAvatarUrl;
  final String body;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final bool likedByMe;
  final bool savedByMe;

  factory FeedPostDto.fromJson(Map<String, dynamic> json) {
    return FeedPostDto(
      id: '${json['id'] ?? ''}',
      authorUserId: '${json['authorUserId'] ?? ''}',
      authorDisplayName: json['authorDisplayName'] as String? ?? '',
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      body: json['body'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '')?.toLocal() ?? DateTime.now(),
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      likedByMe: json['likedByMe'] as bool? ?? false,
      savedByMe: json['savedByMe'] as bool? ?? false,
    );
  }
}

class PostDetailDto {
  const PostDetailDto({
    required this.id,
    required this.authorUserId,
    required this.authorDisplayName,
    this.authorAvatarUrl,
    required this.body,
    required this.visibility,
    required this.createdAt,
    required this.likeCount,
    required this.commentCount,
    required this.likedByMe,
    required this.savedByMe,
  });

  final String id;
  final String authorUserId;
  final String authorDisplayName;
  final String? authorAvatarUrl;
  final String body;
  final int visibility;
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final bool likedByMe;
  final bool savedByMe;

  factory PostDetailDto.fromJson(Map<String, dynamic> json) {
    return PostDetailDto(
      id: '${json['id'] ?? ''}',
      authorUserId: '${json['authorUserId'] ?? ''}',
      authorDisplayName: json['authorDisplayName'] as String? ?? '',
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      body: json['body'] as String? ?? '',
      visibility: (json['visibility'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '')?.toLocal() ?? DateTime.now(),
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      likedByMe: json['likedByMe'] as bool? ?? false,
      savedByMe: json['savedByMe'] as bool? ?? false,
    );
  }
}

class CommentThreadDto {
  const CommentThreadDto({
    required this.id,
    required this.authorUserId,
    required this.authorDisplayName,
    this.authorAvatarUrl,
    required this.body,
    required this.createdAt,
    required this.replies,
  });

  final String id;
  final String authorUserId;
  final String authorDisplayName;
  final String? authorAvatarUrl;
  final String body;
  final DateTime createdAt;
  final List<CommentThreadDto> replies;

  factory CommentThreadDto.fromJson(Map<String, dynamic> json) {
    final raw = json['replies'] as List<dynamic>? ?? [];
    return CommentThreadDto(
      id: '${json['id'] ?? ''}',
      authorUserId: '${json['authorUserId'] ?? ''}',
      authorDisplayName: json['authorDisplayName'] as String? ?? '',
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      body: json['body'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '')?.toLocal() ?? DateTime.now(),
      replies: raw.map((e) => CommentThreadDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class CreatePostRequest {
  const CreatePostRequest({required this.body, this.visibility = 0});

  final String body;
  /// 0 = público, 1 = só seguidores (quando o feed suportar).
  final int visibility;

  Map<String, dynamic> toJson() => {'body': body, 'visibility': visibility};
}

class CreateCommentRequest {
  const CreateCommentRequest({required this.body, this.parentCommentId});

  final String body;
  final String? parentCommentId;

  Map<String, dynamic> toJson() => {
        'body': body,
        if (parentCommentId != null && parentCommentId!.isNotEmpty) 'parentCommentId': parentCommentId,
      };
}

class FaqItemDto {
  const FaqItemDto({
    required this.id,
    required this.question,
    required this.answerMarkdown,
  });

  final String id;
  final String question;
  final String answerMarkdown;

  factory FaqItemDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return FaqItemDto(
      id: rawId == null ? '' : '$rawId',
      question: json['question'] as String? ?? '',
      answerMarkdown: json['answerMarkdown'] as String? ?? '',
    );
  }
}
