
import Foundation
import Alamofire

class APIManager : NSObject {
    static let sharedManager = APIManager()
    
    private override init() {
        super.init()
    }
    
    private let defaultSession: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let session = Session(configuration: configuration)
        return session
    }()
    
    func callApiService<T: Decodable>(type: EndPointType, params: Parameters? = nil, decodingType: T.Type, completion: @escaping (Result<T, AFError>) -> Void) {
        defaultSession.request(type.url,
                   method: type.httpMethod,
                   parameters: params,
                   encoding: type.encoding,
                   headers: type.headers)
        .validate(statusCode: 200...201)
        .responseDecodable { (response: DataResponse<T, AFError>) in
            switch response.result {
            case .success(_):
                if let genericResult = response.value {
                    completion(.success(genericResult))
                } else {
                    completion(.failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}
