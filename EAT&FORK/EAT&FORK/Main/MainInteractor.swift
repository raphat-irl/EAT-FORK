//
//  MainInteractor.swift
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

protocol MainBusinessLogic
{
  func getMenu()
  func filterSearchText(_ searchText:String)

}

protocol MainDataStore
{
  //var name: String { get set }
}

class MainInteractor: MainBusinessLogic, MainDataStore
{

  var presenter: MainPresentationLogic?
  var worker: MainWorker?
  var searchFilterObj: Main.getMenu.Response = Main.getMenu.Response()
  var selectedIndexPath: IndexPath?

  //var name: String = ""
  
  // MARK: Do something
    
  func getMenu(){
      worker = MainWorker()
      worker?.getMenu(completion: { [weak self] (base) in
        guard let strongSelf = self else { return }
          let response = Main.getMenu.Response(menuList: base)
          strongSelf.searchFilterObj = response
        strongSelf.presenter?.presentMenuList(response: response)
      }, failure: { [weak self] (error) in
        guard let strongSelf = self else { return }
      
      // strongSelf.presenter?.presentGetDeliveryTime(response: response)
      })
    }
    
    func filterSearchText(_ searchText:String){
        if searchText.isEmpty {
            presenter?.presentMenuList(response: searchFilterObj)
        } else {
            let searchFilterList = searchFilterObj.menuList?.filter{$0.name.contains(searchText)}
            presenter?.presentSearchFilterList(response: searchFilterList ?? [])
        }
    }
}




