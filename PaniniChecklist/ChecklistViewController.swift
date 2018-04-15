//
//  ChecklistViewController.swift
//  PaniniChecklist
//
//  Created by Stefan Andric on 4/13/18.
//  Copyright © 2018 stefandric. All rights reserved.
//

import UIKit
import RealmSwift

class ChecklistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var stickerCollection: UICollectionView! {
        didSet {
            stickerCollection.register(UINib.init(nibName: "StickerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "stickerCell")
            stickerCollection.delegate = self
            stickerCollection.dataSource = self
        }
    }
    private var collectedItems = 0
    private var duplicateItems = 0
    @IBOutlet weak var stastBarItem: UIBarButtonItem! {
        didSet {
            stastBarItem.image = UIImage(named:"charts")?.withRenderingMode(.alwaysOriginal)
            
        }
    }
    
    let realm = try! Realm()
    
    @IBOutlet weak var collectedStickers: UIBarButtonItem!
    
    private var stickers: Results<Sticker>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if !Prefs.isFirstTime {
            Prefs.isFirstTime = true
            addStickers()
        }
        
        stickers = realm.objects(Sticker.self)
        collectedItems = realm.objects(Sticker.self).filter("isSelected == true").count
        collectedStickers.title = "Collected: \(collectedItems)"
        duplicateItems = totalNumberOfDuplicates()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickers!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as! StickerCollectionViewCell
        let sticker = stickers![indexPath.row]
        cell.stickerNumber.text = "\(indexPath.row+1)"
        cell.overlayView.isHidden = !sticker.isSelected
        cell.duplicateNumber.text = "\(sticker.numberOfDuplicates)"
        cell.duplicateNumber.textColor = sticker.numberOfDuplicates > 0 ? .blue : .red
        
        cell.plusButton.tag = indexPath.row
        cell.minusButton.tag = indexPath.row
        
        cell.plusButton.addTarget(self, action: #selector(plusTapped(_:)), for: .touchUpInside)
        cell.minusButton.addTarget(self, action: #selector(minusTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func plusTapped(_ sender: UIButton) {
        let sticker = stickers![sender.tag]
        try! realm.write {
            sticker.numberOfDuplicates += 1
            stickerCollection.reloadData()
        }
        duplicateItems += 1
    }
    
    @objc func minusTapped(_ sender: UIButton) {
        let sticker = stickers![sender.tag]
        if sticker.numberOfDuplicates == 0 {
            return
        }
        try! realm.write {
            sticker.numberOfDuplicates -= 1
            stickerCollection.reloadData()
        }
        duplicateItems -= 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sticker = stickers![indexPath.row]
        if sticker.isSelected {
            collectedItems -= 1
        } else {
            collectedItems += 1
        }
        collectedStickers.title = "Collected: \(collectedItems)"
        
        try! realm.write {
            sticker.isSelected = !sticker.isSelected
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width/4, height: UIScreen.main.bounds.size.width/4)
    }
    
    private func addStickers() {
        for i in 0...668 {
            let sticker = Sticker()
            sticker.elementId = i
            sticker.isSelected = false
            try! realm.write {
                realm.add(sticker)
            }
        }
    }
    
    private func totalNumberOfDuplicates() -> Int {
        var duplicates = 0
        let duplicateObjects = realm.objects(Sticker.self).filter("numberOfDuplicates > 0")
        for duplicate in duplicateObjects {
            duplicates += duplicate.numberOfDuplicates
        }
        
        return duplicates
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chartsSegue" {
            let chartVC = segue.destination as! ChartsViewController
            chartVC.collectedImages = collectedItems
            chartVC.duplicates = duplicateItems
        }
    }
    
    @IBAction func statsItemTapped(_ sender: Any) {
        performSegue(withIdentifier: "chartsSegue", sender: nil)
    }
    
}
