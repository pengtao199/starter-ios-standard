import Foundation

actor URLSessionHTTPClient: HTTPClientProtocol {
    private let session: URLSession
    private let requestBuilder: URLRequestBuilder

    init(
        session: URLSession,
        requestBuilder: URLRequestBuilder
    ) {
        self.session = session
        self.requestBuilder = requestBuilder
    }

    func execute<Response: Decodable & Sendable>(
        _ request: any HTTPRequestConvertible,
        as _: Response.Type
    ) async throws -> Response {
        guard let descriptor = request as? RequestDescriptor else {
            throw NetworkError.invalidRequest
        }

        let urlRequest: URLRequest
        do {
            urlRequest = try requestBuilder.build(from: descriptor)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.invalidRequest
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw NetworkError.transportFailure(description: error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        if descriptor.acceptableStatusCodes.contains(httpResponse.statusCode) == false {
            throw networkError(statusCode: httpResponse.statusCode)
        }

        do {
            return try JSONDecoderFactory.makeDefault().decode(Response.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(description: error.localizedDescription)
        }
    }
}

private extension URLSessionHTTPClient {
    func networkError(statusCode: Int) -> NetworkError {
        switch statusCode {
        case 401:
            .unauthorized
        case 403:
            .forbidden
        case 404:
            .notFound
        default:
            .serverError(statusCode: statusCode, code: nil, message: nil)
        }
    }
}
