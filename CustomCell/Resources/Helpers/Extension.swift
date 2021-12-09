//
//  ButtonExtension.swift
//  CustomCell
//
//  Created by Anirudha SM on 15/11/21.
//

import UIKit

extension Date{
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
}

extension UIViewController {
    
    func configureNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.backgroundColor = ColorConstants.navigationBackground
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func passwordValidation(password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$")
        return passwordRegex.evaluate(with: password)
    }
    
    func emailValidation(email: String) -> Bool {
        let emailRegex = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}")
        return emailRegex.evaluate(with: email)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (okclick) in
            
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithCancel(title: String, message: String, buttonText: String, buttonAction: @escaping() -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let button = UIAlertAction(title: buttonText, style: .default) { (buttonclick) in
            buttonAction()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (cancelclick) in
        }
        
        alert.addAction(cancel)
        alert.addAction(button)
        
        self.present(alert, animated: true, completion: nil)
    }
}

