using FluentValidation;

namespace BibliaReader.Application.ReadingPlans;

public sealed class CreateReadingPlanRequestValidator : AbstractValidator<CreateReadingPlanRequest>
{
    public CreateReadingPlanRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().MaximumLength(200);
    }
}
