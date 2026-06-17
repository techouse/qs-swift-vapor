---
name: Bug report
about: The Vapor integration crashes, parses query parameters incorrectly, or behaves unexpectedly.
title: ''
labels: bug
assignees: techouse
---

<!--
  QsSwiftVapor is a thin Vapor integration for QsSwift. If the issue is about
  core query-string decode semantics, please check QsSwift as well:
  https://github.com/techouse/qs-swift/issues
-->

## Summary

<!-- A clear and concise description of what the bug is. -->

## Steps to Reproduce

<!-- Include full steps so we can reproduce the problem. Prefer a minimal repro. -->

1. ...
2. ...
3. ...

**Expected result**
<!-- What did you expect to happen? -->

**Actual result**
<!-- What actually happened? Include exact output / parsed values where relevant. -->

## Minimal Reproduction

> The simplest way is a single XCTVapor test that fails.
> Create a tiny SwiftPM package or add a test to your Vapor project demonstrating the issue.

<details>
<summary>Failing XCTVapor test</summary>

```swift
import QsSwiftVapor
import XCTest
import XCTVapor

final class ReproTests: XCTestCase {
    private var app: Application!

    override func setUp() async throws {
        app = try await Application.make(.testing)
    }

    override func tearDown() async throws {
        try await app.asyncShutdown()
        app = nil
    }

    func testRepro() throws {
        let request = Request(
            application: app,
            method: .GET,
            url: URI(string: "/search?a%5Bb%5D=1"),
            on: app.eventLoopGroup.next()
        )

        let decoded = try request.parseQsQuery()
        let object = try XCTUnwrap(decoded["a"] as? [String: Any])
        XCTAssertEqual(object["b"] as? String, "1")
    }
}
```
</details>

If the issue only appears with particular QsSwift decode options, include the exact options used:

```swift
let decoded = try request.parseQsQuery(
    options: .init(strictNullHandling: true)
)
```

## Logs

Please include relevant logs:

- SwiftPM build + tests:
  ```bash
  swift build -v
  swift test -v
  ```

- If you created a small demo package, include the full console output from the failing run.

- If a specific query string causes the issue, paste that exact string together with the actual and expected decoded structure.

<details>
<summary>Console output</summary>

```
# paste here
```
</details>

## Environment

- OS: <!-- e.g., macOS 15.5 / Ubuntu 24.04 -->
- Swift: output of `swift --version`
- Xcode: <!-- e.g., 16.4, if applicable -->
- SwiftPM: <!-- e.g., 6.1, or "via Xcode" -->
- QsSwiftVapor version: <!-- e.g., 0.1.0 -->
- QsSwift version: <!-- e.g., 1.4.0 -->
- Vapor version: <!-- e.g., 4.121.4 -->
- Deployment target: <!-- e.g., macOS 12+ -->

### Dependency snippet (SwiftPM)

```text
# In your Package.swift dependencies section
dependencies: [
    // ...
    .package(url: "https://github.com/techouse/qs-swift-vapor.git", from: "<version>")
]
```

```text
# In your Package.swift target dependencies
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "QsSwiftVapor", package: "qs-swift-vapor")
    ]
)
```

## Is this a regression?

- Did this work in a previous version of QsSwiftVapor? If so, which version?

## Additional context

- Links to related QsSwift or Vapor issues:
- Any middleware, custom request handling, or route setup involved:
- Edge cases involved, such as duplicate keys, empty values, name-only values, custom delimiters, or bracket notation:
