//
//  AddBookViewController.swift
//  BookKeeper
//
//  Created by Dmitry Babinsky on 7/17/17.
//  Copyright © 2017 Dmitry Babinsky. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController {
    
    @IBOutlet weak var bookTitleTextField: UITextField!
    @IBOutlet weak var authorNameTextField: UITextField!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var addImageButton: UIButton!
    
    var persistenceController: PersistenceController!
    var owner: Owner!
    var book: Book!
    
    var imagePicker: UIImagePickerController!
    
    var bookTitle: String {
        return bookTitleTextField.text ?? ""
    }
    
    var authorName: String {
        return authorNameTextField.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if book != nil {
            setupDetailsUI()
        }
    }
    
    func setupDetailsUI() {
        bookTitleTextField.text = book.title
        authorNameTextField.text = book.author
        guard let imageData = book.image as Data? else { fatalError() }
        coverImageView.image = UIImage(data: imageData)
        coverImageView.isHidden = false
        addImageButton.isHidden = true
        bookTitleTextField.isEnabled = false
        authorNameTextField.isEnabled = false
        saveBarButton.isEnabled = false
    }
    
    @IBAction func addCoverImageButtonAction(_ sender: UIButton) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        DispatchQueue.global(qos: .default).async {
            let image = self.coverImageView.image ?? #imageLiteral(resourceName: "1image")
            dataManager.addBook(owner: self.owner, title: self.bookTitle, author: self.authorName, image: image)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textDidChange(_ sender: UITextField) {
        let isFieldsEmpty = bookTitleTextField.text == "" || authorNameTextField.text == ""
        let isFieldsHasOnlySpace = bookTitleTextField.text == " " || authorNameTextField.text == " "        
        saveBarButton.isEnabled = isFieldsEmpty || isFieldsHasOnlySpace ? false : true
    }
}

extension AddBookViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            coverImageView.image = pickedImage
            coverImageView.isHidden = false
            addImageButton.isHidden = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
