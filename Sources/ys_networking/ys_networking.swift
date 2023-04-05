import Foundation
import UIKit

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
        print("pubic")
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

    public func fetechData<T:Codable> (
        for url: String,
        dataType: [T].Type,
        completion: @escaping (Result<[T], Error>) -> Void
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
                    let data = try JSONDecoder().decode([T].self, from: data)
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

    public func fetchImage(
        withUrlString urlString: String,
        completion: @escaping (UIImage) -> Void
    ) {

        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let weakSelf = self else { return }

            let cacheKey = NSString(string: urlString)

            if let chacheImage = ImageCachedManager.shared.object(forKey: cacheKey) {
                completion(chacheImage)
            }

            guard let url = URL(string: urlString) else { return }
            let dataTask = weakSelf.session.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    DispatchQueue.main.async { [weak self] in
                        completion(UIImage())
                    }
                    return
                }

                DispatchQueue.main.async { [weak self] in
                    if let data = data, let image = UIImage(data: data) {
                        ImageCachedManager.shared.setObject(image, forKey: cacheKey)
                        completion(image)
                    }
                }
            }

            dataTask.resume()

        }
    }


}
