//
//  MainTableViewCell.swift
//  EAT&FORK
//
//  Created by MacbookAir M1 FoodStory on 12/1/2566 BE.
//

import Foundation
import UIKit

protocol MainTableViewCellDelegate {
    func addButtonTapped(for cell:MainTableViewCell)
}

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuImage:UIImageView!
    @IBOutlet weak var menuNameLabel:UILabel!
    @IBOutlet weak var priceLabel:UILabel!
    @IBOutlet weak var addButton:UIButton!
    @IBOutlet weak var addView:UIView!
    @IBOutlet weak var menuAddLabel:UILabel!
    @IBOutlet weak var bathLabel:UILabel!
    
    var delegate: MainTableViewCellDelegate?
    
    var addMenu: [Main.MainModels.MenuQuantity] = []
    
    var quantity: Int = 0
    
    var menuSumPrice: Int = 0
    
    var menuSumQuantity: Int = 0
    
    var indexPath: IndexPath?
    
    static let identifier = "MainTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        

        self.menuAddLabel.isHidden = false
        self.addView.isHidden = true
        
    }
    
    func setCell(menu:Main.getMenu.ViewModel) {
        
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
