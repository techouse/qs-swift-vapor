# QsSwiftVapor

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/2fb89aed915d4c4ea82be66cdc70de47)](https://app.codacy.com/gh/techouse/qs-swift-vapor?utm_source=github.com&utm_medium=referral&utm_content=techouse/qs-swift-vapor&utm_campaign=Badge_Grade)

Small Vapor integration for [QsSwift](https://github.com/techouse/qs-swift).

`QsSwiftVapor` adds one request helper that parses the request's encoded query string with QsSwift, bypassing Vapor's
typed query container when you need qs-compatible nested query-string behavior.

## Installation

Add the package to your SwiftPM dependencies:

```swift
.package(url: "https://github.com/techouse/QsSwiftVapor.git", from: "0.1.0")
```

Then add the product to your Vapor target:

```swift
.product(name: "QsSwiftVapor", package: "QsSwiftVapor")
```

## Usage

```swift
import QsSwift
import QsSwiftVapor
import Vapor

app.get("search") { req async throws -> [String: String] in
    let query = try req.parseQsQuery(
        options: DecodeOptions(strictNullHandling: true)
    )

    return [
        "parsed": String(describing: query),
    ]
}
```

`parseQsQuery(options:)` reads `req.url.query` and passes it directly to `Qs.decode`. It does not use `req.query`, so
Vapor's form decoder does not collapse duplicate keys, reinterpret name-only parameters as boolean flags, or apply
Vapor-specific typed decoding behavior.

## Non-goals

- No typed `Decodable` query helper.
- No middleware or global query decoder configuration.
- No Vapor `URI` query-building helper.

Use QsSwift's Foundation `URLComponents` and `URL` helpers for URL construction.
