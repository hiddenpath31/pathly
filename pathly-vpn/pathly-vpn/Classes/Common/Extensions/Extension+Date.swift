//
//  Extension+Date.swift
//  pathly-vpn
//
//  Created by Александр on 16.11.2024.
//

import Foundation

extension Date {
    
    static func timeDifference(from startDate: Date, to endDate: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute, .second], from: startDate, to: endDate)

        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0

        let formattedString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        
        return formattedString
    }
    
}
