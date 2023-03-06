import Foundation

public struct ys_networking {
    public private(set) var text = "Hello, World!"

    public init() {
        print("\(text) 출력 완료")
    }
}


enum NetworkError: Error {
    case failParse
    case invalid
}

public class NetworkManager {

    public static let shared = NetworkManager()

    let session = URLSession.shared
    
    public func test() {
        print("pubic으로 테스트 합니다~")
    }
    

    public func fetchData<T:Codable>(
        for url: String,
        dataType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {

        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data,
                let response = response as? HTTPURLResponse,
                200..<400 ~= response.statusCode {
                do {
                    let data = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(data))
                } catch {
                    completion(.failure(NetworkError.failParse))
                }
            } else {
                completion(.failure(NetworkError.invalid))
            }

        }
        dataTask.resume()
    }

}
