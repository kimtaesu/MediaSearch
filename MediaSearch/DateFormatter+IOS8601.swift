//
//  DateFormatter.swift
//  MediaSearch
//
//  Created by tskim on 19/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

extension DateFormatter {
  /// kakao api refer: https://developers.kakao.com/docs/restapi/search
  //         [YYYY]-[MM]-[DD]T[hh]:[mm]:[ss].000+[tz]
  //        "2018-10-10T03:00:01.000+09:00"
  
  ///       Locales https://gist.github.com/jacobbubu/1836273
  static func iso8601Format(_ dateString: String) -> Date {
    return _iso8601Formatter.date(from: dateString) ?? Date()
  }
  
  private static let _iso8601Formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    return formatter
  }()
}
