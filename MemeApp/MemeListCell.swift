//
//  MemeGridCell.swift
//  MemeApp
//
//  Created by Mauricio Chirino on 5/7/17.
//  Copyright © 2017 Mauricio Chirino. All rights reserved.
//

import UIKit

class MemeListCell: UITableViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // I didn't find this as clean as you made it sound 🙁
    func setupCellWith(meme:Meme, row: Int) {
        thumbnailImage.image = meme.generatedMeme
        contentLabel.text = "Meme \(row + 1)"
        dateLabel.text = (UIApplication.shared.delegate as! AppDelegate).getReadableDate(dateToConvert: meme.creationTime)
    }
}
