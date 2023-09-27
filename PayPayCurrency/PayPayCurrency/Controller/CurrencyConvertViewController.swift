import UIKit

struct SelectedCurrency {
    var code : String
    var rate : Double
}

class CurrencyConvertViewController: UIViewController {
    @IBOutlet weak var amountEnterTF: AmountTextField!
    @IBOutlet weak var currencySelectBtn: CustomButton!
    @IBOutlet weak var currencyConvertCollectionVW: UICollectionView!
    var selectedCurrency: SelectedCurrency = .init(code: "USD", rate: 1)
    var currencyData : [CurrencyRate] = []
    var currencyCaluculateModelObject : [SelectedCurrency] = []
    
    lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Check Amount Conversion"
        
        amountEnterTF.numberDelegate = self
        currencySelectBtn.addTarget(self, action: #selector(selectCurrency), for: .touchUpInside)
        currencySelectBtn.setTitle(selectedCurrency.code, for: .normal)
        currencyConvertCollectionVW.register(CurrencyCell.self, forCellWithReuseIdentifier: "CurrencyCell")
       collectionFlowLayout()
        currencyConvertCollectionVW.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        fetchCurrencyDetails()
    }
    
    func collectionFlowLayout(){
        currencyConvertCollectionVW.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
    }
    
    func updateValues(with amount:String){
        currencySelectBtn.setTitle(selectedCurrency.code, for: .normal)
        let filterCurrencyValues = currencyData.filter({$0.currencyCode != selectedCurrency.code})
        currencyCaluculateModelObject.removeAll()
        for currency in filterCurrencyValues {
            guard let code = currency.currencyCode else { continue }
            let convertedValue = ((Double(amount) ?? 0)/selectedCurrency.rate) * currency.rate
            currencyCaluculateModelObject.append(.init(code: code, rate: convertedValue))
        }
        currencyCaluculateModelObject.sort(by: {$0.code < $1.code})
        self.currencyConvertCollectionVW.reloadData()
    }
    
    func fetchCurrencyDetails() {
        CurrencyViewModelApi().fetchCurrencyDetails { [unowned self] result in
            switch result {
            case .success(let currencyData):
                self.currencyData = currencyData
            case .failure(let error):
                print(error)
            }
            self.updateValues(with: "1")
        }
    }
}

extension CurrencyConvertViewController: AmountTextFieldDelegate,CurrencySelectionDelegate {
    @objc func selectCurrency() {
        let currencyModelVc = CurrencyTableModelVC()
        let tableVC = currencyModelVc.modelVC()
        tableVC.delegate = self
        tableVC.currencyDataCollection = currencyData
        tableVC.modalPresentationStyle = .overCurrentContext
        present(tableVC, animated: true)
        
    }
    func numberTextFieldDidEndEditing(_ textField: AmountTextField, value: String?) {
        updateValues(with: value ?? "0")
    }
    func didSelectCurrency(_ currencyModel: SelectedCurrency) {
        selectedCurrency = currencyModel
        updateValues(with: amountEnterTF.text ?? "0")
    }
}

extension CurrencyConvertViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencyCaluculateModelObject.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let currencyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrencyCell", for: indexPath) as? CurrencyCell else {
            return UICollectionViewCell()
        }
        
        currencyCell.currencyObj = currencyCaluculateModelObject[indexPath.item]
        
        return currencyCell
    }
    
    
    
}
extension CurrencyConvertViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let screenWidth = UIScreen.main.bounds.width
            let numberOfItemsPerRow: CGFloat = screenWidth >= 375 ? 4 : 6
            let spacing: CGFloat = 5
            let totalSpacing = (numberOfItemsPerRow - 1) * spacing
            let availableWidth = screenWidth - totalSpacing
            let itemWidth = availableWidth / numberOfItemsPerRow
            let itemHeight: CGFloat = 50
            return CGSize(width: itemWidth, height: itemHeight)
        }
}
