//
//  OrderDetailsViewController.swift
//  VanongoTestTask
//
//  Created by Maria Ugorets on 01.09.2021.
//

import UIKit
import DKPhotoGallery
import DKImagePickerController

final class OrderDetailsViewController: UIViewController, UIScrollViewDelegate {
    private let model: OrderDetailModel
    private let textLimit = 200
    
    // Notes creation
    private let noteTextLabel: UILabel
    private let noteTextView: UITextView
    
    // Photos gallery
    private let photosScrollView: UIScrollView
    private let photoContainer: UIStackView
    private let addPhotoButton: UIButton
    
    init(model: OrderDetailModel) {
        self.model = model
        
        noteTextLabel = UILabel()
        noteTextView = UITextView()
        
        photosScrollView = UIScrollView()
        photoContainer = UIStackView()
        addPhotoButton = UIButton()

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        self.title = "NotesForDriver".localize()
        setupNotesCreationBlock()
        setupPhotosGallery()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        addPhotoButton.setVerticallyContentAlignment()
        addPhotoButton.setRoundCorners()
        noteTextView.setRoundCorners()
    }

    private func setupNotesCreationBlock() {
        setupNoteTitleLabel()
        setupNoteTextView()

        view.addSubview(noteTextLabel)
        view.addSubview(noteTextView)
        
        NSLayoutConstraint.activate([
            noteTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            noteTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noteTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            noteTextView.topAnchor.constraint(equalTo: noteTextLabel.bottomAnchor, constant: 16),
            noteTextView.heightAnchor.constraint(equalToConstant: 120),
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupNoteTitleLabel() {
        noteTextLabel.text = "NoteTextViewTitle".localize()
        noteTextLabel.textColor = .systemGray
        noteTextLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupNoteTextView() {
        let note = model.getData()?.count == 0 ? nil : model.getData()
        noteTextView.text = note ?? "StartWriting".localize()
        noteTextView.font = .systemFont(ofSize: 14)
        noteTextView.backgroundColor = .systemGray3
        noteTextView.layer.borderWidth = 4.0
        noteTextView.layer.borderColor = UIColor.clear.cgColor
        noteTextView.delegate = self
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupPhotosGallery() {
        setupPhotosScrollView()
        setupPhotosContainer()
        setupAddPhotoButton()
        
        view.addSubview(photosScrollView)
        photosScrollView.addSubview(photoContainer)
        photoContainer.addArrangedSubview(addPhotoButton)
                
        
        NSLayoutConstraint.activate([
            photosScrollView.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 16),
            photosScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            photosScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            photosScrollView.heightAnchor.constraint(equalToConstant: 158),
            
            photoContainer.topAnchor.constraint(equalTo: photosScrollView.topAnchor),
            photoContainer.leadingAnchor.constraint(equalTo: photosScrollView.leadingAnchor),
            photoContainer.trailingAnchor.constraint(equalTo: photosScrollView.trailingAnchor),
            photoContainer.bottomAnchor.constraint(equalTo: photosScrollView.bottomAnchor, constant: 8),
            
            addPhotoButton.heightAnchor.constraint(equalToConstant: 150),
            addPhotoButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupPhotosScrollView() {
        photosScrollView.delegate = self
        photosScrollView.delaysContentTouches = false
        photosScrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupPhotosContainer() {
        photoContainer.axis = .horizontal
        photoContainer.distribution = .fillEqually
        photoContainer.alignment = .fill
        photoContainer.spacing = 10
        photoContainer.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupAddPhotoButton() {
        addPhotoButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        addPhotoButton.setTitle("AddPhoto".localize(), for: .normal)
        addPhotoButton.backgroundColor = .systemGray3
        addPhotoButton.setTitleColor(.systemBlue, for: .normal)

        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        addPhotoButton.addTarget(self,
                                 action: #selector(didTapAddPhotoButton),
                                 for: .touchUpInside)
    }
    
    @objc
    private func didTapAddPhotoButton() {
        let pickerController = pickerController()
        pickerController.didSelectAssets = { [weak self] (assets: [DKAsset]) in
            guard let strongSelf = self else {
                return
            }
            assets.forEach {
                $0.fetchOriginalImage(completeBlock: {(image, info) in
                    if let photoImage = image,
                       strongSelf.photoContainer.arrangedSubviews.count <= 5 {
                        let photoImageContainer = PhotoContainerView(image: photoImage)
                        strongSelf.photoContainer.addArrangedSubview(photoImageContainer)
                        //TODO вывести на UI подсказку об ограничении в 5 фото и заблокировать кнопку добавления фото
                    }
                })
            }
        }

        present(pickerController, animated: true)
    }
    
    private func pickerController() -> DKImagePickerController {
        let pickerController = DKImagePickerController()
        pickerController.maxSelectableCount = 5
        pickerController.assetType = .allPhotos
        return pickerController
    }
}

extension OrderDetailsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "StartWriting".localize() {
            noteTextView.text = ""
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            noteTextView.text = "StartWriting".localize()
        } else {
            model.saveData(textView.text)
        }
        textView.resignFirstResponder()
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = textView.text + text
        if newText.count > textLimit {
            textView.animateBorderColor(toColor: .systemPink, duration: 0.2)
            //TODO: добавить подсказку для пользователя о максимальном количестве символов
            return false
        } else {
            return true
        }
    }
}
