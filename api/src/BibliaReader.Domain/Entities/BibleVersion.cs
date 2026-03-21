using BibliaReader.Domain.Common;

namespace BibliaReader.Domain.Entities;

public class BibleVersion : BaseEntity
{
    public string Code { get; set; } = null!;
    public string Name { get; set; } = null!;
    public ICollection<BibleBook> Books { get; set; } = new List<BibleBook>();
}
