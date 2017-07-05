//
//  ListController.swift
//  MemeApp
//
//  Created by Mauricio Chirino on 5/7/17.
//  Copyright © 2017 Mauricio Chirino. All rights reserved.
//

import UIKit
import Photos

class ListController: UITableViewController {
    
    var assetCollection: PHAssetCollection!
    var photosAsset: PHFetchResult<AnyObject>!
    var assetThumbnailSize: CGSize!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Meme list"
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 1
        fetchOptions.predicate = NSPredicate(format: "title = %@", "Meme album")
        
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
        
        if let first_Obj:AnyObject = collection.firstObject{

            assetCollection = first_Obj as! PHAssetCollection
            print(assetCollection.estimatedAssetCount)
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
