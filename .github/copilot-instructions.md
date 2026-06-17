# Copilot Instructions for QsSwiftVapor

These guidelines help AI coding agents work effectively in this repository.
Keep responses concise, follow established patterns, and prefer making the change directly when the task is clear.

## 1. Project Overview

- Library: Thin Vapor integration for QsSwift query-string decoding.
- Target: `QsSwiftVapor`.
- Public API: `Request.parseQsQuery(options:) throws -> [String: Any]`.
- Purpose: Read `request.url.query ?? ""` directly and pass the percent-encoded query string to `Qs.decode`.

## 2. Architecture and Key Files

- `Sources/QsSwiftVapor/Request+QsQuery.swift` contains the public Vapor request extension.
- `Tests/QsSwiftVaporTests/RequestQsQueryTests.swift` covers decode parity and Vapor request behavior.
- `Package.swift` declares dependencies on `QsSwift` and `Vapor`; tests use `XCTVapor`.

## 3. Conventions

- Keep the integration intentionally thin. Do not add middleware, route builders, typed query decoding, or Vapor `URI` query builders unless the change is explicitly requested and justified.
- Preserve QsSwift semantics for duplicate keys, empty values, name-only values, custom delimiters, percent-encoded brackets, and nested lists/objects.
- Do not route parsing through Vapor's typed `req.query` APIs. The point of this package is to bypass Vapor's query decoder when QsSwift behavior is required.
- Keep public API naming centered on `Request.parseQsQuery(options:)`.

## 4. Testing Guidelines

- Run `swift build -c debug --build-tests` before broad changes.
- Run `swift test` for package validation.
- Add focused XCTVapor tests for behavior changes.
- Compare expected behavior against direct `Qs.decode(query, options:)` calls when validating integration parity.

## 5. Adding Features

When adding behavior:

1. Keep the public surface minimal and explain why it belongs in QsSwiftVapor rather than QsSwift.
2. Add or update XCTVapor tests that exercise real `Request` values.
3. Update README examples for user-facing changes.
4. Avoid expanding into URL construction helpers; use QsSwift's Foundation URL helpers for URL construction.

## 6. Error Handling

- Do not swallow `Qs.decode` errors.
- Let `Request.parseQsQuery(options:)` propagate thrown errors unchanged unless a requested API explicitly needs a different error shape.

## 7. Style and Hygiene

- Use 4-space indentation.
- Keep edits focused and avoid broad reformatting.
- Prefer small extensions over new abstractions unless duplication or API growth makes the abstraction necessary.

## 8. Pull Request Expectations

- Include a concise summary.
- Include validation steps, normally `swift build -c debug --build-tests` and `swift test`.
- Mention any changed QsSwift or Vapor compatibility assumptions.

## 9. Quick Command Reference

- Build tests: `swift build -c debug --build-tests`
- Run tests: `swift test`

If something is unclear, surface a concise question with the practical options and a recommended default.
