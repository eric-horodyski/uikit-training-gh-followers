//
//  String+Extension.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/23/24.
//

import Foundation

extension String {
	func convertToDate() -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		dateFormatter.locale = Locale(identifier: "en_US_POSIX")
		dateFormatter.timeZone = .current
		
		return dateFormatter.date(from: self)
	}
	
	func convertToDisplayFormat() -> String {
		guard let date = self.convertToDate() else { return "Not a parsable date." }
		return date.convertToMonthYearFormat()
	}
}
