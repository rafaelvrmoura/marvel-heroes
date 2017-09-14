//
//  Date+StringRepresentation.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 13/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation


extension Date {
    
    func localizedString(withDateStyle dateStyle: DateFormatter.Style, andTimeStyle timeStyle: DateFormatter.Style) -> String {
    
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.locale = Locale.current
        
        return formatter.string(from: self)
    }
    
    func localizedString(withTemplate template: String) -> String {
        
        let formatter = DateFormatter()
        let format = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: Locale.current)
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}
