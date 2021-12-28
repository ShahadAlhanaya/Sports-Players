//
//  SportTableViewCell.swift
//  Sports&Players
//
//  Created by Shahad Nasser on 28/12/2021.
//

import UIKit

class SportTableViewCell: UITableViewCell {
    var delegate : SportImageDelegate?
    var indexPath: NSIndexPath?
    
    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var sportLabel: UILabel!
    
    func setImage(image: Data?){
        if image != nil {
            sportImageView.isHidden = false
            addImageButton.isHidden = true
            sportImageView.image = UIImage(data: image!)
        }else{
            sportImageView.isHidden = true
            addImageButton.isHidden = false
        }
    }
    
    @IBAction func pickImage(_ sender: UIButton) {
        delegate?.pickImage(indexPath: indexPath)
    }
    
}
