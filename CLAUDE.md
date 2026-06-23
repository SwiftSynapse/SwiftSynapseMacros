# SwiftSynapseMacros

## Project Overview

SwiftSynapseMacros provides Swift macros and core types for the SwiftSynapse ecosystem. It generates agent scaffolding (`@SpecDrivenAgent`, `@Capability`, `@AgentGoal`) and provides foundational types used by macro-generated code and SwiftUI views.

The agent harness (tool loop, hooks, permissions, streaming, recovery, MCP, etc.) lives in [SwiftSynapseHarness](https://github.com/RichNasz/SwiftSynapseHarness).

## Commands

- **Build**: `swift build`
- **Test**: `swift test`
- **Test (verbose)**: `swift test --verbose`
- **Clean**: `swift package clean`

## Architecture

### Three-Target Structure

1. **SwiftSynapseMacros** (macro target) - Compiler plugin
   - `Plugin.swift` - `@main` CompilerPlugin entry point
   - `SpecDrivenAgentMacro.swift` - Agent scaffold + AgentDynamicProfile generation
   - `CapabilityMacro.swift` - Tool bridging (`[any Tool]`)
   - `AgentGoalMacro.swift` - Goal validation and metadata generation
   - **SwiftSyntax only** — no sibling package imports

2. **SwiftSynapseMacrosClient** (client target) - Core types + macro declarations
   - `Macros.swift` - `#externalMacro` declarations
   - `AgentExecutable.swift` - Protocol for @SpecDrivenAgent actors + AgentLifecycleError
   - `AgentStatus.swift` - Shared agent status enum
   - `Transcript.swift` - `TranscriptEntry` enum + `@Observable` transcript for SwiftUI
   - `AgentGoalMetadata.swift` - Goal metadata struct
   - `ToolProgressUpdate.swift` - Tool progress data type

3. **SwiftSynapseMacrosTests** (test target)
   - XCTest-based macro expansion tests (`assertMacroExpansion`)

### Key Design Decisions

- **Macro target is SwiftSyntax-only**: The compiler plugin cannot import sibling packages.
- **No external re-exports**: SwiftLLMToolMacros and SwiftOpenResponsesDSL dependencies removed (Evolution P1, P4).
- **Harness is separate**: The agent runtime (`agentRun()`), session runner, hooks, and all production capabilities live in SwiftSynapseHarness. Users typically `import SwiftSynapseHarness` which re-exports this package.
- **Actor-only agents**: `@SpecDrivenAgent` enforces `actor` declarations at compile time.
- **Strategy B**: Tools use Apple's `Tool` protocol. `@StructuredOutput` retired in favor of `@Generable`.

## Spec-Driven Workflow

All `.swift` files in `Sources/` and `Tests/` are generated from specs in `CodeGenSpecs/`. Specs are the single source of truth.

1. Edit the relevant spec in `CodeGenSpecs/`
2. Re-generate the corresponding `.swift` file(s)
3. Run `swift build && swift test` to verify
4. Commit both spec and generated files together

**Never edit generated `.swift` files directly.**

## File Structure

```
Sources/
  SwiftSynapseMacros/                # Compiler plugin (SwiftSyntax only)
    Plugin.swift
    SpecDrivenAgentMacro.swift
    CapabilityMacro.swift
    AgentGoalMacro.swift
  SwiftSynapseMacrosClient/         # Core types + macro declarations
    Macros.swift
    AgentExecutable.swift
    AgentStatus.swift
    Transcript.swift
    AgentGoalMetadata.swift
    ToolProgressUpdate.swift
Tests/
  SwiftSynapseMacrosTests/
    MacroExpansionTests.swift
    AgentGoalMacroTests.swift
CodeGenSpecs/
  Overview.md
  Macros-SpecDrivenAgent.md
  Macros-StructuredOutput.md (retired)
  Macros-Capability.md
  Macros-AgentGoal.md
  Client-Types.md
  Tests.md
  README-Generation.md
```

## Dependencies

- [swift-syntax](https://github.com/swiftlang/swift-syntax) >= 602.0.0

## Requirements

- Swift 6.4+
- macOS 27+ / iOS 27+ / visionOS 26+

## Testing Strategy

- **Macro expansion tests** use `assertMacroExpansion` from SwiftSyntaxMacrosTestSupport (XCTest)
- Tests cover: correct member/peer generation, diagnostic errors for wrong declaration kinds, compile-time validation

## Claude Code Files

Only `CLAUDE.md` is tracked. The `.claude/` directory is gitignored.
