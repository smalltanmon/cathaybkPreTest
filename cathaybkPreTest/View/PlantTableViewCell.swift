//
//  PlantTableViewCell.swift
//  cathaybkPreTest
//
//  Created by Eric Chen on 2021/8/28.
//

import UIKit

class PlantTableViewCell: UITableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(plant: Plant, indexPath: IndexPath, tableView: UITableView) {
        nameLabel.text = plant.name
        locationLabel.text = plant.location
        descriptionLabel.text = plant.description
        coverImageView.image = nil
        
        guard let coverURL = URL(string: plant.imageURLString) else {
            return
        }
        PhotoDownloadManager.shared.downloadPhoto(with: coverURL, indexPath: indexPath) { (result) in
            switch result{
            case .success(let (image, indexPath)):
                DispatchQueue.main.async {
                    let cell = tableView.cellForRow(at: indexPath) as? PlantTableViewCell
                    cell?.coverImageView.image = image
                }
            case .failure(let error):
                print(String(error.localizedDescription))
            }
        }
    }

}
