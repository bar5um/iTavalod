//
//  setAlarmsTVC.swift
//  iTavalod1
//
//  Created by Amir on 3/9/18.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
import UserNotifications
class setAlarmsTVC: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource,UNUserNotificationCenterDelegate {
    var dayPickerItems = ["روز تولد"]
    @IBOutlet weak var dayPicker1: UIPickerView!
    @IBOutlet weak var dayPicker2: UIPickerView!
    @IBOutlet weak var timePicker1: UIDatePicker!
    @IBOutlet weak var timePicker2: UIDatePicker!
    
    @IBOutlet weak var dayPickerLbl1: UILabel!
    @IBOutlet weak var timePickerLbl1: UILabel!
    
    @IBOutlet weak var timePickerLbl2: UILabel!
    @IBOutlet weak var dayPickerLbl2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...7 {
            dayPickerItems.append("\(i) روز قبل")
        }
        dayPicker1.dataSource = self
        dayPicker1.delegate = self
        dayPicker2.dataSource = self
        dayPicker2.delegate = self
        let time = DataService.instance.loadedSettings.defaultAlarmsTime
        let day = DataService.instance.loadedSettings.defaultAlarmsDayOffset
        dayPickerLbl1.text = dayPickerItems[day[0]]
        timePickerLbl1.text = time[0]
        dayPickerLbl2.text = dayPickerItems[day[1]]
        timePickerLbl2.text = time[1]
        dayPicker1.selectRow(day[0], inComponent: 0, animated: true)
        dayPicker2.selectRow(day[1], inComponent: 0, animated: true)
        timePicker1.date = DataService.instance.stringTimeToDate(time: time[0])
        timePicker2.date = DataService.instance.stringTimeToDate(time: time[1])

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

            return dayPickerItems.count

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return "\(dayPickerItems[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            dayPickerLbl1.text = dayPickerItems[row]
        }
        if pickerView.tag == 2 {
            dayPickerLbl2.text = dayPickerItems[row]
        }
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        var ttimes: [String]! = ["0","0"]
        ttimes[0] = timePickerLbl1.text!
        ttimes[1] = timePickerLbl2.text!
        var ddays: [Int] = [0,0]
        ddays[0] = dayPicker1.selectedRow(inComponent: 0)
        ddays[1] = dayPicker2.selectedRow(inComponent: 0)
        let set = settings(defaultAlarmsTime: ttimes, defaultAlarmsDayOffset: ddays)
        DataService.instance.changeDefaultAlarmsTime(set: set)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        for person in DataService.instance.loadedPersons {
            if person.switch1 {
                DataService.instance.requestNotification(person: person, time: ttimes[0],offset: ddays[0],notificationID: 0)
            }
            if person.switch2 {
                DataService.instance.requestNotification(person: person, time: ttimes[1],offset: ddays[1],notificationID: 1)
            }
        }
    }
    
    
    @IBAction func timePicker1ValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        timePickerLbl1.text = dateFormatter.string(from: sender.date)
    }
    
    
    @IBAction func timePicker2ValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        timePickerLbl2.text = dateFormatter.string(from: sender.date)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
//    
    var cellIsSelected: IndexPath?
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellIsSelected = cellIsSelected == indexPath ? nil : indexPath
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellIsSelected == indexPath {
            return 155
        }
        return 44
    }


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
