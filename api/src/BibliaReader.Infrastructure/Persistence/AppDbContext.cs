using BibliaReader.Domain.Entities;
using BibliaReader.Infrastructure.Identity;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace BibliaReader.Infrastructure.Persistence;

public sealed class AppDbContext : IdentityDbContext<ApplicationUser, IdentityRole<Guid>, Guid>
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<BibleVersion> BibleVersions => Set<BibleVersion>();
    public DbSet<BibleBook> BibleBooks => Set<BibleBook>();
    public DbSet<BibleChapter> BibleChapters => Set<BibleChapter>();
    public DbSet<ReadingPlan> ReadingPlans => Set<ReadingPlan>();
    public DbSet<ReadingEvent> ReadingEvents => Set<ReadingEvent>();
    public DbSet<Goal> Goals => Set<Goal>();
    public DbSet<Study> Studies => Set<Study>();
    public DbSet<StudyCategory> StudyCategories => Set<StudyCategory>();
    public DbSet<StudyLesson> StudyLessons => Set<StudyLesson>();
    public DbSet<StudyCategoryLink> StudyCategoryLinks => Set<StudyCategoryLink>();
    public DbSet<UserStudyProgress> UserStudyProgressEntries => Set<UserStudyProgress>();
    public DbSet<Post> Posts => Set<Post>();
    public DbSet<PostLike> PostLikes => Set<PostLike>();
    public DbSet<PostComment> PostComments => Set<PostComment>();
    public DbSet<Follow> Follows => Set<Follow>();
    public DbSet<SavedPost> SavedPosts => Set<SavedPost>();
    public DbSet<SupportTicket> SupportTickets => Set<SupportTicket>();
    public DbSet<TicketMessage> TicketMessages => Set<TicketMessage>();
    public DbSet<FaqItem> FaqItems => Set<FaqItem>();
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();
    public DbSet<UserCanonicalReadingProgress> UserCanonicalReadingProgresses => Set<UserCanonicalReadingProgress>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<ApplicationUser>(e =>
        {
            e.Property(x => x.DisplayName).HasMaxLength(120);
            e.Property(x => x.Bio).HasMaxLength(500);
        });

        modelBuilder.Entity<BibleVersion>(e =>
        {
            e.HasIndex(x => x.Code).IsUnique();
            e.Property(x => x.Code).HasMaxLength(32);
            e.Property(x => x.Name).HasMaxLength(160);
        });

        modelBuilder.Entity<BibleBook>(e =>
        {
            e.HasIndex(x => new { x.BibleVersionId, x.Abbreviation }).IsUnique();
            e.Property(x => x.Abbreviation).HasMaxLength(16);
            e.Property(x => x.Name).HasMaxLength(120);
        });

        modelBuilder.Entity<BibleChapter>(e =>
        {
            e.HasIndex(x => new { x.BibleBookId, x.Number }).IsUnique();
        });

        modelBuilder.Entity<ReadingPlan>(e =>
        {
            e.HasIndex(x => x.UserId);
            e.Property(x => x.Title).HasMaxLength(200);
            e.HasOne(x => x.BibleVersion).WithMany().HasForeignKey(x => x.BibleVersionId);
        });

        modelBuilder.Entity<ReadingEvent>(e =>
        {
            e.HasIndex(x => new { x.ReadingPlanId, x.ChapterKey }).IsUnique();
            e.HasIndex(x => new { x.UserId, x.OccurredAt });
            e.Property(x => x.ChapterKey).HasMaxLength(32);
            e.HasOne(x => x.ReadingPlan).WithMany(x => x.Events).HasForeignKey(x => x.ReadingPlanId);
        });

        modelBuilder.Entity<Goal>(e => e.HasIndex(x => x.UserId));

        modelBuilder.Entity<StudyCategoryLink>(e =>
        {
            e.HasKey(x => new { x.StudyId, x.StudyCategoryId });
            e.HasOne(x => x.Study).WithMany(x => x.CategoryLinks).HasForeignKey(x => x.StudyId);
            e.HasOne(x => x.StudyCategory).WithMany(x => x.StudyLinks).HasForeignKey(x => x.StudyCategoryId);
        });

        modelBuilder.Entity<StudyLesson>(e =>
        {
            e.HasIndex(x => new { x.StudyId, x.Order }).IsUnique();
            e.HasOne(x => x.Study).WithMany(x => x.Lessons).HasForeignKey(x => x.StudyId);
        });

        modelBuilder.Entity<UserStudyProgress>(e =>
        {
            e.HasIndex(x => new { x.UserId, x.StudyId }).IsUnique();
            e.HasOne(x => x.Study).WithMany().HasForeignKey(x => x.StudyId);
        });

        modelBuilder.Entity<Post>(e =>
        {
            e.HasIndex(x => x.AuthorUserId);
            e.Property(x => x.Body).HasMaxLength(8000);
        });

        modelBuilder.Entity<PostLike>(e =>
        {
            e.HasIndex(x => new { x.PostId, x.UserId }).IsUnique();
            e.HasOne(x => x.Post).WithMany(x => x.Likes).HasForeignKey(x => x.PostId);
        });

        modelBuilder.Entity<PostComment>(e =>
        {
            e.HasIndex(x => x.PostId);
            e.Property(x => x.Body).HasMaxLength(4000);
            e.HasOne(x => x.Post).WithMany(x => x.Comments).HasForeignKey(x => x.PostId);
            e.HasOne(x => x.ParentComment).WithMany(x => x.Replies).HasForeignKey(x => x.ParentCommentId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        modelBuilder.Entity<Follow>(e =>
        {
            e.HasIndex(x => new { x.FollowerUserId, x.FollowingUserId }).IsUnique();
        });

        modelBuilder.Entity<SavedPost>(e =>
        {
            e.HasIndex(x => new { x.UserId, x.PostId }).IsUnique();
            e.HasOne(x => x.Post).WithMany(x => x.SavedBy).HasForeignKey(x => x.PostId);
        });

        modelBuilder.Entity<SupportTicket>(e => e.HasIndex(x => x.UserId));
        modelBuilder.Entity<TicketMessage>(e =>
        {
            e.HasOne(x => x.SupportTicket).WithMany(x => x.Messages).HasForeignKey(x => x.SupportTicketId);
        });

        modelBuilder.Entity<RefreshToken>(e =>
        {
            e.HasIndex(x => x.UserId);
            e.Property(x => x.TokenHash).HasMaxLength(256);
        });

        modelBuilder.Entity<UserCanonicalReadingProgress>(e =>
        {
            e.HasKey(x => x.UserId);
            e.Property(x => x.SelectedPlanId).HasMaxLength(32);
            e.Property(x => x.CompletedChapterIdsJson).HasColumnType("jsonb");
            e.HasOne<ApplicationUser>()
                .WithOne()
                .HasForeignKey<UserCanonicalReadingProgress>(x => x.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });
    }
}
