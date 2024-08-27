//
//  AppDateFormatter.swift
//  Autokad_test
//
//  Created by Poet on 22.08.2024.
//

import Foundation

public enum DateFormat: String {
	case yyyyMMddHHmmss = "yyyy-MM-dd'T'HH:mm:ss"
	case yyyyMMddHHmmssSSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSS"
	case ddMM = "dd.MM"
	case ddMMyyyy = "dd.MM.yyyy"
	case yyyyMMdd = "yyyy-MM-dd"
	case MMddyyyy = "MM/dd/yyyy"
	case HHmmss = "HH:mm:ss"
	case MMMdyyyy = "MMM d, yyyy"
	case MMMddyyyy = "MMM dd, yyyy"
	case yyyMMddHHmmssZ = "yyy-MM-dd'T'HH:mm:ssZ"
	case yyyyMMddHHmmssSSSSSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
	case MMMMddyyyy = "MMMM dd, yyyy"
	case hhmmMMMddyyyy = "hh:mm, MMM dd, yyyy"
	case MMddyyyyDot = "MM.dd.yyyy"
	case yyyyMMddHHmmssZZZZZ = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
	case MMyy = "MM-yy"
	case HHmm = "HH:mm"
	case MMddHHmm = "MM-dd HH:mm"
	case MMdd = "MM-dd"
	case MMddyy = "MM-dd-yy"
}

final class AppDateFormatter {
	static let shared = AppDateFormatter()

	init() { }

	private lazy var dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = DateFormat.yyyyMMddHHmmss.rawValue
		formatter.locale = .current
		return formatter
	}()

	func date(from string: String, dateFormat: DateFormat = .yyyyMMddHHmmss, locale: Locale = .current) -> Date? {
		dateFormatter.dateFormat = dateFormat.rawValue
		dateFormatter.locale = locale
		return dateFormatter.date(from: string)
	}

	func string(from date: Date, dateFormat: DateFormat = .yyyyMMddHHmmss, locale: Locale = .current) -> String {
		dateFormatter.dateFormat = dateFormat.rawValue
		return dateFormatter.string(from: date)
	}

	func convert(_ stringDate: String, locale: Locale = .current, from dateFormat: DateFormat, to resultDateFormat: DateFormat) -> String? {
		dateFormatter.locale = locale
		dateFormatter.dateFormat = dateFormat.rawValue
		guard let date = dateFormatter.date(from: stringDate) else { return nil }
		dateFormatter.dateFormat = resultDateFormat.rawValue
		return dateFormatter.string(from: date)
	}

	func convert(_ date: Date, locale: Locale = .current, from dateFormat: DateFormat, to resultDateFormat: DateFormat) -> Date? {
		dateFormatter.locale = locale
		dateFormatter.dateFormat = dateFormat.rawValue
		let string = dateFormatter.string(from: date)
		dateFormatter.dateFormat = resultDateFormat.rawValue
		return dateFormatter.date(from: string)
	}
}

extension AppDateFormatter {
	func timeAgoString(from string: String, locale: Locale = .current) -> String {
		guard let date = date(from: string, dateFormat: .yyyyMMddHHmmssSSSZ) else {
			return "Invalid Date"
		}
		
		let now = Date()
		let timeDifference = now.timeIntervalSince(date)
		
		if timeDifference < 60 {
			return "\(Int(timeDifference)) с назад"
		} else if timeDifference < 3600 {
			let minutes = Int(timeDifference / 60)
			return "\(minutes) м назад"
		} else if timeDifference < 86400 {
			let hours = Int(timeDifference / 3600)
			return "\(hours) ч назад"
		} else if timeDifference < 604800 {
			let days = Int(timeDifference / 86400)
			return "\(days) д назад"
		} else if timeDifference < 2.628e+6 {
			let weeks = Int(timeDifference / 604800)
			return "\(weeks) н назад"
		} else {
			return string
		}
	}
}

