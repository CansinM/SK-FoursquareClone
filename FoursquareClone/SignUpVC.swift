//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Cansın Memiş on 5.03.2025.
//

import UIKit
import ParseSwift

class SignUpVC: UIViewController {
    /*
    struct Fruits: ParseObject {
        // Parse için gerekli zorunlu alanlar
        var objectId: String?
        var createdAt: Date?
        var updatedAt: Date?
        var ACL: ParseACL?
        var originalData: Data?

        // Özel alanlar (Parse veritabanındaki kolon adlarıyla aynı olmalı)
        var name: String?
        var calories: Int?
    }
     */
    
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /*
    func saveFruit() {
        var fruit = Fruits()
        fruit.name = "Apple"
        fruit.calories = 100

        fruit.save { result in
            switch result {
            case .success(let savedObject):
                print("Başarıyla kaydedildi: \(savedObject)")
            case .failure(let error):
                print("Hata oluştu: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchFruits() {
        Fruits.query()
            .find { result in
                switch result {
                case .success(let objects):
                    print("Gelen Veriler: \(objects)")
                case .failure(let error):
                    print("Hata oluştu: \(error.localizedDescription)")
                }
            }
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        saveFruit()
        fetchFruits()
    }
    */
    
    @IBAction func signInClicked(_ sender: Any) {
        guard let username = userNameText.text, !username.isEmpty,
                  let password = passwordText.text, !password.isEmpty else {
                makeAlert(title: "Error", message: "Username / password boş bırakılamaz!")
                return
            }

            // Kullanıcıyı Parse üzerinden giriş yaptırma
            User.login(username: username, password: password) { result in
                switch result {
                case .success(let user):
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)

                case .failure(let error):
                    print("Giriş hatası: \(error.localizedDescription)")
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                }
            }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
            // Kullanıcıyı Parse-Swift ile kaydetme
        guard let username = userNameText.text, !username.isEmpty,
                  let password = passwordText.text, !password.isEmpty else {
                makeAlert(title: "Error", message: "Username / password boş bırakılamaz!")
                return
            }

            // Yeni kullanıcı nesnesi oluştur
            var newUser = User()
            newUser.username = username
            newUser.password = password

            // Kullanıcıyı Parse üzerine kaydet
            newUser.signup { result in
                switch result {
                case .success(let user):
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)

                case .failure(let error):
                    print("Kayıt hatası: \(error.localizedDescription)")
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

