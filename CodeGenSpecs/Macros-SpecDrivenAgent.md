# Macro Specification: @SpecDrivenAgent

## Purpose
The `@SpecDrivenAgent` attached macro transforms a plain Swift `actor` into a production-grade AI agent with minimal boilerplate. Under Evolution Strategy B, the macro generates a `DynamicProfile` conformance that configures a `LanguageModelSession` with the agent's tools, instructions, and harness production concerns (permissions, guardrails, recovery).

The macro does **not** generate a tool dispatch loop — Apple's `LanguageModelSession` handles inference, tool calling, transcript management, and streaming natively. The harness adds production capabilities on top via `DynamicProfile` modifiers.

## Requirements
- Swift 6.2+ with strict concurrency checking enabled
- Platforms: macOS 27+, iOS 27+, visionOS 3+
- Dependencies: FoundationModels framework (Apple), SwiftSynapseMacros (this package)
- No `SwiftOpenResponsesDSL` or `SwiftLLMToolMacros` dependency

## Generated Members

The macro generates the following on the annotated actor:

| Member | Kind | Type | Access | Description |
|--------|------|------|--------|-------------|
| `_status` | stored property | `AgentStatus` | `public` | Mutable agent status |
| `_transcript` | stored property | `ObservableTranscript` | `public` | Observable transcript for SwiftUI |
| `status` | computed property | `AgentStatus` | `public` | Read-only accessor |
| `transcript` | computed property | `ObservableTranscript` | `public` | Read-only accessor |
| `run(goal:)` | method | `async throws -> String` | `public` | Entry point — calls `agentRun()` from harness |

The macro also generates an `AgentExecutable` conformance on the actor.

## Generated DynamicProfile (P6)

In addition to the above members, the macro generates a nested `AgentDynamicProfile` struct that configures a `LanguageModelSession`:

```swift
// User writes:
@SpecDrivenAgent
actor WeatherAgent {
    let config: AgentConfiguration

    func execute(goal: String) async throws -> String {
        // Agent-specific logic using AgentSessionRunner
    }
}

// Macro generates:
extension WeatherAgent {
    public var _status: AgentStatus = .idle
    public var _transcript: ObservableTranscript = ObservableTranscript()
    public var status: AgentStatus { _status }
    public var transcript: ObservableTranscript { _transcript }

    public func run(goal: String) async throws -> String {
        try await agentRun(agent: self, goal: goal)
    }

    struct AgentDynamicProfile: LanguageModelSession.DynamicProfile {
        let config: AgentConfiguration
        let tools: [any Tool]

        var body: some DynamicProfile {
            Profile {
                Instructions { config.systemPrompt ?? "You are a helpful assistant." }
                for tool in tools { tool }
            }
            .model(config.model)
            .reasoningLevel(config.reasoningLevel ?? .moderate)
        }
    }
}
```

The `AgentDynamicProfile` is used by agents that want profile-based session configuration. Agents can also create sessions directly via `AgentSessionRunner` if they need more control.

## User Contract

The user must implement:
- `func execute(goal: String) async throws -> String` — the domain-specific logic

The user may optionally declare:
- `let config: AgentConfiguration` — for access to model and settings
- `var hooks: AgentHookPipeline?` — for lifecycle event interception
- `var permissionGate: PermissionGate?` — for tool access control

## Macro Declaration

```swift
@attached(member, names: named(_status), named(_transcript), named(status), named(transcript), named(run), named(AgentDynamicProfile))
@attached(extension, conformances: AgentExecutable)
public macro SpecDrivenAgent() = #externalMacro(module: "SwiftSynapseMacros", type: "SpecDrivenAgentMacro")
```

## Diagnostic

| ID | Severity | Message | Condition |
|----|----------|---------|-----------|
| `requiresActor` | error | `@SpecDrivenAgent can only be applied to an actor` | Declaration is not `ActorDeclSyntax` |

## Implementation Structure

```swift
public struct SpecDrivenAgentMacro: MemberMacro, ExtensionMacro { ... }
```

The macro implementation:
1. Validates the declaration is an actor
2. Generates `_status` and `_transcript` stored properties
3. Generates `status` and `transcript` computed properties
4. Generates `run(goal:)` method calling `agentRun(agent:goal:)`
5. Generates `AgentDynamicProfile` struct conforming to `LanguageModelSession.DynamicProfile`
6. Generates `AgentExecutable` conformance via extension

## Macro Parameters (future)

Current minimal form: `@SpecDrivenAgent` (no arguments)

Future supported arguments:
```swift
@SpecDrivenAgent(
    maxTurns: 15,
    reasoningLevel: .deep,
    systemPrompt: "You are a helpful assistant."
)
```
