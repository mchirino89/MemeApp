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
        reloadView(hardReload: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return singleton.memes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeListThumbnailCell", for: indexPath) as! MemeListCell
        cell.setupCellWith(meme: singleton.memes[indexPath.row], row: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMemeFromList", sender: singleton.memes[indexPath.row].generatedMeme)
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    func reloadView(hardReload: Bool = false) {
        loadingIndicator.startAnimating()
        if hardReload {
            singleton.refreshPhotoCarret()
        }
        emptyPlaceholderView.isHidden = !singleton.memes.isEmpty
        memeList.isHidden = singleton.memes.isEmpty
        memeList.reloadData()
        loadingIndicator.stopAnimating()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! FullViewController).memeImage = sender as? UIImage
    }

    @IBAction func addMemeAction(_ sender: Any) {
        let addition = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createMemeView") as! MainController
        let navController = UINavigationController(rootViewController: addition)
        present(navController, animated:true, completion: nil)
    }
}
