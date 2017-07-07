//
//  FullViewController.swift
//  MemeApp
//
//  Created by Mauricio Chirino on 6/7/17.
//  Copyright © 2017 Mauricio Chirino. All rights reserved.
//

import UIKit

class FullViewController: UIViewController {
    
    @IBOutlet weak var largeImage: UIImageView!
    var memeImage:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        largeImage.image = memeImage
    }
}
