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
    
}
