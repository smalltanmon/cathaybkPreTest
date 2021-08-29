//
//  ViewController.swift
//  cathaybkPreTest
//
//  Created by Eric Chen on 2021/8/28.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!

    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var backTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var backNameLabel: UILabel!
    
    var headerCell: UITableViewCell?
    var viewModel: PlantsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        topSpaceConstraint.constant = 0
        
        let request = PlantsRequest.search(limit: "20")
        viewModel = PlantsViewModel(delegate: self, request: request)
        viewModel?.fetchPlant()
        
        let loadingViewNib = UINib(nibName: "LoadingView", bundle: nil)
        tableView.register(loadingViewNib, forCellReuseIdentifier: "loadingViewCellID")
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topOffsetY = scrollView.contentOffset.y
        
        topSpaceConstraint.constant = topOffsetY
        headerCell?.alpha = (topOffsetY - 86) / 90
        moneyLabel.alpha = (-topOffsetY + 60) / 90
        backTypeSegmentedControl.alpha = (-topOffsetY + 137) / 155
        backNameLabel.alpha = (-topOffsetY + 224) / 224
        
        let scrollViewContentOffsetMaxY = scrollView.contentSize.height - scrollView.frame.size.height
        let scrollViewContentOffsetY = scrollView.contentOffset.y
        if scrollViewContentOffsetY > scrollViewContentOffsetMaxY, let viewModel = viewModel {
            if !viewModel.isLastPage {
                //load more data
                viewModel.fetchPlant()
            }
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > 112, scrollView.contentOffset.y < 224 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top
                                  , animated: true)
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
        headerCell?.alpha = 0
        return headerCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if viewModel?.currentCount ?? 0 > 0 || viewModel?.isFetching ?? false {
                return 50
            }
            
            return 0
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        }
        return 0
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.item < viewModel?.currentCount ?? 0 else {
            return
        }
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlantTableViewCell
            if let plant = viewModel?.plant(at: indexPath.row) {
                cell.setupView(plant: plant, indexPath: indexPath, tableView: tableView)
            }
            return cell
        }else{
            let loadingView = tableView.dequeueReusableCell(withIdentifier: "loadingViewCellID") as! LoadingView
            
            if viewModel?.isLastPage ?? false {
                loadingView.activityIndicator.stopAnimating()
                loadingView.statusLabel.text = "已經到底了"
            }else{
                loadingView.activityIndicator.startAnimating()
                loadingView.statusLabel.text = "載入中"
            }
            
            return loadingView
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return viewModel?.currentCount ?? 0
    }
}

extension ViewController: PlantsViewModelDelegate{
    func onFetchCompleted() {
        tableView.reloadData()
    }
    
    func onFetchFailed(error: HTTPError) {
        print(error.description)
    }
}
