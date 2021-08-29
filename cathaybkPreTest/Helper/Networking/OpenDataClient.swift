//
//  OpenDataClient.swift
//  cathaybkPreTest
//
//  Created by Eric Chen on 2021/8/28.
//

import Foundation

final class OpenDataClient {
    let session: URLSession
    private lazy var baseURL: URL? = {
        return URL(string: "https://data.taipei/opendata/datalist/apiAccess")
    }()
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchPlants(request: PlantsRequest, page: Int = 1, completion: @escaping (Result<PlantResponse, HTTPError>)->Void) {
        guard let baseURL = baseURL else {
            completion(.failure(.invalidURL))
            return
        }
        var urlRequest = URLRequest(url: baseURL)
        let offset = (page - 1) * 20
        let parameters = ["offset": "\(offset)"].merging(request.parameters, uniquingKeysWith: +)
        urlRequest = urlRequest.queryDataAdapter(data: parameters)
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let _ = error {
                completion(.failure(.requestFail))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noHttpResponse))
                return
            }
            
            guard httpResponse.isSuccess else {
                completion(.failure(.httpResponseFail))
                return
            }
            
            guard let data = data else{
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do{
                let plant = try decoder.decode(PlantResponse.self, from: data)
                completion(.success(plant))
            }catch{
                print("The Data Decode fail: \(String(describing: error))")
                completion(.failure(.jsonDecodingFail))
            }
        }.resume()
    }
}
