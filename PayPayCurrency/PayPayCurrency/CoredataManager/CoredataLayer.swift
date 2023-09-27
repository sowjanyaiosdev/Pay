import Foundation
import CoreData
protocol CoreDataItems {
    
}
class CoredataLayer:CoreDataItems {
    private static let context = PersistenceManager.shared.context
    
    func insertCurrencyData(currencyRates : CurrencyModel){
        
        for (currencyCode, rate) in currencyRates.rates {
            if let existingCurrencyRate = getCurrencyRate(with: currencyCode) {
                existingCurrencyRate.rate = rate
                existingCurrencyRate.currencyCode = currencyCode
            } else {
                let currencyRate = CurrencyRate(context: CoredataLayer.context)
                currencyRate.currencyCode = currencyCode
                currencyRate.rate = rate
            }
        }
        PersistenceManager.shared.savePesistenceContext()
    }
    func getCurrencyRate(with currencyCode: String) -> CurrencyRate? {
        let fetchRequest: NSFetchRequest<CurrencyRate> = CurrencyRate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)
        
        do {
            let results = try CoredataLayer.context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching currency rate: \(error)")
            return nil
        }
    }
    
    func fetchCurrencyRates(completion: @escaping (Result<[CurrencyRate], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<CurrencyRate> = CurrencyRate.fetchRequest()
        do {
            let records = try CoredataLayer.context.fetch(fetchRequest)
            completion(.success(records))
        } catch {
            completion(.failure(error))
        }
        
    }
}
