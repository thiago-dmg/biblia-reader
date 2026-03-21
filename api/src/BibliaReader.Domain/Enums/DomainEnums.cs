namespace BibliaReader.Domain.Enums;

public enum ReadingScopeType
{
    WholeBible = 0,
    NewTestament = 1,
    OldTestament = 2,
    SingleBook = 3,
    CustomList = 4
}

public enum ReadingPaceMode
{
    ChaptersPerDay = 0,
    FinishByDate = 1,
    DurationDays = 2
}

public enum GoalType
{
    DailyChapters = 0,
    FinishBookByDate = 1,
    ReadingStreak = 2,
    WeeklyTarget = 3,
    MonthlyTarget = 4
}

public enum PostVisibility
{
    Public = 0,
    FollowersOnly = 1
}

public enum SupportTicketStatus
{
    Open = 0,
    InProgress = 1,
    Resolved = 2,
    Closed = 3
}
