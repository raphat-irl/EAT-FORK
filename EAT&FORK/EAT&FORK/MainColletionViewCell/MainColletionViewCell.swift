//
//  MainColletionViewCell.swift
//  EAT&FORK
//
//  Created by MacbookAir M1 FoodStory on 12/1/2566 BE.
//
protocol MainColletionDelegate {
    func addButtonTapped(for cell: MainColletionViewCell)
}

import Foundation
import UIKit
import Kingfisher

class MainColletionViewCell:UICollectionViewCell {
    
    var delegate:MainColletionDelegate?
    
    @IBOutlet weak var menuImage:UIImageView!
    @IBOutlet weak var menuNameLabel:UILabel!
    @IBOutlet weak var priceLabel:UILabel!
    @IBOutlet weak var addButton:UIButton!
    @IBOutlet weak var addView:UIView!
    @IBOutlet weak var menuAddLabel:UILabel!
    @IBOutlet weak var bathLabel:UILabel!
    @IBOutlet weak var bgViewConstraint:NSLayoutConstraint!
    
    var quantity: Int = 0
    
    var menuSumPrice: Int = 0
    
    var menuSumQuantity: Int = 0
    
    var indexPath: IndexPath?
    
    static let identifier = "MainColletionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setCell(menu: Main.getMenu.ViewModel, itemWidth: CGFloat){
        
        menuImage.kf.setImage(with: URL(string: menu.image_url))
    
        bathLabel.text = bathLabel.text
        menuNameLabel.text = menu.name
        priceLabel.text = String(menu.price)
        
    }
    
    @IBAction func addButtonTapped(_sender: Any){
            
        quantity = 0
        menuSumPrice = 0
        menuSumQuantity = 0
        var indexPath: IndexPath?
        delegate?.addButtonTapped(for: self)
        
        addView.isHidden = false
    }
}
