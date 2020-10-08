//
//  FacebookLoginAlertView.swift
//  Foods
//
//  Created by Riki on 10/6/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class FacebookLoginAlertView: UIViewController {
    
    static let identifier = "FacebookLoginAlertView"
    
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var alertView: UIView!
    
    var onLogin: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        alertView.layer.cornerRadius = 12
        btnClose.layer.cornerRadius = 20
        btnLogin.layer.cornerRadius = 20
        ivProfile.layer.cornerRadius = 20
    }
    
    @IBAction func login(_ sender: Any) {
        self.dismiss(animated: false) {
            self.onLogin?()
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
