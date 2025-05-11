//
//  addPersonVC.swift
//  iTavalod1
//
//  Created by Amir on 2/13/18.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
import Photos
import UserNotifications

class addPersonVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UNUserNotificationCenterDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        

        // Do any additional setup after loading the view.
    }


    

    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
