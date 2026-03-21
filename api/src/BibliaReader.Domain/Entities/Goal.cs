using BibliaReader.Domain.Common;
using BibliaReader.Domain.Enums;

namespace BibliaReader.Domain.Entities;

public class Goal : BaseEntity
{
    public Guid UserId { get; set; }
    public GoalType Type { get; set; }
    public string Title { get; set; } = null!;
    public int? TargetChaptersPerDay { get; set; }
    public DateOnly? Deadline { get; set; }
    public string? BookAbbreviation { get; set; }
    public bool Active { get; set; } = true;
}
