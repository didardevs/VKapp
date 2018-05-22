//
//  AddMyPost.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 5/14/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddMyPost: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var postToolBar: UIToolbar!
    @IBOutlet weak var messageTextField: UITextField!
    let vkUserId = userDefaults.string(forKey: "userID")
    
    var vkService = VKServices()
    
    var myLocation : (lat: Double, long: Double) = (0.0, 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(addMyPost))
        

        
        messageTextField.inputAccessoryView = postToolBar
        messageTextField.becomeFirstResponder()
        messageTextField.delegate = self
        messageTextField.attributedPlaceholder = NSAttributedString(string: "Что у Вас нового?",
                                                                    attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        messageTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func addMyPost(){
        vkService.newVkPost(message: messageTextField.text!, latitude: myLocation.lat, longitude: myLocation.long, completion: {
            [weak self] in
            let alert = UIAlertController(title: "Отправлена", message: "Ваша запись опубликована", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Хорошо", style: .`default`, handler: {
                (_) in
//                self?.performSegue(withIdentifier: "backToNews", sender: self)
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


}
