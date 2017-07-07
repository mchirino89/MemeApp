//
//  MainController.swift
//  MemeApp
//
//  Created by Mauricio Chirino on 2/7/17.
//  Copyright © 2017 Mauricio Chirino. All rights reserved.
//

import UIKit
import Photos

class MainController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIToolbarDelegate {

    @IBOutlet weak var photoSourceHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var photoButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var placeholderTextView: UITextView!
    let photoPicker = UIImagePickerController()
    var statusBarHidden = false
    weak var listControllerReference:ListController? = nil
    weak var gridControllerReference:GridController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.autoresizingMask = UIViewAutoresizing.flexibleHeight
        photoPicker.delegate = self
        photoButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        configureTextField(textField: topTextField, text: "top", placeholder: "Add clever joke")
        configureTextField(textField: bottomTextField, text: "bottom", placeholder: "And punch line")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Low memory in device")
    }
    
//# Public helpers
    
    func showAlert(alertMessage: String, alertTitle: String = "Ups!") {
        let lowerCaseAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        lowerCaseAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(lowerCaseAlert, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
//# Private helper methods
    
    func configureTextField(textField: UITextField, text: String, placeholder: String) {
        let attributes = [NSStrokeWidthAttributeName: -4.0,
                          NSStrokeColorAttributeName: UIColor.black,
                          NSForegroundColorAttributeName: UIColor.white] as [String : Any];
        textField.attributedText = NSAttributedString(string: text.uppercased(), attributes: attributes)
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }
    
    private func getImageFromSource(isCameraImage: Bool) {
        photoPicker.sourceType = isCameraImage ? .camera : .photoLibrary
        present(photoPicker, animated: true, completion: nil)
    }
    
    private func enableActions(enable: Bool, removal: Bool = false) {
        UIView.animate(withDuration: 0.35, animations: {
            self.shareButton.isEnabled = enable
            self.deleteButton.isEnabled = enable
            self.placeholderTextView.alpha = enable ? 0 : 1
            self.memeImage.alpha = enable ? 1 : 0
            self.topTextField.alpha = enable ? 1 : 0
            self.bottomTextField.alpha = enable ? 1 : 0
        }, completion: { _ in
            if removal {
                self.memeImage.image = nil
            }
        })
    }
    
    private func setCanvasForCapture(barsHidden: Bool) {
        navigationController?.setNavigationBarHidden(barsHidden, animated: false)
        photoSourceHeightConstraint.constant = barsHidden ? 0 : 44
        // Hiding status bar during capture to ensure full image clarity 
        statusBarHidden = barsHidden
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func generateMemedImage() -> UIImage {
        setCanvasForCapture(barsHidden: true)
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        setCanvasForCapture(barsHidden: false)
        return memedImage
    }
    
    private func getMemeAlbum(albumName: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions() // Search parameters
        fetchOptions.fetchLimit = 1
        fetchOptions.predicate = NSPredicate(format: "title = %@", "Meme Album") // Album name
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: fetchOptions)
        return collection.firstObject
    }
    
    private func setStorageEnvironment() -> PHAssetCollection! {
        let albumName = (UIApplication.shared.delegate as! AppDelegate).memeAlbumName
        var generatedCollection = getMemeAlbum(albumName: albumName) // Photos app "pointer"
        // If already created, obtain reference
        if generatedCollection != nil {
            return generatedCollection
        }
        // Otherwise, let's create the album
        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
            }
            // Once created, obtain that reference
            generatedCollection = getMemeAlbum(albumName: albumName)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        // Return found/generated meme album
        return generatedCollection
    }
    
    private func saveInAlbum(memeAlbum: PHAssetCollection, producedMeme: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: producedMeme)
            assetRequest.creationDate = Date()
            let assetPlaceholder = assetRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: memeAlbum)
            let enumeration: NSArray = [assetPlaceholder!]
            albumChangeRequest!.addAssets(enumeration)
        }, completionHandler: { success, error in
            if error == nil {
                print("added image to album")
            } else {
                print(error!)
            }
        })
    }
    
//# Keyboard events and handling
    
    func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
            navigationController?.toolbar.isHidden = true
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if view.frame.origin.y < 0 {
            view.frame.origin.y += getKeyboardHeight(notification)
            navigationController?.toolbar.isHidden = false
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
//# Picker delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            memeImage.image = image
            enableActions(enable: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
//# Button actions

    @IBAction func shareMemeAction(_ sender: Any) {
        let producedMeme = generateMemedImage()
        let resultingMeme = Meme(joke: topTextField.text!, punchLine: bottomTextField.text!, originalImage: memeImage.image!, generatedMeme: producedMeme, creationTime: Date())
        (UIApplication.shared.delegate as! AppDelegate).memes.append(resultingMeme)
        listControllerReference != nil ? listControllerReference!.reloadView() : gridControllerReference?.reloadView()
        if let environment = setStorageEnvironment() {
            saveInAlbum(memeAlbum: environment, producedMeme: generateMemedImage())
            let activityViewController = UIActivityViewController(activityItems: [resultingMeme.generatedMeme], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = view
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.openInIBooks ]
            present(activityViewController, animated: true, completion: nil)
        } else {
            showAlert(alertMessage: "There was an error saving your picture")
        }
    }
    
    @IBAction func deleteMemeAction(_ sender: Any) {
        enableActions(enable: false, removal: true)
    }
    
    @IBAction func takePhotoAction(_ sender: Any) {
        getImageFromSource(isCameraImage: true)
    }
    
    @IBAction func pickPhotoAction(_ sender: Any) {
        getImageFromSource(isCameraImage: false)
    }
    
    @IBAction func returnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

//# Textfield delegate methods
extension MainController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.isEqual(topTextField) && textField.text == "TOP") || (textField.isEqual(bottomTextField) && textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.isEqual(topTextField) && textField.text == "") {
            textField.text = "TOP"
        } else if textField.isEqual(bottomTextField) && textField.text == "" {
            textField.text = "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
//# Forcing only lowercase characters and no more than 30
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        if let _ = string.rangeOfCharacter(from: NSCharacterSet.lowercaseLetters) {
            showAlert(alertMessage: "Only UPPER CASE letters for greater impact!")
            return false
        }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 30
    }
}
