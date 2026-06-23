// Generated from CodeGenSpecs/Client-Types.md — Do not edit manually. Update spec and re-generate.
import Foundation
import Observation

public enum TranscriptEntry: Sendable {
    case userMessage(String)
    case assistantMessage(String)
    case toolCall(name: String, arguments: String)
    case toolResult(name: String, result: String, duration: Duration)
    case reasoning
    case error(String)
}

@Observable
public final class ObservableTranscript: @unchecked Sendable {
    public private(set) var entries: [TranscriptEntry] = []
    public private(set) var isStreaming: Bool = false
    public private(set) var streamingText: String = ""
    public private(set) var toolProgress: [String: ToolProgressUpdate] = [:]

    public init() {}

    public func sync(from transcript: [TranscriptEntry]) {
        entries = transcript
    }

    public func append(_ entry: TranscriptEntry) {
        entries.append(entry)
    }

    public func setStreaming(_ streaming: Bool) {
        isStreaming = streaming
        if !streaming {
            streamingText = ""
        }
    }

    public func appendDelta(_ text: String) {
        streamingText += text
    }

    public func updateToolProgress(_ update: ToolProgressUpdate) {
        toolProgress[update.callId] = update
    }

    public func clearToolProgress(callId: String) {
        toolProgress.removeValue(forKey: callId)
    }

    public func reset() {
        entries = []
        isStreaming = false
        streamingText = ""
        toolProgress = [:]
    }

    public func restore(entries: [TranscriptEntry]) {
        self.entries = entries
        self.isStreaming = false
        self.streamingText = ""
    }

}
