//
//  Date+Extension.swift
//  GithubFollowers
//
//  Created by Eric Horodyski on 8/23/24.
//

import Foundation

extension Date {
	func convertToMonthYearFormat() -> String {
		return formatted(.dateTime.month().year())
	}
}
