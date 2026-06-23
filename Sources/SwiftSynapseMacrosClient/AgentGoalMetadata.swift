// Generated from CodeGenSpecs/Client-Types.md — Do not edit manually. Update spec and re-generate.

public struct AgentGoalMetadata: Sendable {
    public let maxTurns: Int
    public let temperature: Double
    public let requiresTools: Bool
    public let validatedPrompt: String

    public init(
        maxTurns: Int,
        temperature: Double,
        requiresTools: Bool,
        validatedPrompt: String
    ) {
        self.maxTurns = maxTurns
        self.temperature = temperature
        self.requiresTools = requiresTools
        self.validatedPrompt = validatedPrompt
    }
}
