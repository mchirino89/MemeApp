//
//  ListController.swift
//  MemeApp
//
//  Created by Mauricio Chirino on 5/7/17.
//  Copyright © 2017 Mauricio Chirino. All rights reserved.
//

import UIKit
import Photos

class ListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var emptyPlaceholderView: UIView!
    @IBOutlet var memeList: UITableView!
    var assetCollection: PHAssetCollection!
    var MemeSingleton = (UIApplication.shared.delegate as! AppDelegate).memes
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "MMM/dd/YY hh:mm a"
        return formatter
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Meme list"
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 1
        fetchOptions.predicate = NSPredicate(format: "title = %@", "Meme album")
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
        
        if let first_Obj:AnyObject = collection.firstObject{
            assetCollection = first_Obj as! PHAssetCollection
            let assets : PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
            let imageManager = PHCachingImageManager()
            assets.enumerateObjects({(object: AnyObject!, count: Int,
                stop: UnsafeMutablePointer<ObjCBool>) in
                if object is PHAsset {
                    let asset = object as! PHAsset
                    let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                    let options = PHImageRequestOptions()
                    options.deliveryMode = .fastFormat
                    options.isSynchronous = true
                    imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: options, resultHandler: {
                        (image: UIImage?, info: [AnyHashable : Any]?) in
                        self.MemeSingleton.append(Meme(joke: "", punchLine: "", originalImage: image!, generatedMeme: image!, creationTime: asset.creationDate!))
                    })
                }
            })
        }
        emptyPlaceholderView.isHidden = !MemeSingleton.isEmpty
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if !MemeSingleton.isEmpty {
//            emptyPlaceholderView.removeFromSuperview()
//        }
//        memeList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemeSingleton.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeListThumbnailCell", for: indexPath) as! MemeListCell
        cell.thumbnailImage.image = MemeSingleton[indexPath.row].generatedMeme
        cell.contentLabel.text = "Meme \(indexPath.row + 1)"
        cell.dateLabel.text = formatter.string(from: MemeSingleton[indexPath.row].creationTime)
        return cell
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
