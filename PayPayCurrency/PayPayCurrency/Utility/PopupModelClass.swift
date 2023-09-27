
import Foundation

class CurrencyTableModelVC {
    func modelVC() -> CurrencyTableVC {
        let xib = CurrencyTableVC(nibName: "CurrencyTable", bundle: nil)
        return xib
    }
}
