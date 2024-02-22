import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func APODButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "APODSegue", sender: self)
    }
}

