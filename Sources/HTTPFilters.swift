//
//  HTTPFilters.swift
//  ServiceDemo
//
//  Created by 郜宇 on 2017/8/11.
//
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// 404 响应过滤器
struct Filter404: HTTPResponseFilter {
    
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        callback(.continue)
    }
    
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        if case .notFound = response.status {
            response.setBody(string: "file \(response.request.path) not exist")
            response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
            callback(.done)
        }else{
            callback(.continue)
        }
    }
}

// 通用响应格式
func responseBodyJsonData(status: Int, message: String, data: Any) -> String {
    var result = Dictionary<String, Any>()
    result.updateValue(status, forKey: "status")
    result.updateValue(message, forKey: "message")
    result.updateValue(data, forKey: "data")
    guard let resultJson = try? result.jsonEncodedString() else { return "" }
    return resultJson
}
