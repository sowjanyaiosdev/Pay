
import Foundation

class CurrencyViewModelApi {
    func fetchCurrencyDetails(completion : @escaping(Result<[CurrencyRate],Error>)-> Void){
        if Utility.isTimeDifferenceMoreThan30Minutes() {
            APIManager.sharedManager.callApiService(type:PaypayEndPointItem.getCurrencyExange(appId: AppConstants.app_id), decodingType: CurrencyModel.self) { result in
                switch result {
                case .success(let currencyModel):
                    print(currencyModel)
                    Utility.saveLastAPICallTime()
                    CoredataLayer().insertCurrencyData(currencyRates: currencyModel)
                    self.fetchCurrencyDetailsFromLocal { result in
                        completion(result)
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }else {
            self.fetchCurrencyDetailsFromLocal { result in
                completion(result)
            }
        }
    }
    func fetchCurrencyDetailsFromLocal(completion : @escaping(Result<[CurrencyRate],Error>)-> Void) {
        CoredataLayer().fetchCurrencyRates { result in
            switch result{
            case .success(let currencyData):
                completion(.success(currencyData))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
}
