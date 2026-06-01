import Foundation

enum JSONDecoderFactory {
    static func makeDefault() -> JSONDecoder {
        JSONDecoder()
    }
}
