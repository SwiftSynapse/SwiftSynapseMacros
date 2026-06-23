# Spec: @StructuredOutput Macro — RETIRED (Evolution P4)

> **This spec is retired.** `@StructuredOutput` is removed entirely in Evolution P4.
> Use Apple's `@Generable` + `@Guide` macros for structured output with constrained decoding.
>
> **Migration:**
> ```swift
> // Before (SwiftSynapse)
> @StructuredOutput
> struct VocabCard {
>     let term: String
>     let definition: String
> }
>
> // After (Apple's API)
> @Generable
> struct VocabCard {
>     @Guide(description: "The vocabulary term")
>     var term: String
>     @Guide(description: "The definition of the term")
>     var definition: String
> }
> ```
>
> **Files to delete:** `StructuredOutputMacro.swift`, `TextFormat.swift`
> **See also:** `Docs-StructuredOutput.md`, `Docs-HowTo-StructuredOutput.md` (also retired)
