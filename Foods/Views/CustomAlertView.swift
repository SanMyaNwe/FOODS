//
//  CustomAlertView.swift
//  Foods
//
//  Created by Riki on 10/6/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class CustomAlertView: UIViewController {
    
    static let identifier = "CustomAlertView"
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        btnOK.layer.cornerRadius = 12
        fetchFacebookData()
    }
    
    private func fetchFacebookData() {
        let connection = GraphRequestConnection()
        let request = GraphRequest(graphPath: "/me", parameters: ["fields":"email,name"])
        connection.add(request) { (httpResponse, result, error) in
            if let error = error {print(error.localizedDescription)
                return
            }
            if let result = result as? [String: String],
            let username: String = result["name"] {
                self.lblMessage.text =  "Dear "+username+", your items are now on delievery."
            }
        }
        connection.start()
    }
    
    @IBAction func onClickOK(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
