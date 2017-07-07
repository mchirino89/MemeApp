//
//  MemeGridCell.swift
//  MemeApp
//
//  Created by Mauricio Chirino on 6/7/17.
//  Copyright © 2017 Mauricio Chirino. All rights reserved.
//

import UIKit

class MemeGridCell: UICollectionViewCell {
    @IBOutlet weak var ThumbnailImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    // If both classes could inheret from the same class then i'd see the benefit. Please correct me if i'm wrong but UICollectionViewCell is UICollectionReusableView's child and UITableViewCell is child of another kind. I event tried to set them to be one of the kind but storyboard didn't allow it.
    func setupCellWith(meme:Meme) {
        ThumbnailImage.image = meme.generatedMeme
        dateLabel.text = (UIApplication.shared.delegate as! AppDelegate).getReadableDate(dateToConvert: meme.creationTime)
    }
}
