# QsSwiftVapor

Small Vapor integration for [QsSwift](https://github.com/techouse/qs-swift).

[![SwiftPM version](https://img.shields.io/github/v/release/techouse/qs-swift-vapor?logo=swift&label=SwiftPM)](https://github.com/techouse/qs-swift-vapor/releases/latest)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftechouse%2Fqs-swift-vapor%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/techouse/qs-swift-vapor)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftechouse%2Fqs-swift-vapor%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/techouse/qs-swift-vapor)
[![License](https://img.shields.io/github/license/techouse/qs-swift-vapor)](LICENSE)
[![Test](https://github.com/techouse/qs-swift-vapor/actions/workflows/test.yml/badge.svg)](https://github.com/techouse/qs-swift-vapor/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/techouse/qs-swift-vapor/graph/badge.svg?token=kTTCSYGcej)](https://codecov.io/gh/techouse/qs-swift-vapor)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/54ba6b2d7f724636904088e7e74ec53a)](https://app.codacy.com/gh/techouse/qs-swift-vapor/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/techouse)](https://github.com/sponsors/techouse)
[![GitHub Repo stars](https://img.shields.io/github/stars/techouse/qs-swift)](https://github.com/techouse/qs-swift-vapor/stargazers)

`QsSwiftVapor` adds one request helper that parses the request's encoded query string with QsSwift, bypassing Vapor's
typed query container when you need qs-compatible nested query-string behavior.

## Installation

Add the package to your SwiftPM dependencies:

```swift
.package(url: "https://github.com/techouse/QsSwiftVapor.git", from: "1.0.0")
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
