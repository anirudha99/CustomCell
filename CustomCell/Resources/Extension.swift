//
//  ButtonExtension.swift
//  CustomCell
//
//  Created by Anirudha SM on 15/11/21.
//

import UIKit

extension UIButton {
    func attributedTitle(firstPart: String, secondPart: String) {
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 16)]
        
        let attributedTitle = NSMutableAttributedString(string: "\(firstPart)  ", attributes: atts)
        
        let boldAtts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 16)]
        
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: boldAtts))
        
        setAttributedTitle(attributedTitle, for: .normal)
    }
}

extension UIViewController {
    
//    func configureSpinner(){
//        
//        spinnerT.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(spinnerT)
//        spinnerT.color = .white
//        spinnerT.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        spinnerT.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//    }
//    
//    func startSpinning(){
//        spinnerT.startAnimating()
//    }
//    
//    func stopSpinning(){
//        spinnerT.stopAnimating()
//    }
    
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

