import Foundation

class UdacityClient {

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

        var stringValue: String {
            switch self {
            case .session:
                return Endpoint.base + "/session"
            case .studentLocation:
                return Endpoint.base + "/StudentLocation" + "?order=-updatedAt"
            case .users:
                return Endpoint.base + "/users/" + Auth.sessionId
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
                Auth.uniqueKey = response.key
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

        taskForGETRequest(udacityAPI: false, url: Endpoint.studentLocation.url, responseType: StudentLocationResponse.self) { response, error in
            if let response = response {
                completionHandler(response.results,nil)
            } else {
                completionHandler([], error)
            }
        }
    }

    class func addStudentLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandler: @escaping (Bool, Error?)-> ()) -> StudentLocation {
        
        let body = StudentLocation(uniqueKey: Auth.uniqueKey, mediaURL: mediaURL, firstName: Auth.firstName, lastName: Auth.lastName, mapString: mapString, latitude: latitude, longitude: longitude)

        var request = URLRequest(url: Endpoint.studentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completionHandler(false, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(NewLocationResponse.self, from: data)
                completionHandler(true, nil)
                print(response.createdAt)
            } catch {
                completionHandler(false, error)
            }

        }
        task.resume()
        return body
    }

    class func getPublicUserData(completionHandler: @escaping (User?, Error?) -> ()) {

        taskForGETRequest(udacityAPI: true, url: Endpoint.users.url, responseType: User.self) { response, error in

            if let response = response {
                completionHandler(response, nil)
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
               
            } else {
                completionHandler(nil, error)
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
                DispatchQueue.main.async {
                    completion(nil, error)
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
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
