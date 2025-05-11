//
//  DataService.swift
//  my-hood-devslopes
//
//  Created by Mark Price on 8/18/15.
//  Copyright © 2015 devslopes. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class DataService {
    static let instance = DataService()
    
    let KEY_POSTS = "persons"
    fileprivate var _loadedPersons = [Person]()
    
    var loadedPersons: [Person] {
        return _loadedPersons
    }
    
    func updatePerson(person: Person,index: Int){
        _loadedPersons[index] = person
        savePersons()
        loadPersons()
    }
    func deletePerson(index:Int){
        cancelNotification(person: _loadedPersons[index], notificationID: 0)
        cancelNotification(person: _loadedPersons[index], notificationID: 1)

        _loadedPersons.remove(at: index)
        savePersons()
    }
    
    
    func sortPersons(){
        for person in _loadedPersons {
            let date = createDate(dateInString: person.dateOfBirthInString,timeInString: "00:00", offset: 0)
            let currentDate = Date()
            if date > currentDate {
                let calendar = Calendar.current
                // Replace the hour (time) of both dates with 00:00
                let date1 = calendar.startOfDay(for: date)
                let date2 = calendar.startOfDay(for: currentDate)
                let components = calendar.dateComponents([.day], from: date1, to: date2)
                person.remainingDays = components.day! * (-1)
            }
            if date < currentDate {
                let gregorian = Calendar(identifier: .gregorian)
                var components1 = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                components1.year = components1.year! + 1
                let calendar = Calendar.current
                let nextDate = gregorian.date(from: components1)!
                // Replace the hour (time) of both dates with 00:00
                let date1 = calendar.startOfDay(for: currentDate)
                let date2 = calendar.startOfDay(for: nextDate)
                let components = calendar.dateComponents([.day], from: date1, to: date2)
                if components.day == 365 {
                    person.remainingDays = 0
                } else {
                    person.remainingDays = components.day!
                }
                
            }
            
        }
        _loadedPersons = _loadedPersons.sorted(by: { $0.remainingDays < $1.remainingDays })
    }
    func savePersons() {
        let personsData = NSKeyedArchiver.archivedData(withRootObject: _loadedPersons)
        UserDefaults.standard.set(personsData, forKey: KEY_POSTS)
        UserDefaults.standard.synchronize()
    }
    
    func loadPersons() {
        if let personsData = UserDefaults.standard.object(forKey: KEY_POSTS) as? Data {
            
            if let personsArray = NSKeyedUnarchiver.unarchiveObject(with: personsData) as? [Person] {
                _loadedPersons = personsArray
            }
        }
        sortPersons()
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "personsLoaded"), object: nil))
    }
    
    func saveImageAndCreatePath(_ image: UIImage) -> String {
        let imgData = UIImagePNGRepresentation(image)
        let imgPath = "image\(Date.timeIntervalSinceReferenceDate).png"
        let fullPath = documentsPathForFileName(imgPath)
        try? imgData?.write(to: URL(fileURLWithPath: fullPath), options: [.atomic])
        return imgPath
    }
    
    func imageForPath(_ path: String) -> UIImage? {
        let fullPath = documentsPathForFileName(path)
        let image = UIImage(named: fullPath)
        return image
    }
    
    func addPerson(_ person: Person) {
        _loadedPersons.append(person)
        savePersons()
        loadPersons()
    }
    
    func documentsPathForFileName(_ name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let fullPath = paths[0] as NSString
        return fullPath.appendingPathComponent(name)
    }
    
    ///////////////////////////////
    let KEY_SETTINGS = "settings"
    fileprivate var _loadedSettings = settings()
    var loadedSettings: settings {
        return _loadedSettings
    }
    
    func saveDefaultAlarms() {
        let defaultAlarmsTimeData = NSKeyedArchiver.archivedData(withRootObject: _loadedSettings)
        UserDefaults.standard.set(defaultAlarmsTimeData, forKey: KEY_SETTINGS)
        UserDefaults.standard.synchronize()
    }
    func loadDefaultAlarms() {
        if let defaultAlarmsData = UserDefaults.standard.object(forKey: KEY_SETTINGS) as? Data {
            
            if let defaultAlarmsTimeArray = NSKeyedUnarchiver.unarchiveObject(with: defaultAlarmsData) as? settings {
                _loadedSettings = defaultAlarmsTimeArray
            }
        }
        
        //NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "personsLoaded"), object: nil))
    }
    func changeDefaultAlarmsTime(set: settings) {
        _loadedSettings = set
        saveDefaultAlarms()
        loadDefaultAlarms()
    }
    
    func age(person: Person) -> Int{
        let date = createDate2(dateInString: person.dateOfBirthInString,timeInString: "00:00", offset: 0)
        let currentDate = Date()
        
            let calendar = Calendar.current
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: date)
            let date2 = calendar.startOfDay(for: currentDate)
            let components = calendar.dateComponents([.year], from: date1, to: date2)
            return components.year! + 1
    }
    
    ///////////////////////////////
    
    func createDate2(dateInString: String, timeInString: String,offset: Int) -> Date{
        let slashToDashDate = dateInString.replacingOccurrences(of: "/", with: "-")
        let isoDate: String!
        isoDate = slashToDashDate + "T" + timeInString + ":00"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from:isoDate) {
            print("in If")
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute , .second], from: date)
            components.day! -= offset
            //components.year! = todayCalendar.component(.year, from: todayDate)
            let finalDate = calendar.date(from:components)
            return finalDate!
        }
        print("ERROR , AFTER IF")
        let ex = Date()
        return ex
    }
    
    func stringTimeToDate(time:String)-> Date{
        let todayDate = Date()
        let todayCalendar = Calendar.current
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter1.string(from: todayDate)
        let isoDate: String!
        isoDate = dateString + "T" + time + ":00"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from:isoDate) {
            print("in If")
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute , .second], from: date)
            components.hour! = todayCalendar.component(.hour, from: date)
            components.minute! = todayCalendar.component(.minute, from: date)
            let finalDate = calendar.date(from:components)
            return finalDate!
            
        }
        return Date()
    }
    
    func createDate(dateInString: String, timeInString: String,offset: Int) -> Date{
        let todayDate = Date()
        let todayCalendar = Calendar.current
        
        let slashToDashDate = dateInString.replacingOccurrences(of: "/", with: "-")
        let isoDate: String!
        isoDate = slashToDashDate + "T" + timeInString + ":00"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from:isoDate) {
            print("in If")
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute , .second], from: date)
        components.day! -= offset
        components.year! = todayCalendar.component(.year, from: todayDate)
        let finalDate = calendar.date(from:components)
        return finalDate!
        }
        print("ERROR , AFTER IF")
        let ex = Date()
        return ex
    }
    func requestNotification(person: Person,time: String,offset: Int,notificationID: Int) {
        let date = createDate(dateInString: person.dateOfBirthInString,timeInString: time, offset: offset)
        let content = UNMutableNotificationContent()
        content.title = "!امروز تولد" + person.firstName + " " + person.lastName + "است"
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        let identifier = "notificationForID:\(person.personId)Number:\(notificationID)"
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(
            request, withCompletionHandler: nil)

        print("\nNOTIFICATION REQUESTED AT DATE AND TIME : \(date)")
    }

    func cancelNotification(person:Person ,notificationID: Int){
        let identifier = "notificationForID:\(person.personId)Number:\(notificationID)"
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == identifier {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        
    }

    
    
    
    
    
    
    
    
}
