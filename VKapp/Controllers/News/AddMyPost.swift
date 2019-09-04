//
//  AddMyPost.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 5/14/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddMyPost: UIViewController {
    let vkUserId = userDefaults.string(forKey: "userID")
    
    var vkService = GetNews()

    
    var lat = 0.0
    var long = 0.0
    
    let messageTextView : UITextView = {
        let textView = UITextView()
        textView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        textView.backgroundColor = .white
        return textView
        }()
    
    let postToolBar : UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.backgroundColor = .white
        toolBar.barTintColor = .red
        toolBar.isTranslucent = false
        toolBar.sizeToFit()
        let imageName = "addLocation.png"
        let doneButton = UIBarButtonItem(image: UIImage(named: imageName), style:.plain, target: self, action: #selector(addLocation))
        doneButton.tintColor = .white
        let flexSpaceDoneButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpaceDoneButton,doneButton], animated: true)
        return toolBar
    }()
    
   @objc func addLocation(){
    let followVC = GeoLocationVC()
    followVC.delegate = self
    navigationController?.pushViewController(followVC, animated: true)
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(messageTextView)
        print(lat, long)
        
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        [
            messageTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            messageTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageTextView.heightAnchor.constraint(equalToConstant: 50)
            ].forEach{ $0.isActive = true }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(addMyPost))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        messageTextView.inputAccessoryView = postToolBar
        messageTextView.becomeFirstResponder()
        messageTextView.delegate = self
        
        navigationBarSetUp()
        textViewDidChange(messageTextView)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        messageTextView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func addMyPost(){
        
        vkService.newVkPost(message: messageTextView.text!, latitude: lat, longitude: long, completion: {
            [weak self] in
            let alert = UIAlertController(title: "Отправлена", message: "Ваша запись опубликована", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Хорошо", style: .`default`, handler: {
                (_) in
                self?.dismiss(animated: false, completion: nil)
            }))
            self?.present(alert, animated: true, completion: nil)
        })
    }
    

    func navigationBarSetUp(){
        self.navigationItem.title = "Новая запись"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
    
}

extension AddMyPost: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textChecker(messageTextView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChecker(messageTextView)
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func textChecker(_ textView: UITextView) {
        if !textView.text.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
}
extension AddMyPost: AddGeolocationDelegate{
    func addGeolocation(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
        
        
    }
}
