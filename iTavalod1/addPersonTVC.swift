//
//  addPersonTableVC.swift
//  iTavalod1
//
//  Created by Amir on 2/13/18.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
import Photos
import UserNotifications

class addPersonTVC: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UNUserNotificationCenterDelegate  {
    var isGrantedNotificationAccess:Bool = false
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var imgBtn: UIButton!
    
    @IBOutlet weak var firstnameTxt: UITextField!
    @IBOutlet weak var lastnameTxt: UITextField!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var switch1: UISwitch!
    @IBOutlet weak var switch2: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    public var strDateInGregorian: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
                self.isGrantedNotificationAccess = granted
        })
        
        imgBtn.layer.cornerRadius = imgBtn.frame.size.width / 2
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        
        datePicker.calendar = Calendar(identifier: Calendar.Identifier.persian)
        datePicker.locale = Locale(identifier: "fa_IR")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        strDateInGregorian = dateFormatter.string(from: date)
        
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateLbl.text = dateFormatter.string(from: date)
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func addBtnPressed(_ sender: Any) {
        let img = imgBtn.imageView?.image
        let imgPath = DataService.instance.saveImageAndCreatePath(img!)
        let uuid = NSUUID().uuidString
        let person = Person(personId: uuid, firstName: firstnameTxt.text!, lastName: lastnameTxt.text! , imagePath: imgPath, dateOfBirthInGrogrianInString: strDateInGregorian, dateOfBirthInPersianInString: dateLbl.text!)
        person.switch1 = false
        person.switch2 = false
        if isGrantedNotificationAccess{
            //DataService.instance.requestNotification(person: person, time: "18:57")
            let time = DataService.instance.loadedSettings.defaultAlarmsTime
            let offset = DataService.instance.loadedSettings.defaultAlarmsDayOffset
            if switch1.isOn {
                DataService.instance.requestNotification(person: person, time: time[0],offset: offset[0],notificationID: 0)
                person.switch1 = true
            }
            if switch2.isOn {
                DataService.instance.requestNotification(person: person, time: time[1],offset: offset[1],notificationID: 1)
                person.switch2 = true
            }
            
            
        }
        DataService.instance.addPerson(person)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imgBtn.setImage(pickedImage, for: .normal)
        dismiss(animated: true, completion: nil)
        
        
    }

    @IBAction func imgBtnPressed(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        strDateInGregorian = dateFormatter.string(from: sender.date)
        
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateLbl.text = dateFormatter.string(from: sender.date)
    }
    

    
}
