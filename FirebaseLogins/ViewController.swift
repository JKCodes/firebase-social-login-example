//
//  ViewController.swift
//  FirebaseLogins
//
//  Created by Joseph Kim on 3/23/17.
//  Copyright © 2017 Joseph Kim. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import TwitterKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    let customFBButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Custom FB Login here", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let customGoogleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.setTitle("Custom Google Sign In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupFacebookButtons()
        setupGoogleButtons()
        setupTwitterButton()
    }
    
    private func setupTwitterButton() {
        let twitterButton = TWTRLogInButton { (session, error) in
            if let err = error {
                print("MOR: Failed to login via Twitter: \(err)")
            }
            
            print("MOR: Successfully logged into Twitter")
        
            guard let token = session?.authToken, let secret = session?.authTokenSecret else { return }
            
            let credentials = FIRTwitterAuthProvider.credential(withToken: token, secret: secret)
            
            FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
                
                if let err = error {
                    print("MOR: Failed to login to Firebase with Twitter: \(err)")
                }
                
                print("MOR: Successfully logged into Firebase using Twitter: \(user)")
            })
        }
        
        view.addSubview(twitterButton)
        twitterButton.anchor(top: customGoogleButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 50)
    }
    
    private func setupGoogleButtons() {
        let googleButton = GIDSignInButton()
        view.addSubview(googleButton)
        view.addSubview(customGoogleButton)
        
        googleButton.anchor(top: customFBButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 50)
        customGoogleButton.anchor(top: googleButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 50)
        customGoogleButton.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func handleGoogleSignIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    private func setupFacebookButtons() {
        let loginButton = FBSDKLoginButton()
        
        view.addSubview(loginButton)
        view.addSubview(customFBButton)
        
        loginButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 50, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 28)   // As of 4.19.0, the height is now capped at 28 for some reason...
        
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
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("MOR: Error authenticating Facebook User on Firebase: \(error)")
                return
            }
            
            print("MOR: Successfully logged in Facebook user: \(user)")
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("MOR: Failed to start graph request:  \(err)")
                return
            }
            
            print("\(result)")
        }
    }
    
}

