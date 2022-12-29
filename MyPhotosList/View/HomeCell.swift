//
//  HomeCell.swift
//  MyPhotosList
//
//  Created by Halil YAŞ on 29.12.2022.
//

import UIKit

class HomeCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var myPhotos: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
