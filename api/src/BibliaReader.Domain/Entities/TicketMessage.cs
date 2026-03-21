using BibliaReader.Domain.Common;

namespace BibliaReader.Domain.Entities;

public class TicketMessage : BaseEntity
{
    public Guid SupportTicketId { get; set; }
    public SupportTicket SupportTicket { get; set; } = null!;
    public Guid SenderUserId { get; set; }
    public bool IsStaff { get; set; }
    public string Body { get; set; } = null!;
}
