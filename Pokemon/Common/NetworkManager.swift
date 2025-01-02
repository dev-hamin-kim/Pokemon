//
//  NetworkManager.swift
//  Pokemon
//
//  Created by 김하민 on 12/24/24.
//

import Foundation
import RxSwift
import Kingfisher

enum NetworkError: Error {
    case invalidURL
    case failedToFetchData
    case failedToDecode
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T: Decodable>(url: URL) -> Single<T> {
        return Single.create { observer in
            let session = URLSession(configuration: .default)
            session.dataTask(with: URLRequest(url: url)) { data, response, error in
                if let error = error {
                    observer(.failure(error))
                    return
                }
                
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      (200...300).contains(response.statusCode) else {
                    observer(.failure(NetworkError.failedToFetchData))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(decodedData))
                } catch {
                    observer(.failure(NetworkError.failedToDecode))
                }
            }.resume()
            
            return Disposables.create()
        }
    }
}
