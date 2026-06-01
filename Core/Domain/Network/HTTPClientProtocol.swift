import Foundation

protocol HTTPRequestConvertible: Sendable {}

protocol HTTPClientProtocol: Sendable {
    func execute<Response: Decodable & Sendable>(
        _ request: any HTTPRequestConvertible,
        as type: Response.Type
    ) async throws -> Response
}
