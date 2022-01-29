//
//  dateFormat.swift
//  SeSAC_Friends
//
//  Created by AlexHwang on 2022/01/29.
//

import Foundation

class DateFormat {
    let dateFormatter = DateFormatter()
    var date: Date?
    var formatString: String?
    
    final var dateStr: String {
        get {
            let value = dateFormatAsFormatString(date: date!, formatString: formatString!)
            return value
        }
    }
    
    final var yearStr: String {
        get {
            let value = dateFormatAsFormatString(date: date!, formatString: "yyyy")
            return value
        }
    }
    
    final var monthStr: String {
        get {
            let value = dateFormatAsFormatString(date: date!, formatString: "MM")
            return value
        }
    }
    
    final var dayStr: String {
        get {
            let value = dateFormatAsFormatString(date: date!, formatString: "dd")
            return value
        }
    }
    
    init(date: Date, formatString: String?) {
        self.date = date
        self.formatString = formatString
    }
                                    
    func dateFormatAsFormatString(date: Date, formatString: String) -> String {
        dateFormatter.dateFormat = formatString
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        let dateStr = dateFormatter.string(from: date)
        
        return dateStr
    }
}
