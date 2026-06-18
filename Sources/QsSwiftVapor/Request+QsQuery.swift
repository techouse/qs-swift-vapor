import QsSwift
import Vapor

public extension Request {
    /// Parses this request's percent-encoded query string with QsSwift.
    ///
    /// This reads `url.query` directly and intentionally does not use Vapor's
    /// typed `query` container, so QsSwift controls duplicate-key, empty-value,
    /// name-only, delimiter, and bracket-notation semantics.
    func parseQsQuery(
        options: DecodeOptions = .init()
    ) throws -> [String: Any] {
        try Qs.decode(url.query ?? "", options: options)
    }
}
