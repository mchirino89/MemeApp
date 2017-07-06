//
//  GridController.swift
//  MemeApp
//
//  Created by Mauricio Chirino on 6/7/17.
//  Copyright © 2017 Mauricio Chirino. All rights reserved.
//

import UIKit

class GridController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var emptyPlaceholderView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var memeGrid: UICollectionView!
    var singleton = (UIApplication.shared.delegate as! AppDelegate)
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Meme grid"
        reloadView()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return singleton.memes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! MemeGridCell
        let meme = singleton.memes[indexPath.row]
        cell.ThumbnailImage.image = meme.generatedMeme
        cell.dateLabel.text = singleton.getReadableDate(dateToConvert: meme.creationTime)
        return cell
    }
    
    private func reloadView() {
        loadingIndicator.startAnimating()
//        singleton.refreshPhotoCarret()
        emptyPlaceholderView.isHidden = !singleton.memes.isEmpty
        memeGrid.isHidden = singleton.memes.isEmpty
        memeGrid.reloadData()
//        memeGrid.reloadSections(IndexSet(integer: 0), with: .)
        loadingIndicator.stopAnimating()
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
