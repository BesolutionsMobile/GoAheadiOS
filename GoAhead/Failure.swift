// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let failure = try? newJSONDecoder().decode(Failure.self, from: jsonData)

import Foundation
import Alamofire
// MARK: - Failure
struct Failure: Codable ,Error{
    let status: Int
    let message: String
}
