using BibliaReader.Domain.Common;
using BibliaReader.Domain.Enums;

namespace BibliaReader.Domain.Entities;

public class Post : BaseEntity
{
    public Guid AuthorUserId { get; set; }
    public string Body { get; set; } = null!;
    public PostVisibility Visibility { get; set; } = PostVisibility.Public;
    public ICollection<PostLike> Likes { get; set; } = new List<PostLike>();
    public ICollection<PostComment> Comments { get; set; } = new List<PostComment>();
    public ICollection<SavedPost> SavedBy { get; set; } = new List<SavedPost>();
}
