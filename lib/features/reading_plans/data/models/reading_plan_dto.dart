/// DTO espelhando contrato API — mapear para [ReadingPlan] no repositório.
class ReadingPlanDto {
  const ReadingPlanDto({required this.id, required this.raw});

  final String id;
  final Map<String, dynamic> raw;
}
