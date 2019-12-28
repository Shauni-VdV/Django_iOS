//
//  AboutViewController.swift
//  Django
//
//  Created by Shauni Van de Velde on 26/12/2019.
//  Copyright © 2019 Shauni Van de Velde. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var LoginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LoginButton.layer.cornerRadius = 10
        LoginButton.layer.borderWidth = 1
        LoginButton.layer.borderColor = UIColor.green.cgColor
        
    }


}

