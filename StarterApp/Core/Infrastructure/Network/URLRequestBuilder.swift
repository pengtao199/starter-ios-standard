import Foundation

struct URLRequestBuilder {
    let baseURL: URL

    func build(from descriptor: RequestDescriptor) throws -> URLRequest {
        guard let url = resolvedURL(for: descriptor) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = descriptor.method.rawValue

        if let timeoutInterval = descriptor.timeoutInterval {
            request.timeoutInterval = timeoutInterval
        }

        for (header, value) in descriptor.headers {
            request.setValue(value, forHTTPHeaderField: header)
        }

        switch descriptor.body {
        case .none:
            break
        case let .json(data):
            request.httpBody = data
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        case let .data(data, contentType):
            request.httpBody = data
            if let contentType, request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            }
        }

        return request
    }
}

private extension URLRequestBuilder {
    func resolvedURL(for descriptor: RequestDescriptor) -> URL? {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            return nil
        }

        let normalizedPath = descriptor.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let basePath = components.percentEncodedPath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let combinedPath: String

        switch (basePath.isEmpty, normalizedPath.isEmpty) {
        case (true, true):
            combinedPath = ""
        case (false, true):
            combinedPath = basePath
        case (true, false):
            combinedPath = normalizedPath
        case (false, false):
            combinedPath = "\(basePath)/\(normalizedPath)"
        }

        components.percentEncodedPath = combinedPath.isEmpty ? "/" : "/\(combinedPath)"
        components.queryItems = descriptor.queryItems.isEmpty ? nil : descriptor.queryItems
        return components.url
    }
}
