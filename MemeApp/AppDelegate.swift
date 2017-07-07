//
//  AppDelegate.swift
//  MemeApp
//
//  Created by Mauricio Chirino on 2/7/17.
//  Copyright © 2017 Mauricio Chirino. All rights reserved.
//

import UIKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let memeAlbumName = "Meme Album"
    
    var window: UIWindow?
    var memes = [Meme]()
    var assetCollection: PHAssetCollection!
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "MMM/dd/YY hh:mm a"
        return formatter
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func refreshPhotoCarret() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 1
        fetchOptions.predicate = NSPredicate(format: "title = %@", memeAlbumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
        if let first_Obj:AnyObject = collection.firstObject{
            assetCollection = first_Obj as! PHAssetCollection
            let assets : PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
            let imageManager = PHCachingImageManager()
            memes.removeAll()
            assets.enumerateObjects({ [weak self] (object: AnyObject!, count: Int,
                stop: UnsafeMutablePointer<ObjCBool>) in
                if object is PHAsset {
                    let asset = object as! PHAsset
                    let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                    let options = PHImageRequestOptions()
                    options.deliveryMode = .fastFormat
                    options.isSynchronous = true
                    imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: options, resultHandler: {
                        (image: UIImage?, info: [AnyHashable : Any]?) in
                        self?.memes.append(Meme(joke: "", punchLine: "", originalImage: image!, generatedMeme: image!, creationTime: asset.creationDate!))
                    })
                }
            })
        }
    }
    
    func getReadableDate(dateToConvert: Date?) -> String {
        return dateToConvert != nil ? formatter.string(from: dateToConvert!) : "Unknown"
    }
}

