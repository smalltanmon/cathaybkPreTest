//
//  PlantsViewModel.swift
//  cathaybkPreTest
//
//  Created by Eric Chen on 2021/8/28.
//

import Foundation

protocol PlantsViewModelDelegate: AnyObject {
    func onFetchCompleted()
    func onFetchFailed(error: HTTPError)
}

final class PlantsViewModel {
    private let delegate: PlantsViewModelDelegate
    private let request: PlantsRequest
    
    private var currentPage = 0
    private var totalPages = 1
    private var isFetchInProgress = false
    
    private let openDataClient = OpenDataClient()
    private var plants = [Plant]()
    
    init(delegate: PlantsViewModelDelegate, request: PlantsRequest) {
        self.delegate = delegate
        self.request = request
    }
    
    var currentCount: Int {
        return plants.count
    }
    
    var isLastPage: Bool {
        return currentPage == totalPages
    }
    
    var isFetching: Bool {
        return isFetchInProgress
    }
    
    func plant(at index: Int) -> Plant {
        plants[index]
    }
    
    func fetchPlant() {
        if isFetchInProgress {
            return
        }
        
        isFetchInProgress = true
        
        let nextPage = currentPage + 1
        print("nextPage: \(nextPage)")
        
        openDataClient.fetchPlants(request: request, page: nextPage) { (result) in
            switch result {
            case .success(let data):
                self.currentPage += 1
                let limit = Double(self.request.parameters["limit"] ?? "20") ?? 20.0
                self.totalPages = Int(ceil(Double(data.response.count) / limit))
                self.isFetchInProgress = false
                self.plants.append(contentsOf: data.response.plants)
                DispatchQueue.main.async {
                    self.delegate.onFetchCompleted()
                }
            case .failure(let error):
                self.isFetchInProgress = false
                self.delegate.onFetchFailed(error: error)
            }
        }
    }
}
