import Foundation

extension Encodable {
  func toJSONString() -> String? {
    let encoder = JSONEncoder()
    guard let data = try? encoder.encode(self) else {
      return nil
    }
    return String(data: data, encoding: .utf8)
  }
}

extension Decodable {
  static func decode(using jsonString: String) -> Self? {
    let decoder = JSONDecoder()
    return try? decoder.decode(Self.self, from: Data(jsonString.utf8))
  }
}
