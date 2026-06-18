import Foundation
import QsSwift
import QsSwiftVapor
import XCTVapor

final class RequestQsQueryTests: XCTestCase {
  private var app: Application!

  override func setUp() async throws {
    app = try await Application.make(.testing)
  }

  override func tearDown() async throws {
    try await app.asyncShutdown()
    app = nil
  }

  func testEmptyAndMissingQueryReturnEmptyMap() throws {
    let missing = makeRequest(path: "/search")
    XCTAssertQsEqual(try missing.parseQsQuery(), [:])

    let empty = makeRequest(path: "/search?")
    XCTAssertQsEqual(try empty.parseQsQuery(), [:])

    empty.url.query = ""
    XCTAssertQsEqual(try empty.parseQsQuery(), [:])
  }

  func testSimpleQueryMatchesDirectDecode() throws {
    try assertMatchesDirectDecode("hello=world&answer=42")
  }

  func testNestedArraysAndObjectsMatchDirectDecode() throws {
    try assertMatchesDirectDecode("filter%5Bwhere%5D%5Bname%5D=John&tags%5B0%5D=a&tags%5B1%5D=b")
    try assertMatchesDirectDecode("items%5B0%5D%5Bid%5D=1&items%5B1%5D%5Bid%5D=2")
  }

  func testDuplicateKeysRespectDecodeOptions() throws {
    let query = "tag=swift&tag=vapor"

    XCTAssertQsEqual(
      try parse(query, options: .init(duplicates: .combine)),
      try Qs.decode(query, options: .init(duplicates: .combine))
    )
    XCTAssertQsEqual(
      try parse(query, options: .init(duplicates: .first)),
      try Qs.decode(query, options: .init(duplicates: .first))
    )
    XCTAssertQsEqual(
      try parse(query, options: .init(duplicates: .last)),
      try Qs.decode(query, options: .init(duplicates: .last))
    )
  }

  func testEmptyAndNameOnlyValues() throws {
    let defaultResult = try parse("foo&bar=")
    XCTAssertQsEqual(defaultResult, ["foo": "", "bar": ""])

    let strictResult = try parse("foo&bar=", options: .init(strictNullHandling: true))
    XCTAssertTrue(strictResult["foo"] is NSNull)
    XCTAssertQsEqual(strictResult["bar"], "")
  }

  func testPercentEncodedBracketsSpacesAndSpecialCharacters() throws {
    try assertMatchesDirectDecode("emailsToSearch%5B%5D=xyz")
    try assertMatchesDirectDecode("q=hello%20world&literal=%2Bplus%26amp%3Dequals")
  }

  func testCustomDelimiter() throws {
    let query = "a=1;b%5Bc%5D=2;b%5Bd%5D=3"
    let options = DecodeOptions(delimiter: StringDelimiter(";"))

    XCTAssertQsEqual(
      try parse(query, options: options),
      try Qs.decode(query, options: options)
    )
  }

  func testRequestPathDoesNotAffectParsing() throws {
    let request = makeRequest(
      path: "/api/products/search?filter%5Bname%5D=Vapor&tag=swift&tag=server")

    XCTAssertQsEqual(
      try request.parseQsQuery(),
      try Qs.decode("filter%5Bname%5D=Vapor&tag=swift&tag=server")
    )
  }

  private func assertMatchesDirectDecode(
    _ query: String,
    options: DecodeOptions = .init(),
    file: StaticString = #filePath,
    line: UInt = #line
  ) throws {
    XCTAssertQsEqual(
      try parse(query, options: options),
      try Qs.decode(query, options: options),
      file: file,
      line: line
    )
  }

  private func parse(
    _ query: String,
    options: DecodeOptions = .init()
  ) throws -> [String: Any] {
    try makeRequest(path: "/search?\(query)").parseQsQuery(options: options)
  }

  private func makeRequest(path: String) -> Request {
    Request(
      application: app,
      method: .GET,
      url: URI(string: path),
      on: app.eventLoopGroup.next()
    )
  }
}

private func XCTAssertQsEqual(
  _ lhs: Any?,
  _ rhs: Any?,
  file: StaticString = #filePath,
  line: UInt = #line
) {
  if !qsEqual(lhs, rhs) {
    XCTFail(
      "Values are not equal:\nleft: \(String(describing: lhs))\nright: \(String(describing: rhs))",
      file: file,
      line: line
    )
  }
}

private func qsEqual(_ lhs: Any?, _ rhs: Any?) -> Bool {
  switch (lhs, rhs) {
  case (nil, nil):
    return true
  case (let left as NSNull, let right as NSNull):
    return left === right || type(of: left) == type(of: right)
  case (let left as String, let right as String):
    return left == right
  case (let left as Int, let right as Int):
    return left == right
  case (let left as Double, let right as Double):
    return left == right
  case (let left as Bool, let right as Bool):
    return left == right
  case (let left as NSNumber, let right as NSNumber):
    return left == right
  case (let left as [String: Any], let right as [String: Any]):
    guard left.keys == right.keys else {
      return false
    }

    return left.allSatisfy { key, value in
      qsEqual(value, right[key])
    }
  case (let left as [Any], let right as [Any]):
    guard left.count == right.count else {
      return false
    }

    return zip(left, right).allSatisfy(qsEqual)
  default:
    return String(describing: lhs) == String(describing: rhs)
  }
}
