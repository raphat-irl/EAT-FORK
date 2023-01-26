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

protocol DetailDisplayLogic: AnyObject
{
    func displayBasketUI(viewModel: Detail.calculateBasketUI.ViewModel)
    func displayMenuUI(viewModel: Detail.setUpUI.ViewModel)
}

protocol DetailDelegate {
    func addMenuFromDetail(menu: [Main.MainModels.MenuQuantity])
}

class DetailViewController: UIViewController, DetailDisplayLogic {

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
    setupBasketUI()
      setupUI()
  }
        
  // MARK: Do something
    
    @IBAction func plusButtonTapped(_ sender:UIButton){
        wantedQuantity += 1
        menuCountLabel.text = String(wantedQuantity)
        minusButton.isEnabled = true
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
//        //test
//        for items in addMenu{
//        print("Menu: \(items.menu.name), Price: \(items.menu.price), Quantity:\(items.quantity)")
//        print(menuSumQuantity)
//        }
        
        delegate?.addMenuFromDetail(menu: addMenu)
        router?.dismissToMain()
    }
           
    @IBAction func onCloseButtonTapped(_ sender:UIButton){
        router?.dismissToMain()
    }
  
    @IBAction func onOpenWebButtonTapped(_ sender:UIButton){
        router?.openWebButtonDetail(menu: menuList)
    }
  
  func setupBasketUI()
  {
      let request = Detail.calculateBasketUI.Request(addMenu: addMenu, menuSumPrice: menuSumPrice)
      interactor?.setupBasketUI(request: request)
  }
    
    func displayBasketUI(viewModel: Detail.calculateBasketUI.ViewModel)
  {
      basketPriceLabel.text = viewModel.basketPriceLabelText
      basketmenuCountLabel.text = viewModel.basketmenuCountLabelText
  }
    
    func setupUI()
    {
        let request = Detail.setUpUI.Request(menuList: menuList)
        interactor?.setupUI(request: request)
    }
    
    func displayMenuUI(viewModel: Detail.setUpUI.ViewModel)
    {
        menuImage.kf.setImage(with: URL(string: viewModel.menuImageURL))
        totalPriceLabel.text = viewModel.totalPriceLabelText
        menuNameLabel.text = viewModel.menuNameLabelText
        menuDescLabel.text = viewModel.menuDescLabelText
        menuPriceLabel.text = viewModel.menuPriceLabelText
    }
}

