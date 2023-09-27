
import UIKit

protocol CurrencySelectionDelegate: AnyObject {
    func didSelectCurrency(_ currencyModel: SelectedCurrency)
}

class CurrencyTableVC: UIViewController {
    weak var delegate: CurrencySelectionDelegate?
    var currencyDataCollection : [CurrencyRate] = []
    var currencyModelObjects : [SelectedCurrency] = []
    
    @IBOutlet weak var currencyTable: UITableView!
    
    override func viewDidLoad() {
        currencyTable.register(UINib(nibName: "CurrencyTableCell", bundle: nil), forCellReuseIdentifier: "currencyCell")
        for currencyDataObj in currencyDataCollection {
            currencyModelObjects.append(.init(code: currencyDataObj.currencyCode ?? "No Code", rate: currencyDataObj.rate))
        }
        currencyTable.accessibilityIdentifier = "currencyTable"
        currencyModelObjects.sort(by: {$0.code < $1.code})
    }
    
    @IBAction func tapOnCancelBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension CurrencyTableVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyModelObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell") as? CurrencyTableCell else { return UITableViewCell()}
        cell.currencyObj = currencyModelObjects[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCurrency(currencyModelObjects[indexPath.row])
        self.dismiss(animated: true)
    }
    
    
}
