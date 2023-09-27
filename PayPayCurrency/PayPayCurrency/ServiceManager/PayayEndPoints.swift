import Foundation
import Alamofire

enum PaypayEndPointItem {
    case getCurrencyExange(appId : String)
}


extension PaypayEndPointItem: EndPointType {
    var headers: HTTPHeaders? {
        return nil
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }

    // MARK: - Vars & Lets
    
    var baseURL: String {
        switch AppConstants.networkEnviroment {
        case .production: return "https://openexchangerates.org/"
        case .stage: return "https://openexchangerates.org/"
        }
    }
    
    var path: String {
        switch self {
            case .getCurrencyExange(let appId):
                return "api/latest.json?app_id=\(appId)"
        }
        
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.path)!
        }
    }
}
