import Foundation

enum NetworkError: Error, Equatable, Sendable {
    case invalidURL
    case invalidRequest
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case decodingFailed(description: String)
    case transportFailure(description: String)
    case serverError(statusCode: Int, code: String?, message: String?)
}
