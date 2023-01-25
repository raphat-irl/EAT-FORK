//
//  DetailViewController.swift
//  EAT&FORK
//
//  Created by MacbookAir M1 FoodStory on 12/1/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DetailDisplayLogic: class
{
  func displaySomething(viewModel: Detail.Something.ViewModel)
}

protocol DetailDelegate {
    func addMenuFromDetail(menu: [Main.MainModels.MenuQuantity])
}



class DetailViewController: UIViewController, DetailDisplayLogic
{

  @IBOutlet weak var quantityControlView:UIView!
  @IBOutlet weak var menuImage:UIImageView!
  @IBOutlet weak var menuNameLabel:UILabel!
  @IBOutlet weak var menuDescLabel:UILabel!
  @IBOutlet weak var menuPriceLabel:UILabel!
  @IBOutlet weak var totalPriceLabel:UILabel!
  @IBOutlet weak var plusButton:UIButton!
  @IBOutlet weak var minusButton:UIButton!
  @IBOutlet weak var menuCountLabel:UILabel!
  @IBOutlet weak var basketmenuCountLabel:UILabel!
  @IBOutlet weak var basketPriceLabel:UILabel!
  @IBOutlet weak var webDetailButton:UIButton!
  @IBOutlet weak var closeButton:UIButton!
  @IBOutlet weak var addToBasketButton:UIButton!
    
  var wantedQuantity: Int = 1
  var delegate:DetailDelegate?
  var menuSumPrice : Int = 0
  var menuSumQuantity : Int = 0
  var addMenu: [Main.MainModels.MenuQuantity] = []
    
  var menuList: Main.getMenu.ViewModel?
  var interactor: DetailBusinessLogic?
  var router: (NSObjectProtocol & DetailRoutingLogic & DetailDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = DetailInteractor()
    let presenter = DetailPresenter()
    let router = DetailRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomething()
    setupBasketUI()
    setupui()
  }
    
    func setupBasketUI(){
        for items in addMenu {
            menuSumPrice += items.menu.price * items.quantity
            basketPriceLabel.text = "฿\(String(format: "%d", menuSumPrice))"
            menuSumQuantity += items.quantity
            basketmenuCountLabel.text = String(menuSumQuantity)
        }
    }
    
    func setupui(){
        //TEST
        
        totalPriceLabel.text = String(menuList?.price ?? 0)
        menuImage.kf.setImage(with: URL(string: menuList?.image_url ?? ""))
        menuNameLabel.text = menuList?.name
        menuDescLabel.text = menuList?.desc
        menuPriceLabel.text = String(menuList?.price ?? 0)
        
    }
  
  // MARK: Do something
    
    @IBAction func plusButtonTapped(_ sender:UIButton){
        wantedQuantity += 1
        menuCountLabel.text = String(wantedQuantity)
        print(wantedQuantity)
    }
    
    @IBAction func minusButtonTapped(_ sender:UIButton){
        if wantedQuantity == 1{
            minusButton.isEnabled = false
        } else {
            minusButton.isEnabled = true
            wantedQuantity -= 1
            menuCountLabel.text = String(wantedQuantity)
        }
    }
    
    @IBAction func addToBasketButtonTapped(_ sender:UIButton){
        
        guard let menu = menuList else { return }
        if let existingMenu = addMenu.first(where: {$0.menu.id == menu.id}){
            existingMenu.quantity += wantedQuantity
        } else {
            let newMenu = Main.MainModels.MenuQuantity(menu: menu, quantity: wantedQuantity)
            addMenu.append(newMenu)
            
        }
        //test
        for items in addMenu{
        print("Menu: \(items.menu.name), Price: \(items.menu.price), Quantity:\(items.quantity)")
        print(menuSumQuantity)
        }
        
        delegate?.addMenuFromDetail(menu: addMenu)
        router?.dismissToMain()
    }
           

    
    @IBAction func onCloseButtonTapped(_ sender:UIButton){
        router?.dismissToMain()
    }
  
    @IBAction func onOpenWebButtonTapped(_ sender:UIButton){
        router?.openWebButtonDetail(menu: menuList)
    }
  
  func doSomething()
  {
    let request = Detail.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: Detail.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
}

