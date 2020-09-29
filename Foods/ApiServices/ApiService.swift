//
//  ApiService.swift
//  Foods
//
//  Created by Riki on 9/23/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import Foundation
import RxSwift

class ApiService {
    
    static let shared = ApiService()
    private init() {}
    
    func fetch<T: Codable>(
            endpoint: Endpoint,
            method: HttpMethod,
            params: [String: String],
            value: T.Type
        ) -> Observable<T> {
            
            return Observable.create { (observer) -> Disposable in
                
                var urlComponents = URLComponents(string: endpoint.route)
                
                var queryItems = [URLQueryItem]()
                for param in params {
                    queryItems.append(URLQueryItem(name: param.key, value: param.value))
                }
                
                urlComponents?.queryItems = queryItems
                
                let url = urlComponents!.url!
                var requestUrl = URLRequest(url: url)
                requestUrl.httpMethod = method.rawValue
                let session = URLSession(configuration: .default)
                
                let task = session.dataTask(with: requestUrl) { (data, response, error) in
                 
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    if 200...300 ~= statusCode {
                        
                        guard let data = data else {
                            observer.onError(NSError.conform("ServiceError:- Data is missing."))
                            return
                        }
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        do {
                            
                            let result = try decoder.decode(T.self, from: data)
                            observer.onNext(result)
                            
                        } catch {
                            
                            observer.onError(NSError.conform("ServiceError:- Failure in decoding."))
                        }
                        
                    } else {
                        
                        observer.onError(NSError.conform("ServiceError:- \(statusCode)"))
                        
                    }
                    
                    observer.onCompleted()
                }

                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
                
            }
            
        }
}
enum HttpMethod: String {
    case GET
    case POST
}

extension NSError {
    
    static func conform(_ doman: String, code: Int = 0)-> NSError {
        return NSError(domain: doman, code: code, userInfo: nil)
    }
}
