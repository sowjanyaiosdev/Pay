import Foundation

enum NetworkEnvironment {
    case production
    case stage
}
struct AppConstants {
    static let app_id = "dbe49ce2947a4514b64d79cf956ad2c2"
    static let networkEnviroment: NetworkEnvironment = .production
}

