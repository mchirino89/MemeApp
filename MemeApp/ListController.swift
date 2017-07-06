//
//  ListController.swift
//  MemeApp
//
//  Created by Mauricio Chirino on 5/7/17.
//  Copyright © 2017 Mauricio Chirino. All rights reserved.
//

import UIKit

class ListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var emptyPlaceholderView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var memeList: UITableView!
    var singleton = (UIApplication.shared.delegate as! AppDelegate)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Meme list"
        reloadView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return singleton.memes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeListThumbnailCell", for: indexPath) as! MemeListCell
        let meme = singleton.memes[indexPath.row]
        cell.thumbnailImage.image = meme.generatedMeme
        cell.contentLabel.text = "Meme \(indexPath.row + 1)"
        cell.dateLabel.text = singleton.getReadableDate(dateToConvert: meme.creationTime)
        return cell
    }
    
    private func reloadView() {
        loadingIndicator.startAnimating()
        singleton.refreshPhotoCarret()
        emptyPlaceholderView.isHidden = !singleton.memes.isEmpty
        memeList.isHidden = singleton.memes.isEmpty
        memeList.reloadData()
        memeList.reloadSections(IndexSet(integer: 0), with: .top)
        loadingIndicator.stopAnimating()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
