using FluentValidation;

namespace BibliaReader.Application.ReadingProgress;

public sealed class PatchReadingProgressRequestValidator : AbstractValidator<PatchReadingProgressRequest>
{
    public PatchReadingProgressRequestValidator()
    {
        RuleFor(x => x.SelectedPlanId)
            .Must(id => id == null || CanonicalReadingPlanIds.IsValid(id))
            .WithMessage("selectedPlanId deve ser one-year, six-months ou ninety-days.");

        When(x => x.CompletedChapterIds != null, () =>
        {
            RuleForEach(x => x.CompletedChapterIds!)
                .MaximumLength(32)
                .Matches(@"^[a-z0-9]+-\d+$")
                .WithMessage("chapterKey inválido (esperado: abbrev-num, ex. gn-1).");
        });
    }
}
