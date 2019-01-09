//
//  Utility.swift
//  CoreML_Places
//
//  Created by apple on 08/01/19.
//  Copyright © 2019 appsmall. All rights reserved.
//

import UIKit



class Utility {
    // MARK:- ALERT CONTROLLER
    static func alert(on: UIViewController, title: String, message: String, withActions:[UIAlertAction], style: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in withActions {
            alert.addAction(action)
        }
        on.present(alert, animated: true, completion: nil)
    }
}
