
//
//  DateExtension.swift
//  HungryForJobs
//
//  Created by Sierra 3 on 19/04/17.
//  Copyright © 2017 CB Neophyte. All rights reserved.
//

import Foundation
import UIKit

enum DateFormats: String {
    case MMMdd_yyyy = "MMMdd, yyyy"
    case MMM_dd_yyyy = "MMM dd, yyyy"
    case MMMM_dd_yyyy = "MMMM dd, yyyy"
    case MMMMdd_yyyy = "MMMMdd, yyyy"
    case MMM_yyyy = "MMMd, yyyy"
    case MMM_d_yyyy = "MMM d, yyyy"
    case MMMM_d_yyyy = "MMMM d, yyyy"
    case MMMMd_yyyy = "MMMMd, yyyy"
    case MMdd_yyyy = "MMdd, yyyy"
    case MM_dd_yyyy = "MM dd, yyyy"
    case MM_d_yyyy = "MM d, yyyy"
    case MMd_yyyy = "MMd, yyyy"
    case dd_MMM_YYYY_hh_mm_a = "dd MMM yyyy, hh:mm a"
    case EEEE_MMM_d_yyyy = "EEEE, MMM d yyyy"
    case utc = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
}

extension Date {
    
    var utcString: String {
        let timeZone = NSTimeZone.default
        let dateFormat = DateFormatter()
        dateFormat.timeZone = timeZone
        dateFormat.dateFormat = DateFormats.utc.rawValue
        return dateFormat.string(from: self)
    }
    
    func string( _ format: DateFormats) -> String {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = NSTimeZone.local
        dateFormat.dateFormat = format.rawValue
        return dateFormat.string(from: self)
    }
    
    func timeStamp() -> String {
        let timeStamp = self.timeIntervalSince1970
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: timeStamp)) ?? ""
    }
    /**
    * This will return a date value
    */
    init?(_ format: DateFormats, _ sDate: String?) {
    
        guard let strDate = sDate else { return nil }
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format.rawValue
        guard let date = dateFormat.date(from: strDate) else {
            return nil
        }
        self.init(timeInterval: 0, since: date)
    }
    
    init?(fromUtcFormat sDate: String?) {
        guard let strDate = sDate else { return nil }
        let dateFormat = DateFormatter()
        dateFormat.timeZone = TimeZone.init(abbreviation: "UTC")
        dateFormat.dateFormat = DateFormats.utc.rawValue
        guard let date = dateFormat.date(from: strDate) else {
            return nil
        }
        self.init(timeInterval: 0, since: date)
    }
    
    init(decreaseBy years: Int) {
        
        let date = Date()
        let calendar = Calendar.current
        let dateUnits: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        var dateComponents = calendar.dateComponents(dateUnits, from: date)
        if let currentYearValue = dateComponents.year {
            dateComponents.setValue((currentYearValue - years), for: .year)
        }
        if let newDate = calendar.date(from: dateComponents) {
            self.init(timeInterval: 0, since: newDate)
        }
        else {
            self.init(timeInterval: 0, since: date)
        }
    }
    init(timeStamp: String) {
        let ts = Double(timeStamp) ?? 0
        let interval = TimeInterval.init(ts)
        self.init(timeIntervalSinceNow: interval)
    }
    
    func differenceOfYearsFrom(_ date: Date) -> String{
        let years = Calendar.current.dateComponents([.year], from: self, to: date).year ?? 0
        return "\(years)"
    }
    
    
}

