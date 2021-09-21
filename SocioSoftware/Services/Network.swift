//
//  File.swift
//  SocioSoftware
//
//  Created by George Digmelashvili on 9/21/21.
//

import UIKit
import Alamofire

class ApiCall{
    
    static let shared = ApiCall()
    private init(){}
    
    let urlS = "https://pixabay.com/api/?key=23491811-d81c9ab4ea97edda51c8fdab7"
    
    func fetchPhotos(_ page: Int = 1, completion: @escaping (PhotoListViewModel) -> Void) {
        
        guard let url = URL(string: "\(urlS)&page=\(page)") else {return}
        let resource = Resource<PhotoData>(url: url)
        Webservice.load(resource: resource) { result in
            switch result {
            case .success(let photos):
                completion(PhotoListViewModel(data: photos))
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
    case AFError
}

struct Resource<T: Codable> {
    let url: URL
}

class Webservice {

    static func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let request = URLRequest(url: resource.url)
        AF.request(request).response { resp in
            if case .success(let data) = resp.result {
                if let result = try? JSONDecoder().decode(T.self, from: data!) {
                    completion(.success(result))
                } else {
                    completion(.failure(.decodingError))
                }
            } else {
                completion(.failure(.AFError))
            }
        }
    }
}


extension String {
    func downloadImage(completion: @escaping (UIImage?) -> Void) {
        if self.isEmpty { completion(UIImage(named: "no-image"))} else {
            guard let url = URL(string: self) else {return}
            AF.request(url).response { resp in
                if case .success(let image) = resp.result {
                    completion(UIImage(data: image!))
                }
            }
        }
    }
}
