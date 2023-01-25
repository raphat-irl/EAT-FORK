//
//  MainViewController.swift
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

protocol MainDisplayLogic: class
{
  func displayMenuList(viewModel: [Main.getMenu.ViewModel])
    
}

class MainViewController: UIViewController, MainDisplayLogic, UISearchBarDelegate, UISearchControllerDelegate,UISearchResultsUpdating, MainTableViewCellDelegate, MainColletionDelegate
{

    @IBOutlet weak var summaryPriceLabel:UILabel!
    
    @IBOutlet weak var summaryButton:UIButton!

    @IBOutlet weak var summaryView:UIView!
    
    @IBOutlet weak var changeToTableViewCellButton:UIButton!
    @IBOutlet weak var changeToColletionViewCellButton:UIButton!
    
    private var itemWidth: CGFloat = 0
    private var itemHight: CGFloat = 0
    
    var searchFilterList: [Main.getMenu.ViewModel] = []
    var searchText: String = ""
    
    
    @IBOutlet weak var menuViewColletion: UICollectionView!
    @IBOutlet weak var menuView: UITableView!
    
    private let searchBar = UISearchBar()
    
    var previousButton: UIButton?
    
    var menuList: [Main.getMenu.ViewModel] = []
    
    var addMenu: [Main.MainModels.MenuQuantity] = []
    
  var interactor: MainBusinessLogic?
  var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?

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
    let interactor = MainInteractor()
    let presenter = MainPresenter()
    let router = MainRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
    
    func setupUI() {
        
        menuView.register(UINib(nibName: "MainTableViewCell", bundle: nil),
                          forCellReuseIdentifier: MainTableViewCell.identifier)
        
        menuViewColletion.register(UINib(nibName: "MainColletionViewCell", bundle: nil), forCellWithReuseIdentifier: MainColletionViewCell.identifier)
        
        var screenWidth = UIScreen.main.bounds.width
        screenWidth -= 60

        itemWidth = screenWidth / CGFloat(2)
        itemHight = 150
        
        changeToTableViewCellButton.layer.cornerRadius = 8
        changeToColletionViewCellButton.layer.cornerRadius = 8
        
        searchFilterList = menuList
    }
  
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuView.reloadData()
        menuViewColletion.reloadData()
        changeToTableViewCellButton.backgroundColor = HexColor.color(hex: "DCB042")
        
    }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    getMenu()
    setupUI()
    setupsearchController()
  
    changeToTableViewCellButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    changeToColletionViewCellButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
      
  }
    
  // MARK: Do something
    
    @objc func buttonPressed(sender: UIButton) {
        changeToTableViewCellButton.backgroundColor = HexColor.color(hex: "C0C0C0")
        if let previous = previousButton {
            previous.backgroundColor = HexColor.color(hex: "C0C0C0")
        }
        sender.backgroundColor = HexColor.color(hex: "DCB042")
        previousButton = sender
    }
    
    @IBAction func ChangeToTableViewCellButtonTapped(){
        menuViewColletion.isHidden = true
        menuView.isHidden = false
        menuView.reloadData()
        menuViewColletion.reloadData()
    }
    
    @IBAction func ChangeToColletionViewCellButtonTapped(){
        menuView.isHidden = true
        menuViewColletion.isHidden = false
        menuView.reloadData()
        menuViewColletion.reloadData()
    }
    
    @IBAction func summaryButtonTapped(){
        router?.routeToPaymentView(data: addMenu)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            
            return
        }
        filterContentForSearchText(searchText)
    }
    
    func getMenu(){
        interactor?.getMenu()
    }
    
    func displayMenuList(viewModel: [Main.getMenu.ViewModel]) {
        menuList = viewModel
        searchFilterList = viewModel
        menuView.reloadData()
        menuViewColletion.reloadData()
    }

    func setupsearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.becomeFirstResponder()
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "ค้นหาเมนู"
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
    
        definesPresentationContext = true
    }
    
    func filterContentForSearchText(_ searchText:String){
        interactor?.filterSearchText(searchText)
    }
    
}

extension MainViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath as IndexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        let menuObj = menuList[indexPath.row]
        cell.setCell(menu: menuObj)
        if let item = addMenu.first(where: { $0.menu == menuObj }) {
            cell.addView.isHidden = false
            cell.menuAddLabel.text = String(item.quantity)
        } else {
            cell.addView.isHidden = true
            cell.menuAddLabel.text = ""
        }
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    func addButtonTapped(for cell:MainTableViewCell) {
        
        summaryView.isHidden = false
        
        if let index = cell.indexPath?.row, menuList.count > index {
            let menu = menuList[index]
            if let item = addMenu.first(where: {$0.menu == menu }){
                item.quantity += 1
                cell.quantity = item.quantity
                cell.menuAddLabel.text = String(item.quantity)
               
            } else {
                addMenu.append(Main.MainModels.MenuQuantity(menu: menu, quantity: 1))
          
                cell.quantity = 1
                cell.menuAddLabel.text = "1"
            }
            
            for items in addMenu{
                cell.menuSumPrice += items.menu.price * items.quantity
                cell.menuSumQuantity += items.quantity
                summaryPriceLabel.text = "฿\(String(format: "%d", cell.menuSumPrice)).00 "
                print("Menu: \(items.menu.name), Price: \(items.menu.price), Quantity:\(items.quantity)")
                print(cell.menuSumPrice)
                print(cell.menuSumQuantity)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = menuList[indexPath.row]
        
        router?.routeToDetailView(data: data, basketData: addMenu)
    }   
}

extension MainViewController:UICollectionViewDataSource
,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainColletionViewCell.identifier, for: indexPath as IndexPath) as? MainColletionViewCell else {
            return UICollectionViewCell()
        }
        
        let menuObj = menuList[indexPath.row]
        cell.setCell(menu: menuObj, itemWidth: self.itemWidth)
        if let item = addMenu.first(where: { $0.menu == menuObj }) {
            cell.addView.isHidden = false
            cell.menuAddLabel.text = String(item.quantity)
        } else {
            cell.addView.isHidden = true
            cell.menuAddLabel.text = ""
        }
        cell.indexPath = indexPath
        cell.delegate = self
        return cell

    }
    
    func addButtonTapped(for cell: MainColletionViewCell) {
        
        summaryView.isHidden = false
            
        if let index = cell.indexPath?.row, menuList.count > index {
            let menu = menuList[index]
            if let item = addMenu.first(where: {$0.menu == menu }){
                item.quantity += 1
                cell.quantity = item.quantity
                cell.menuAddLabel.text = String(item.quantity)
            } else {
                addMenu.append(Main.MainModels.MenuQuantity(menu: menu, quantity: 1))
                cell.quantity = 1
                cell.menuAddLabel.text = "1"
            }
                
            for items in addMenu {
                cell.menuSumPrice += items.menu.price * items.quantity
                cell.menuSumQuantity += items.quantity
                summaryPriceLabel.text = "฿\(String(format: "%d", cell.menuSumPrice)).00 "
                print("Menu: \(items.menu.name), Price: \(items.menu.price), Quantity:\(items.quantity)")
                print(cell.menuSumPrice)
                print(cell.menuSumQuantity)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemHight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = menuList[indexPath.row]
        router?.routeToDetailView(data: data, basketData: addMenu)
    }
}
extension MainViewController:PaymentDelegate{
 
    func backToMain(data: [Main.MainModels.MenuQuantity]) {
        
        var menuSumPrice: Int = 0
        
        addMenu = data
        if addMenu.count == 0 {
            summaryView.isHidden = true
            summaryPriceLabel.text  = ""
        } else {
            summaryView.isHidden = false
            for items in addMenu{
                menuSumPrice += items.menu.price * items.quantity
                summaryPriceLabel.text = "฿\(String(format: "%d", menuSumPrice)).00 "
            }
        }
        menuView.reloadData()
        menuViewColletion.reloadData()
    }
}
extension MainViewController:DetailDelegate{
    func addMenuFromDetail(menu: [Main.MainModels.MenuQuantity]) {
        backToMain(data: menu)
    }

}
extension Main.getMenu.ViewModel: Equatable {
    static func == (lhs: Main.getMenu.ViewModel, rhs: Main.getMenu.ViewModel) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price
    }
}




