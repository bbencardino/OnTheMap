import Foundation

final class UdacityClient {

    struct Auth {
        static var sessionId: String = ""
        static var uniqueKey: String = ""
        static var firstName: String = ""
        static var lastName: String = ""
    }
    enum Endpoint {
        static let base = "https://onthemap-api.udacity.com/v1"

        case session
        case studentLocation
        case users
        case signUp

        var stringValue: String {
            switch self {
            case .session:
                return Endpoint.base + "/session"
            case .studentLocation:
                return Endpoint.base + "/StudentLocation" + "?limit=100&order=-updatedAt"
            case .users:
                return Endpoint.base + "/users/" + Auth.sessionId
            case .signUp:
                return "https://auth.udacity.com/sign-up"
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }

    class func login(username: String, password: String, udacity: [String: String], completionHandler: @escaping (Bool, Error?) -> ()) {

        let body = LoginRequest(udacity: ["username": "\(username)", "password": "\(password)"])
        
        taskForPOSTRequest(udacityAPI: true, url: Endpoint.session.url, responseType: SessionResponse.self, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.id
                Auth.uniqueKey = response.key
                completionHandler(true, nil)
                getPublicUserData()
            } else {
               completionHandler(false, error)
            }
        }
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

        taskForGETRequest(udacityAPI: false, url: Endpoint.studentLocation.url, responseType: StudentLocationResponse.self) { response, error in
            if let response = response {
                completionHandler(response.results,nil)
            } else {
                completionHandler([], error)
            }
        }
    }

    class func addStudentLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandler: @escaping (Bool, Error?)-> ()) {
        
        let body = StudentLocation(uniqueKey: Auth.uniqueKey, mediaURL: mediaURL, firstName: Auth.firstName, lastName: Auth.lastName, mapString: mapString, latitude: latitude, longitude: longitude)

        taskForPOSTRequest(udacityAPI: false, url: Endpoint.studentLocation.url, responseType: NewLocationResponse.self, body: body) { response, error in
            if response != nil {
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }

    class func getPublicUserData() {
        taskForGETRequest(udacityAPI: true, url: Endpoint.users.url, responseType: User.self) { response, error in
            if let response = response {
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
            }
        }
    }

    //MARK: - Helper functions

    private class func taskForGETRequest<Response: Decodable>(udacityAPI: Bool,url: URL, responseType: Response.Type, completion: @escaping (Response?, Error?) -> ()) {


        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            var newData = Data()

            if udacityAPI {
                let range = 5..<data.count
                newData = data.subdata(in: range)
            } else {
                newData = data
            }
            do {
                let response = try decoder.decode(responseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }

    private class func taskForPOSTRequest<Response: Decodable, Request: Encodable>(udacityAPI: Bool, url: URL, responseType: Response.Type, body: Request, completion: @escaping (Response?, Error?) -> ()) {

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            var newData = Data()

            if udacityAPI {
                let range = 5..<data.count
                newData = data.subdata(in: range)
            } else {
                newData = data
            }
            do {
                let response = try decoder.decode(responseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}
