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



let userDefaults = UserDefaults.standard
var token = ""
let userAuthCheck = userDefaults.bool(forKey: "Authorised")

let userDefaultes = UserDefaults(suiteName: "group.vkappGroup")

class LoginVC: UIViewController, WKUIDelegate  {
    
    var webView: WKWebView!
    let VKUrl = "https://oauth.vk.com/authorize"
    var token = ""
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        view.backgroundColor = .white
        displayLogin()
        
    }


    
    func displayLogin(){
        
        let parameters : Parameters = ["client_id" : "6954451",
                                       "display" : "mobile",
                                       "redirect_uri" : "https://oauth.vk.com/blank.html",
                                       "scope" : "offline,friends,photos,groups,wall",
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
        guard let token = params["access_token"], let userID = params["user_id"] else {
            decisionHandler(.cancel)
            return
        }
        userDefaults.set(token, forKey: "token")
        userDefaults.set(userID, forKey: "userID")
        userDefaults.set(true, forKey: "Authorised")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.moveToMainTabVC()
        self.dismiss(animated: true, completion: nil)
        decisionHandler(.cancel)
        
    }
}






