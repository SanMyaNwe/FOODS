//
//  UserProfileAlertView.swift
//  Foods
//
//  Created by Riki on 10/6/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class UserProfileAlertView: UIViewController {
    
    static let identifier = "UserProfileAlertView"
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchFacebookData()
    }
    
    private func configure() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        alertView.layer.cornerRadius = 12
        ivProfile.layer.cornerRadius = 30
        btnClose.layer.cornerRadius = 20
        btnLogout.layer.cornerRadius = 20
    }
    
    private func fetchFacebookData() {
        let connection = GraphRequestConnection()
        let request = GraphRequest(graphPath: "/me", parameters: ["fields":"email,name"])
        connection.add(request) { (httpResponse, result, error) in
            if let error = error {print(error.localizedDescription)
                return
            }
            if let result = result as? [String: String],
            let email: String = result["email"],
            let id: String = result["id"],
            let username: String = result["name"] {
                let profile: String = "http://graph.facebook.com/\(id)/picture?type=large"
                self.lblUsername.text = username
                self.lblEmail.text = email
                self.ivProfile.setImage(with: profile)
            }
        }
        connection.start()
    }
    
    @IBAction func logout(_ sender: Any) {
        Constants.loginManager.logOut()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
