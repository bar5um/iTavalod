//
//  FirstViewController.swift
//  iTavalod1
//
//  Created by Amir on 2/13/18.
//  Copyright © 2018 Amir. All rights reserved.
//

import UIKit
import UserNotifications

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // deselect the selected row if any
        let selectedRow: IndexPath? = tableView.indexPathForSelectedRow
        if let selectedRowNotNill = selectedRow {
            tableView.deselectRow(at: selectedRowNotNill, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print("///////////////////////// SEPEREATOR")
                print(request.identifier)
            }
        })
        tableView.delegate = self
        tableView.dataSource = self
        DataService.instance.loadPersons()
        DataService.instance.loadDefaultAlarms()
        NotificationCenter.default.addObserver(self, selector: #selector(self.onPersonsLoaded(_:)), name: NSNotification.Name(rawValue: "personsLoaded"), object: nil)
        tableView.tableFooterView = UIView(frame: .zero)

        if DataService.instance.loadedPersons.count == 0 {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = DataService.instance.loadedPersons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell") as! PersonCell
        
        //cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        
        cell.configureCell(person)
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.loadedPersons.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var personIndex: Int!
        personIndex = indexPath.row
        performSegue(withIdentifier: "personDetailTableVC", sender: personIndex)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            DataService.instance.deletePerson(index: indexPath.row)
            
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
            
        }
        
    }
    
    @IBAction func showActionSheet(_ sender: Any) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "گزینه مورد نظر را انتخاب کنید", preferredStyle: .actionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "جدید", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("File Deleted")
            self.performSegue(withIdentifier: "addPersonVC", sender: self)
        })
        let saveAction = UIAlertAction(title: "مخاطبین", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("File Saved")
        })
        
        //
        let cancelAction = UIAlertAction(title: "لغو", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            //print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    @objc func onPersonsLoaded(_ notif: AnyObject) {
        tableView.reloadData()
        if DataService.instance.loadedPersons.count == 0 {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "personDetailTableVC" {
            if let detailsTVC = segue.destination as? personDetailTableVC {
                if let personIndex = sender as? Int {
                    detailsTVC.personIndex = personIndex
                }
            }
        }
    }
    
    
}

