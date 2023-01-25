//
//  PaymentTableViewCell.swift
//  EAT&FORK
//
//  Created by MacbookAir M1 FoodStory on 14/1/2566 BE.
//

import Foundation
import UIKit
import Kingfisher

class PaymentTableViewCell:UITableViewCell{
    
    @IBOutlet weak var menuImage:UIImageView!
    @IBOutlet weak var menuNameLabel:UILabel!
    @IBOutlet weak var menuPriceLabel:UILabel!
    @IBOutlet weak var quantityLabel:UILabel!
    
    static let identifier = "PaymentTableViewCell"
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setPaymentCell(menu:Main.MainModels.MenuQuantity){

        menuNameLabel.text = menu.menu.name
        menuImage.kf.setImage(with: URL(string: menu.menu.image_url))
        quantityLabel.text = "\(menu.quantity)x"
        menuPriceLabel.text = "฿ \(menu.menu.price).00"

    }
}
