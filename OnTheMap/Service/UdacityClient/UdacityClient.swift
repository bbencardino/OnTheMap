import Foundation

class UdacityClient {

    struct Auth {
        static var sessionId: String = ""
    }
    enum Endpoint {
        static let base = "https://onthemap-api.udacity.com/v1"

        case session
        case studentLocation

        var stringValue: String {
            switch self {
            case .session:
                return Endpoint.base + "/session"
            case .studentLocation:
                return Endpoint.base + "/StudentLocation"
            }

        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }

    class func login(username: String, password: String, udacity: [String: String], completionHandler: @escaping (Bool, Error?) -> ()) {

        let url = Endpoint.session.url
        var request = URLRequest(url: url)

        let body = LoginRequest(udacity: ["username": "\(username)", "password": "\(password)"])
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(false,error)
                }
                return
            }

            let range = 5..<data.count
            let newData = data.subdata(in: range)

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(SessionResponse.self, from: newData)
                Auth.sessionId = response.id
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                    print(error)
                }
            }
        }
        task.resume()
    }

    class func logout(completionHandler: @escaping () -> ()) {

        var request = URLRequest(url: Endpoint.session.url)
        request.httpMethod = "DELETE"

        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in

            Auth.sessionId = ""
            DispatchQueue.main.async {
                completionHandler()
            }
        }
        task.resume()
    }

    class func getStudentLocation(completionHandler: @escaping ([StudentLocation], Error?) -> ()) {

        let url = Endpoint.studentLocation.url
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler([], error)
                    print("oh fuck: \(error)")
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(StudentLocationResponse.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(response.results, nil)

                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler([], error)
                    print("deu merda: \(error)")
                }
            }
        }
        task.resume()
    }
}
