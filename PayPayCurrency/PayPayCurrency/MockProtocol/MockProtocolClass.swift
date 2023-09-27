
import Foundation
#if DEBUG
class MockURLProtoCol : URLProtocol {
    static var tasks : Set<URLSessionTask> = []
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canInit(with task: URLSessionTask) -> Bool {
        tasks.insert(task)
        return true
    }
    override func stopLoading() {
        
    }
    
    override func startLoading() {
        if let url = request.url {
            let pathString : String
            
            if let queryStr = url.query(){
                pathString = url.relativePath + queryStr
            }else{
                pathString = url.relativePath
            }
            
            let data = MockDataClass.dataForPath(pathString)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocol(self, didReceive: HTTPURLResponse(), cacheStoragePolicy: .allowed)
            
        }
        client?.urlProtocolDidFinishLoading(self)
    }
}

class MockDataClass {
    static var mockData : [String : Data] = [:]
    
    static func loadData(){
        if mockData.isEmpty == false {
            return
        }
                
        if let mockJsonPath = Bundle.main.path(forResource: "CurrencyData", ofType: "json", inDirectory: "MockJson") {
                    if let data = FileManager.default.contents(atPath: mockJsonPath) {
                        // Store the complete path as the key in the mockData dictionary
                        mockData[mockJsonPath] = data
                    } else {
                        print("Error: Failed to read data from CurrencyData.json")
                    }
                } else {
                    print("Error: CurrencyData.json not found in the MockJson folder.")
                }
        
    }
    
    static func dataForPath(_ path : String) -> Data{
        loadData()
        let data = mockData.first { (key: String, value: Data) in
            path.hasPrefix(key)
        }
        if let dataForPath = data?.value {
            return dataForPath
        }
        return Data()
        
    }
}
#endif

