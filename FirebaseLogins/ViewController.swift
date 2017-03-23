//
//  ViewController.swift
//  FirebaseLogins
//
//  Created by Joseph Kim on 3/23/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    let customFBButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Custom FB Login here", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        
        view.addSubview(loginButton)
        view.addSubview(customFBButton)
        
        loginButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 50, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 30)   // As of 4.19.0, the height is now capped at 30 for some reason...
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        
        customFBButton.anchor(top: loginButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 50)
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
    }
    
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { [weak self] (result, err) in
            if err != nil {
                print("MOR: Custom FB Login failed: \(err)")
            }
            
            self?.showEmailAddress()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("MOR: Successfully logged out of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("\(error)")
            return
        }
        
        showEmailAddress()
    }

    func showEmailAddress() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("MOR: Failed to start graph request:  \(err)")
                return
            }
            
            print("\(result)")
        }
    }
    
}

