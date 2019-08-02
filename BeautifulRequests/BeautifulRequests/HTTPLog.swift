//
//  HTTPLog.swift
//  BeautifulRequests
//
//  Created by tskim on 24/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
class HTTPLog {
  class func log(request: URLRequest) {
    // disable print http log
    return
    let urlString = request.url?.absoluteString ?? ""
    let components = NSURLComponents(string: urlString)

    let method = request.httpMethod != nil ? "\(String(describing: request.httpMethod))" : ""
    let path = "\(components?.path ?? "")"
    let query = "\(components?.query ?? "")"
    let host = "\(components?.host ?? "")"

    var requestLog = "\n---------- Request ---------->\n"
    requestLog += "\(urlString)"
    requestLog += "\n\n"
    requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
    requestLog += "Host: \(host)\n"
    for (key, value) in request.allHTTPHeaderFields ?? [:] {
      requestLog += "\(key): \(value)\n"
    }
    if let body = request.httpBody {
      requestLog += "\n\(NSString(data: body, encoding: String.Encoding.utf8.rawValue)!)\n"
    }

    requestLog += "\n------------------------->\n";
    print(requestLog)
  }

  class func log(data: Data?, response: HTTPURLResponse?, error: Error?) {
    #if !DEBUG
      return
    #endif
    let urlString = response?.url?.absoluteString
    let components = NSURLComponents(string: urlString ?? "")

    let path = "\(components?.path ?? "")"
    let query = "\(components?.query ?? "")"

    var responseLog = "\n<---------- Response ----------\n"
    if let urlString = urlString {
      responseLog += "\(urlString)"
      responseLog += "\n\n"
    }

    if let statusCode = response?.statusCode {
      responseLog += "HTTP \(statusCode) \(path)?\(query)\n"
    }
    if let host = components?.host {
      responseLog += "Host: \(host)\n"
    }
    for (key, value) in response?.allHeaderFields ?? [:] {
      responseLog += "\(key): \(value)\n"
    }
    if let body = data {
      responseLog += "\n\(String(describing: body))\n"
    }
    if error != nil {
      responseLog += "\nError: \(error!.localizedDescription)\n"
    }

    responseLog += "<------------------------\n";
    print(responseLog)
  }
}
