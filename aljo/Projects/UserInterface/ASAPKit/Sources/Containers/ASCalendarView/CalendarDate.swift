//
//  CalendarDate.swift
//  ASAPKit
//
//  Copyright (c) 2024 Minii All rights reserved.

import Foundation

extension Calendar {
  static let koreanCalendar: Self = {
    var calendar = Calendar.current
    calendar.locale = Locale(identifier: "ko-KR")
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .autoupdatingCurrent
    return calendar
  }()
}

extension DateFormatter {
  static let `default` = DateFormatter()
}

extension Date {
  func toString(format: String) -> String {
    let formatter = DateFormatter.default
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
}

struct CalendarDate: Equatable {
  let year: Int
  let month: Int
  let day: Int

  var isEmpty: Bool = false
  var isSelectable: Bool = true
  var isSunday: Bool = false
  
  static func generate(year: Int, month: Int, day: Int, with range: ClosedRange<Date>?) -> Self {
    var isSelectable = true
    var isSunday = false
    
    let dateComponent = DateComponents(year: year, month: month, day: day)
    let date = Calendar.koreanCalendar.date(from: dateComponent)
    
    if let selectableRange = range, let date = date {
      isSelectable = selectableRange.contains(date)
      let weekday = Calendar.koreanCalendar.component(.weekday, from: date)
      
      isSunday = weekday == 1 ? true : false
    }
    
    return CalendarDate(
      year: year,
      month: month,
      day: day,
      isSelectable: isSelectable,
      isSunday: isSunday
    )
  }
  
  static func generateEmpty() -> Self {
    return .init(year: .zero, month: .zero, day: .zero, isEmpty: true, isSelectable: false)
  }
  
  func toDate() -> Date? {
    let components = DateComponents(year: year, month: month, day: day + 1)
    return Calendar.koreanCalendar.date(from: components)
  }
}
