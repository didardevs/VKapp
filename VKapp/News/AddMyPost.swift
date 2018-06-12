//
//  AddMyPost.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 5/14/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddMyPost: UIViewController, UITextViewDelegate {
    
    @IBOutlet var postToolBar: UIToolbar!
    
    @IBOutlet weak var messageTextView: UITextView!
    let vkUserId = userDefaults.string(forKey: "userID")
    
    var vkService = GetNews()
    
    var myLocation : (lat: Double, long: Double) = (0.0, 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(addMyPost))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        messageTextView.inputAccessoryView = postToolBar
        messageTextView.becomeFirstResponder()
        messageTextView.delegate = self
        navigationBarSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        messageTextView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func addMyPost(){
        vkService.newVkPost(message: messageTextView.text!, latitude: myLocation.lat, longitude: myLocation.long, completion: {
            [weak self] in
            let alert = UIAlertController(title: "Отправлена", message: "Ваша запись опубликована", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Хорошо", style: .`default`, handler: {
                (_) in
                self?.dismiss(animated: false, completion: nil)
            }))
            self?.present(alert, animated: true, completion: nil)
        })
    }
    
    @IBAction func backToPost(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "getLocation" {
            let geoLocVC = unwindSegue.source as! GeoLocationVC
            myLocation = (geoLocVC.lat, geoLocVC.long)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textChecker(messageTextView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChecker(messageTextView)
    }
    
    
    func textChecker(_ textView: UITextView) {
        if !textView.text.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func navigationBarSetUp(){
        self.navigationItem.title = "Новая запись"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
    }
    
}
