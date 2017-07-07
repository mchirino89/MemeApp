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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMemeFromGrid", sender: singleton.memes[indexPath.row].generatedMeme)
        collectionView.cellForItem(at: indexPath)?.isSelected = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! FullViewController).memeImage = sender as? UIImage
    }
    
    private func reloadView(hardReload: Bool = false) {
        loadingIndicator.startAnimating()
        if hardReload {
            singleton.refreshPhotoCarret()
        }
        emptyPlaceholderView.isHidden = !singleton.memes.isEmpty
        memeGrid.isHidden = singleton.memes.isEmpty
        memeGrid.reloadData()
        loadingIndicator.stopAnimating()
    }
    
    @IBAction func addMemeAction(_ sender: Any) {
        let addition = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createMemeView") as! MainController
        let navController = UINavigationController(rootViewController: addition)
        present(navController, animated:true, completion: nil)
    }
}
