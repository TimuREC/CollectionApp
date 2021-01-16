//
//  CollectionViewController.swift
//  CollectionApp
//
//  Created by Timur Begishev on 13.01.2021.
//

import UIKit
import Alamofire

class CollectionViewController: UICollectionViewController {
    
    let itemsInRow: CGFloat = 2
    let insetsSize = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        getImages(count: 10)

        print("viewDidLoad ended")
    }
	
	private func getImages(count: Int) {
		for _ in 0..<count {
			AF.request("https://picsum.photos/500").responseData { (response) in
				guard response.error == nil,
					  let data = response.data,
					  let image = UIImage(data: data)
				else { return }
				
				self.images.append(image)
				self.collectionView.reloadData()
			}
		}
	}

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "openPhotoView", let sender = sender as? CollectionCell {
			let destVC = segue.destination as! PhotoViewController
			destVC.dataSourceVC = self
			destVC.index = collectionView.indexPath(for: sender)!
		}
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionCell
        cell.configure(with: images[indexPath.item])
    
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let itemWidth = (width - (insetsSize.left * (itemsInRow + 1))) / itemsInRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetsSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insetsSize.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return insetsSize.left
    }
}
