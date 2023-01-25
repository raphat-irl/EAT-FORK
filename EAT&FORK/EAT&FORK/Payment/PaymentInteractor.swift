//
//  PaymentInteractor.swift
//  EAT&FORK
//
//  Created by MacbookAir M1 FoodStory on 14/1/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PaymentBusinessLogic
{
  func doSomething(request: Payment.Something.Request)
}

protocol PaymentDataStore
{
  
}

class PaymentInteractor: PaymentBusinessLogic, PaymentDataStore
{
  var presenter: PaymentPresentationLogic?
  var worker: PaymentWorker?
  
  // MARK: Do something
  func doSomething(request: Payment.Something.Request)
  {
    worker = PaymentWorker()
    worker?.doSomeWork()
    
    let response = Payment.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
