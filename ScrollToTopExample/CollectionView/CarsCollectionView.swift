//
//  CarsCollectionView.swift
//  ScrollToTopExample
//
//  Created by John Codeos on 06/08/2019.
//  Copyright © 2019 John Codeos. All rights reserved.
//

import UIKit

class CarsCollectionView: UIViewController {
    
    var CarsArray: Car!

    @IBOutlet weak var colView: UICollectionView!
    
    
    var arrowView = UIView(frame: CGRect.zero)
    
    let arrowImgView = UIImageView(frame: CGRect.zero)
    
    var arrowViewHeight: NSLayoutConstraint!
    var arrowViewWidth: NSLayoutConstraint!
    var arrowViewRight: NSLayoutConstraint!
    var arrowViewBottom: NSLayoutConstraint!
    
    var scrollTop = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CollectionView"
        TapLabelToScrollToTheTop(font: UIFont.systemFont(ofSize: 17, weight: .semibold), textColor: UIColor.white, backgroundColor: UIColor.clear)
        
        
        
        
        //ArrowView
        arrowView.layer.cornerRadius = 25
        arrowView.backgroundColor = UIColor.colorFromHex("#bc214b")
        arrowView.layer.borderWidth = 1.5
        arrowView.layer.borderColor = UIColor.white.cgColor
        self.view.addSubview(arrowView)
        
        
        arrowImgView.image = UIImage(cgImage: UIImage(named: "back-arrow")!.cgImage!, scale: CGFloat(1.0), orientation: .right)
        arrowImgView.image = arrowImgView.image!.withRenderingMode(.alwaysTemplate)
        arrowImgView.tintColor = UIColor.white
        let TapScrollDown = UITapGestureRecognizer(target: self, action: #selector(ScrollToTheTop(_:)))
        arrowImgView.isUserInteractionEnabled = true
        arrowImgView.addGestureRecognizer(TapScrollDown)
        arrowView.addSubview(arrowImgView)
        
        
        SetArrowAutoLayouts()
        
        getJSONData()
    }
    
    @objc func ScrollToTheTop(_ sender: UITapGestureRecognizer) {
        let topOffest = CGPoint(x: 0, y: -(self.colView.contentInset.top))
        self.colView.setContentOffset(topOffest, animated: true)
        //OR
        //self.colView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    func TapLabelToScrollToTheTop(font: UIFont, textColor: UIColor, backgroundColor: UIColor) {
        let titlelabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        titlelabel.text = self.navigationItem.title
        titlelabel.textColor = textColor
        titlelabel.font = font
        titlelabel.backgroundColor = backgroundColor
        titlelabel.textAlignment = .center
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        titlelabel.addGestureRecognizer(tapGestureRecognizer)
        titlelabel.isUserInteractionEnabled = true
        self.navigationItem.titleView = titlelabel
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) { //Press the navigation label to go at the top
        let topOffest = CGPoint(x: 0, y: -(self.colView?.contentInset.top ?? 0))
        self.colView.setContentOffset(topOffest, animated: true)
        //OR
        //self.colView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    @objc func SetArrowAutoLayouts() {
        
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowViewWidth = arrowView.widthAnchor.constraint(equalToConstant: 50)
        arrowViewHeight = arrowView.heightAnchor.constraint(equalToConstant: 50)
        arrowViewBottom = arrowView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
        arrowViewRight = arrowView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 55)
        
        
        arrowViewWidth.isActive = true
        arrowViewHeight.isActive = true
        arrowViewBottom.isActive = true
        arrowViewRight.isActive = true
        
        
        arrowImgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowImgView.topAnchor.constraint(equalTo: arrowView.topAnchor, constant: 8),
            arrowImgView.leadingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: 8),
            arrowImgView.bottomAnchor.constraint(equalTo: arrowView.bottomAnchor, constant: -8),
            arrowImgView.trailingAnchor.constraint(equalTo: arrowView.trailingAnchor, constant: -8)
            ])
    }
    
    
    func getJSONData() {
        if let path = Bundle.main.url(forResource: "CarsDemoData", withExtension: "json" ){
            do {
                let jsonData = try Data(contentsOf: path, options: .alwaysMapped)
                do{
                    let carModel = try? JSONDecoder().decode(Car.self, from: jsonData)
                    CarsArray = carModel
                    self.colView.reloadData()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
    }
}


extension CarsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CarsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = colView.dequeueReusableCell(withReuseIdentifier: "colviewcustomcell", for: indexPath) as? CarsCollectionViewCell {
            cell.carMakeLabel.text = CarsArray[indexPath.row].carMake
            cell.carModelLabel.text = CarsArray[indexPath.row].carModel
            cell.carModelYearLabel.text = "\(CarsArray[indexPath.row].carModelYear ?? 0)" //Convert Int To String
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 400 {
            if scrollTop {
                arrowViewRight.constant = -12
                UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
                scrollTop = false
            }
        }else{
            if !scrollTop {
                arrowViewRight.constant = 55
                UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
                scrollTop = true
            }
        }
    }
    
}

extension CarsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 84
        return CGSize(width: colView.bounds.size.width, height: height)
    }
}
