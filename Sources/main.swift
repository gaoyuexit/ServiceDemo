
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// 创建HTTP服务器
let server = HTTPServer()

// 注册您自己的路由和请求／响应句柄
var routes = Routes()

// 将路由注册到服务器上

// 监听8181端口
server.serverPort = 8181

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

routes.add(method: .get, uri: "/login") { (request, response) in
    response.setHeader(.contentType, value: "text/html")
    let json = ["hello": "world"]
    let body = responseBodyJsonData(status: 200, message: "login success", data: json)
    response.setBody(string: body)
    response.completed()
}

server.addRoutes(routes)


do {
    // 启动HTTP服务器
    try server.setResponseFilters([(Filter404(), .high)]).start()
    print("开始启动服务器")
} catch PerfectError.networkError(let err, let msg) {
    print("网络出现错误：\(err) \(msg)")
}



