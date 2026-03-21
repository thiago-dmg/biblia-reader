using BibliaReader.Domain.Common;

namespace BibliaReader.Domain.Entities;

public class Follow : BaseEntity
{
    public Guid FollowerUserId { get; set; }
    public Guid FollowingUserId { get; set; }
}
