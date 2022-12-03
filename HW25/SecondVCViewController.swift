//
//  SecondVCViewController.swift
//  HW25
//
//  Created by Дмитрий Цветков on 02.12.2022.
//

import UIKit
import CoreData

class SecondVCViewController: UIViewController {

    @IBOutlet weak var imageOfCharacter: UIImageView!
    
    var hero: Hero?
    
    var urlString: String?
    
    var elementsAfterSearch2: [UIImageView]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            let url = URL(string: urlString!)
            imageOfCharacter.downloaded(from: url!)
    }
}
