//
//  BillPopUpView.swift
//  EAT&FORK
//
//  Created by MacbookAir M1 FoodStory on 20/1/2566 BE.
//

import Foundation
import UIKit

class BillPopUpView: UIView {
    
    @IBOutlet weak var backToMainButton:UIButton!
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    }
    
    func xibSetUp(frame:CGRect){
        let view = loadXib()
        view.frame = frame
        addSubview(view)
    }
    
    func loadXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BillPopUpView", bundle: bundle)
        let view = nib.instantiate(withOwner: self,options: nil).first as? UIView
        return view!
    }
    
}
