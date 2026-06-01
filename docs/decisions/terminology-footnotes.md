> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## Terminology Footnotes

These footnotes document renames applied during the TERMINOLOGY block (Sessions 346-356). See `GLOSSARY.md` for the full terminology standard and "Teacher Replaces Student-Teacher Platform-Wide" decision above for rationale.

[^tc]: `teacher_certifications` — formerly `student_teachers`. Per-course teaching certification records. Renamed Session 349.
[^at]: `assigned_teacher_id` — formerly `student_teacher_id` (enrollments FK). References `users.id`, not `teacher_certifications.id`. Renamed Session 351.
[^it]: `is_teacher` — formerly `is_student_teacher`. Derived boolean, not a stored column. Renamed Session 349.
