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

class editPersonVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UNUserNotificationCenterDelegate {
    var isGrantedNotificationAccess:Bool = false
    
    @IBOutlet weak var imgBtn: UIButton!
    
    var personIndex:Int!
    var person: Person!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        person = DataService.instance.loadedPersons[personIndex]
        let pickedImage = DataService.instance.imageForPath(person.imagePath)
        imgBtn.setImage(pickedImage, for: .normal)
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
                self.isGrantedNotificationAccess = granted
        })
        
        
        
        
        //imgBtn.layer.cornerRadius = imgBtn.frame.size.width / 2
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func addBtnPressed(_ sender: Any) {
        let myObj : addPersonTableVC = (self.childViewControllers.last as? addPersonTableVC)!;
        let firstNameFromTable: UITextField = myObj.firstnameTxt! as UITextField;
        let lastNameFromTable:UITextField = myObj.lastnameTxt! as UITextField;
        let dateFromTable:String = myObj.strDateInGregorian
        let dateFromTableInPersian:UILabel = myObj.dateLbl! as UILabel
        let switch1:UISwitch = myObj.switch1
        let switch2:UISwitch = myObj.switch2
        let img = imgBtn.imageView?.image
        let imgPath = DataService.instance.saveImageAndCreatePath(img!)
        let uuid = NSUUID().uuidString
        let person = Person(personId: uuid, firstName: firstNameFromTable.text!, lastName: lastNameFromTable.text! , imagePath: imgPath, dateOfBirthInGrogrianInString: dateFromTable, dateOfBirthInPersianInString: dateFromTableInPersian.text!)
        DataService.instance.addPerson(person)
        if isGrantedNotificationAccess{
            //DataService.instance.requestNotification(person: person, time: "18:57")
            let time = DataService.instance.loadedSettings.defaultAlarmsTime
            let offset = DataService.instance.loadedSettings.defaultAlarmsDayOffset
            if switch1.isOn {
                DataService.instance.requestNotification(person: person, time: time[0],offset: offset[0],notificationID: 0)
            }
            if switch2.isOn {
                DataService.instance.requestNotification(person: person, time: time[1],offset: offset[1],notificationID: 1)
            }
            
            
        }
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPicBtnPressed(_ sender: Any) {
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imgBtn.setImage(pickedImage, for: .normal)
        dismiss(animated: true, completion: nil)
        
        
    }
    @IBAction func selectImgPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

