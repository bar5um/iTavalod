//
//  alarms.swift
//  iTavalod1
//
//  Created by Amir on 2/16/18.
//  Copyright © 2018 Amir. All rights reserved.
//

import Foundation


class settings: NSObject, NSCoding{
    //default alarms
    private var _defaultAlarmsTime: [String] = ["00:00", "23:07"]
    private var _defaultAlarmsDayOffset: [Int] = [0 , 1]
    var defaultAlarmsTime: [String] {
        get {
            return _defaultAlarmsTime
        }
        set {
            _defaultAlarmsTime = newValue
        }
    }
    var defaultAlarmsDayOffset: [Int] {
        get {
            return _defaultAlarmsDayOffset
        }
        set {
            _defaultAlarmsDayOffset = newValue
        }
    }
    
    override init() {
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self._defaultAlarmsTime = (aDecoder.decodeObject(forKey: "defaultTimes") as? [String]!)!
        self._defaultAlarmsDayOffset = (aDecoder.decodeObject(forKey: "defaultDays") as? [Int])!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self._defaultAlarmsTime, forKey: "defaultTimes")
        aCoder.encode(self._defaultAlarmsDayOffset, forKey: "defaultDays")
    }
    
    
    
    
    
    init(defaultAlarmsTime:[String],defaultAlarmsDayOffset:[Int]){
        self._defaultAlarmsTime = defaultAlarmsTime
        self._defaultAlarmsDayOffset = defaultAlarmsDayOffset
    }
}
