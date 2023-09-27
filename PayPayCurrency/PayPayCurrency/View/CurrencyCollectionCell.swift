import UIKit

class CurrencyCell: UICollectionViewCell {
    let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    let currencyRateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    var currencyObj: SelectedCurrency?{
        didSet {
            currencyCodeLabel.text = currencyObj?.code
            currencyRateLabel.text =  String(format: "%.4f", currencyObj?.rate ?? 0)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(currencyCodeLabel)
        contentView.addSubview(currencyRateLabel)
        
        NSLayoutConstraint.activate([
            currencyCodeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            currencyCodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            currencyCodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            currencyRateLabel.topAnchor.constraint(equalTo: currencyCodeLabel.bottomAnchor, constant: 4),
            currencyRateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            currencyRateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            currencyRateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        
        contentView.backgroundColor = UIColor(red: 0.9, green: 0.95, blue: 1.0, alpha: 1.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4        
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
