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

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        
        view.addSubview(loginButton)
        loginButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 50, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width - 32, heightConstant: 30)   // As of 4.19.0, the height is now capped at 30 for some reason...
        
        loginButton.delegate = self
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("MOR: Successfully logged out of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("\(error)")
        }
        
        print("MOR: Successfully logged in with Facebook")
    }

}

