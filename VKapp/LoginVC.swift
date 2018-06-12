//
//  ViewController.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 18/02/2018.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import Alamofire
import WebKit
import Firebase
import FirebaseDatabase
import GoogleMobileAds

let userDefaults = UserDefaults.standard
var token = ""
let userAuthCheck = userDefaults.bool(forKey: "Authorised")

let userDefaultes = UserDefaults(suiteName: "group.vkappGroup")

class LoginVC: UIViewController, GADBannerViewDelegate {
    
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var webView: WKWebView!{
        didSet{
            webView.navigationDelegate = self
        }
    }
    let VKUrl = "https://oauth.vk.com/authorize"
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLogin()
        
        bannerView.adUnitID = "ca-app-pub-4235772458712584/7482421939"
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.rootViewController = self
        bannerView.load(request)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if userDefaults.bool(forKey: "Authorised"){
            performSegue(withIdentifier: "loginComplete", sender: nil)
        }
    }
    //    func checkAuth(){
    //        if userAuthorised{
    //
    //        }
    //    }
    
    func displayLogin(){
        
        let parameters : Parameters = ["client_id" : "6394206",
                                       "display" : "mobile",
                                       "redirect_uri" : "https://oauth.vk.com/blank.html",
                                       "scope" : "offline,friends,photos,groups,messages,wall",
                                       "response_type" : "token",
                                       "v" : "5.73"]
        Alamofire.request(VKUrl, parameters : parameters).responseJSON {response in
            self.webView.load(response.request!)
        }
    }
}

extension LoginVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=")}
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        if let token = params["access_token"]{
            self.token = token
            userDefaults.set(token, forKey: "token")
            userDefaults.set(params["user_id"], forKey: "userID")
            userDefaults.set(true, forKey: "Authorised")
            performSegue(withIdentifier: "loginComplete", sender: nil)
            
            userDefaultes?.set(token, forKey: "AccessToken")
            let userID = userDefaults.string(forKey: "userID")
            let firebase = FirebaseService()
            firebase.saveUserToFB(userID: userID!)
            
            
        } else {
            userDefaults.set(false, forKey: "Authorised")
        }
        
        decisionHandler(.cancel)
        
    }
}






