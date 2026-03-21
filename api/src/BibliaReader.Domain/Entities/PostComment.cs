using BibliaReader.Domain.Common;

namespace BibliaReader.Domain.Entities;

public class PostComment : BaseEntity
{
    public Guid PostId { get; set; }
    public Post Post { get; set; } = null!;
    public Guid AuthorUserId { get; set; }
    public string Body { get; set; } = null!;
    public Guid? ParentCommentId { get; set; }
    public PostComment? ParentComment { get; set; }
    public ICollection<PostComment> Replies { get; set; } = new List<PostComment>();
}
