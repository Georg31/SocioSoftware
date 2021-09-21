//
//  ViewController.swift
//  SocioSoftware
//
//  Created by George Digmelashvili on 9/21/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var PhotoDataSource: CollectionViewDataSource<PhotoCells, PhotoViewModel>!
    private var menuView: MenuView!
    private let api = ApiCall.shared
    private let dataBase = Dbase.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configViewController()
        checkBackGround()
    }
    
    @IBAction func menuButton(_ sender: Any) {
        menuView.show()
        
    }
    
    @IBAction func photosButton(_ sender: UIButton) {
        self.collectionView.isHidden = false
        fecthPhotos()
    }
    
    
    
    private func configViewController(){
        self.menuView = MenuView(frame: self.view.frame)
        self.view.addSubview(menuView)
        self.collectionView.register(UINib(nibName: PhotoCells.identifier, bundle: nil), forCellWithReuseIdentifier: PhotoCells.identifier)
        self.PhotoDataSource = CollectionViewDataSource(cellIdentifier: PhotoCells.identifier, item: []) {cell, viewM in
            cell.photo = viewM
        }
        self.collectionView.dataSource = self.PhotoDataSource
        self.collectionView.delegate = self
    }
    
    private func fecthPhotos(_ nextPage: Bool = false){
        let ind = PhotoDataSource.count()
        if nextPage{
            let index = Array(ind..<ind + 20).map {IndexPath(row: $0, section: 0)}
            self.api.fetchPhotos(self.PhotoDataSource.count() / 20 + 1) { photos in
                self.PhotoDataSource.appendItem(photos.photos)
                self.collectionView.insertItems(at: index)
            }
        } else {
            self.api.fetchPhotos { photos in
                self.PhotoDataSource.updateItem(photos.photos)
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setBackGroundImage(_ imgUrl: String?){
        guard let imgUrl = imgUrl else { return }
        
        let alert = UIAlertController(title: "SocioSoftware", message: "Background Was Changed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Next Time", style: .cancel))
        alert.addAction(UIAlertAction(title: "Show Me", style: .default, handler: { action in
            self.collectionView.isHidden = true
        }))
        
        imgUrl.downloadImage(completion: { img in
            self.imageView.image = img
            self.present(alert, animated: true)
            self.dataBase.saveBackGround(img!)
        })
    }
    
    private func checkBackGround(){
        if let img = dataBase.getBackGround(){
            self.imageView.image = img
            self.collectionView.isHidden = true
        }
    }
    
}


extension ViewController: UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setBackGroundImage(PhotoDataSource.atIndex(indexPath).imgUrl)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == self.PhotoDataSource.count() - 6 ){
            fecthPhotos(true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 1, bottom: 5, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth/2.02, height: collectionViewWidth/1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
}
