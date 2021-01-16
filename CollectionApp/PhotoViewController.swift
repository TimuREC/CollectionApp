//
//  PhotoViewController.swift
//  CollectionApp
//
//  Created by Timur Begishev on 14.01.2021.
//

import UIKit
import Alamofire

class PhotoViewController: UIViewController {
	
	@IBOutlet weak var navigatonBar: UINavigationBar!
	@IBOutlet weak var toolbar: UIToolbar!
	
	@IBOutlet weak var previewCollectionView: UICollectionView!
	@IBOutlet weak var thumbnailsCollectionView: UICollectionView!
	
	weak var dataSourceVC: CollectionViewController?
	var index: IndexPath?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		previewCollectionView.dataSource = dataSourceVC
		thumbnailsCollectionView.dataSource = dataSourceVC
		previewCollectionView.delegate = self
		thumbnailsCollectionView.delegate = self
    }
	
	override func viewDidLayoutSubviews() {
		if index != nil {
			previewCollectionView.scrollToItem(at: index!, at: .centeredHorizontally, animated: false)
			thumbnailsCollectionView.scrollToItem(at: index!, at: .centeredHorizontally, animated: false)
			index = nil
		}
	}
	
	
	@IBAction func closePhotoView(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func share(_ sender: Any) {
		let index = previewCollectionView.indexPathsForVisibleItems[0].item
		let item = dataSourceVC!.images[index]
		let shareController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
		present(shareController, animated: true, completion: nil)
	}
	
	@IBAction func addImage(_ sender: Any) {
		let index = previewCollectionView.indexPathsForVisibleItems[0].item

		AF.request("https://picsum.photos/500").responseData { (response) in
			guard let data = response.data,
				  let image = UIImage(data: data) else { return }
			
			self.dataSourceVC?.images.insert(image, at: index)
			self.reloadCollections()
		}
	}
	
	@IBAction func removeImage(_ sender: Any) {
		let index = previewCollectionView.indexPathsForVisibleItems[0]
		dataSourceVC!.images.remove(at: index.item)
		previewCollectionView.deleteItems(at: [index])
		thumbnailsCollectionView.deleteItems(at: [index])
		reloadCollections()
	}
	
	private func reloadCollections() {
		previewCollectionView.reloadData()
		thumbnailsCollectionView.reloadData()
		dataSourceVC!.collectionView.reloadData()
	}
	
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		switch collectionView {
		case previewCollectionView:
			UIView.animate(withDuration: 0.3) {
				self.toolbar.alpha = self.toolbar.alpha == 0 ? 1 : 0
				self.navigatonBar.alpha = self.toolbar.alpha
			}
		case thumbnailsCollectionView:
			previewCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
			thumbnailsCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
		default:
			return
		}
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if scrollView == previewCollectionView {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
				print(self.previewCollectionView.indexPathsForVisibleItems)
				let index = self.previewCollectionView.indexPathsForVisibleItems[0]
				self.thumbnailsCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
			}
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = UIScreen.main.bounds.width
		switch collectionView {
		case previewCollectionView:
			return CGSize(width: width, height: width)
		case thumbnailsCollectionView:
			return CGSize(width: 50, height: 50)
		default:
			return CGSize(width: 50, height: 50)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		switch collectionView {
		case previewCollectionView:
			return UIEdgeInsets.zero
		case thumbnailsCollectionView:
			let widthInsets = (UIScreen.main.bounds.width - 25) / 2
			return UIEdgeInsets(top: 0, left: widthInsets, bottom: 0, right: widthInsets)
		default:
			return UIEdgeInsets.zero
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		switch collectionView {
		case previewCollectionView:
			return 0
		case thumbnailsCollectionView:
			return 5
		default:
			return 0
		}
	}
	
}
