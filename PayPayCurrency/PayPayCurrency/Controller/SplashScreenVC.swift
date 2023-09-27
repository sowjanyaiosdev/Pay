
import UIKit

class SplashScreenVC: UIViewController {

    @IBOutlet weak var splashView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        gotoIntialVC()
    }

    func gotoIntialVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            guard let currencyVC = self.getViewController(with: .currencyConvertVC, inStoryboard: .main) as? CurrencyConvertViewController else { return }
            self.pushVc(currencyVC)
        }
        
    }
}
