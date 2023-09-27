import Foundation

struct Utility {
    private static let lastAPICallTimeKey = "lastAPICallTime"
    
    static func saveLastAPICallTime() {
        let currentTime = Date().timeIntervalSince1970
        UserDefaults.standard.set(currentTime, forKey: lastAPICallTimeKey)
    }
    
    static func getLastAPICallTime() -> Double? {
        return UserDefaults.standard.double(forKey: lastAPICallTimeKey)
    }
    
    static func isTimeDifferenceMoreThan30Minutes() -> Bool {
        guard let lastAPICallTime = getLastAPICallTime(), lastAPICallTime > 0 else {
            return true
        }
        
        let currentTime = Date().timeIntervalSince1970
        let timeDifference = currentTime - lastAPICallTime
        let thirtyMinutesInSeconds: TimeInterval = 30 * 60
        
        return timeDifference >= thirtyMinutesInSeconds
    }
}
