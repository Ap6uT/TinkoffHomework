//
//  GalleryViewController.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 16.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let model: IGalleryModel
    private let presentationAssembly: IPresentationAssembly
    
    var closure: ((_: UIImage?) -> Void)?
    
    init(model: IGalleryModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: "Gallery", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let cellNib = UINib(nibName: "GalleryCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "GalleryCell")

        model.getImages(for: 1, complition: {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        })
        
        addEmitter()
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as? GalleryCell
        else { return UICollectionViewCell() }
        let imageURL = model.gallery[indexPath.row].webformatURL
        cell.configure(imageURL: imageURL)
        return cell
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3.19, height: collectionView.frame.width / 3.19)
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let cell = collectionView.cellForItem(at: indexPath) as? GalleryCell,
           let image = cell.getImage() {
            closure?(image)
            dismiss(animated: true, completion: nil)
        }
    }
}
