
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// 创建HTTP服务器
let server = HTTPServer()

// 注册您自己的路由和请求／响应句柄
var routes = Routes()

// 监听端口
server.serverPort = 3306

routes.add(method: .get, uri: "/login") { (request, response) in
    response.setHeader(.contentType, value: "text/html")
    let json = ["hello": "world"]
    let body = responseBodyJsonData(status: 200, message: "login success", data: json)
    response.setBody(string: body)
    response.completed()
}

// 将路由注册到服务器上
server.addRoutes(routes)

do {
    // 启动HTTP服务器
    try server.setResponseFilters([(Filter404(), .high)]).start()
    print("开始启动服务器")
} catch PerfectError.networkError(let err, let msg) {
    print("网络出现错误：\(err) \(msg)")
}



