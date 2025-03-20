import UIKit
import ParseSwift

class PlacesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addPlace))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logout))
    }
    
    @objc func addPlace() {
        // add Button Clicked
        performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }
    
    @objc func logout() {
        User.logout { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        // SignUpVC'nin gerçekten Storyboard'da olup olmadığını kontrol et
                        if let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC {
                            let sceneDelegate = UIApplication.shared.connectedScenes
                                .first?.delegate as? SceneDelegate
                            sceneDelegate?.window?.rootViewController = signUpVC
                            sceneDelegate?.window?.makeKeyAndVisible()
                        } else {
                            print("SignUpVC bulunamadı, Storyboard ID'yi kontrol et!")
                        }
                    }

                case .failure(let error):
                    print("Çıkış hatası: \(error.localizedDescription)")
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                }
            }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}
