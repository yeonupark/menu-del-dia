//
//  LoginViewController.swift
//  CommunityProject
//
//  Created by Yeonu Park on 2023/11/14.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    let mainView = LoginView()
    
    override func loadView() {
        view.self = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.signUpButton.addTarget(self, action: #selector(join), for: .touchUpInside)
    }
    
    @objc func join() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
