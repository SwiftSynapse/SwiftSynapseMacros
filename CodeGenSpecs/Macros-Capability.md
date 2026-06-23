# Spec: @Capability Macro

**Generates:** `Sources/SwiftSynapseMacros/CapabilityMacro.swift`

## Purpose

Attach to a `struct` or `class` declaration to generate an `agentTools()` method that returns `[any Tool]`.

## Macro Declaration

```swift
@attached(member, names: named(agentTools))
public macro Capability() = #externalMacro(module: "SwiftSynapseMacros", type: "CapabilityMacro")
```

## Target Type

`struct` or `class`. Emits a diagnostic error if applied to any other declaration kind (e.g., `enum`, `actor`).

## Generated Members

| Member | Kind | Type | Access | Description |
|--------|------|------|--------|-------------|
| `agentTools()` | method | `() -> [any Tool]` | internal | Returns an array of Apple `Tool` protocol conformers |

### Current Implementation

Returns an empty array. Future versions may introspect tool properties and return them automatically.

```swift
func agentTools() -> [any Tool] {
    []
}
```

## Dependencies (Referenced Types)

- `Tool` — from Apple's `FoundationModels` framework

## Diagnostic

| ID | Severity | Message | Condition |
|----|----------|---------|-----------|
| `requiresStructOrClass` | error | `@Capability can only be applied to a struct or class` | Declaration is not `StructDeclSyntax` or `ClassDeclSyntax` |

## Implementation Structure

```swift
public struct CapabilityMacro: MemberMacro { ... }
enum CapabilityDiagnostic: String, DiagnosticMessage { ... }
```
