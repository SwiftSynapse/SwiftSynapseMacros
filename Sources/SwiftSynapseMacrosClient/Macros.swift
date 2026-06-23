// Generated from CodeGenSpecs/Client-Types.md — Do not edit manually. Update spec and re-generate.

/// Generates an agent scaffold with status tracking, transcript, runtime loop, and DynamicProfile.
/// Attach to an `actor` declaration.
@attached(member, names: named(_status), named(_transcript), named(status), named(transcript), named(run), named(AgentDynamicProfile))
@attached(extension, conformances: AgentExecutable)
public macro SpecDrivenAgent() = #externalMacro(module: "SwiftSynapseMacros", type: "SpecDrivenAgentMacro")

/// Generates an `agentTools()` method that returns `[any Tool]`.
/// Attach to a `struct` or `class` declaration.
@attached(member, names: named(agentTools))
public macro Capability() = #externalMacro(module: "SwiftSynapseMacros", type: "CapabilityMacro")

/// Validates an agent goal prompt at compile time and generates an `AgentGoalMetadata` companion constant.
/// Attach to a `static let` string literal declaration.
@attached(peer, names: arbitrary)
public macro AgentGoal(
    maxTurns: Int = 20,
    temperature: Double = 0.7,
    requiresTools: Bool = false
) = #externalMacro(module: "SwiftSynapseMacros", type: "AgentGoalMacro")
