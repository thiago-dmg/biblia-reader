using FluentValidation;

namespace BibliaReader.Application.ReadingProgress;

public sealed class PutReadingProgressRequestValidator : AbstractValidator<PutReadingProgressRequest>
{
    public PutReadingProgressRequestValidator()
    {
        RuleFor(x => x.SelectedPlanId)
            .NotEmpty()
            .Must(CanonicalReadingPlanIds.IsValid)
            .WithMessage("selectedPlanId deve ser one-year, six-months ou ninety-days.");

        RuleFor(x => x.CompletedChapterIds)
            .NotNull();

        RuleForEach(x => x.CompletedChapterIds)
            .MaximumLength(32)
            .Matches(@"^[a-z0-9]+-\d+$")
            .WithMessage("chapterKey inválido (esperado: abbrev-num, ex. gn-1).");
    }
}
