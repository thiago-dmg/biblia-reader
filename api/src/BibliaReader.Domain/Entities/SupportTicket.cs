using BibliaReader.Domain.Common;
using BibliaReader.Domain.Enums;

namespace BibliaReader.Domain.Entities;

public class SupportTicket : BaseEntity
{
    public Guid UserId { get; set; }
    public string Subject { get; set; } = null!;
    public SupportTicketStatus Status { get; set; } = SupportTicketStatus.Open;
    public ICollection<TicketMessage> Messages { get; set; } = new List<TicketMessage>();
}
