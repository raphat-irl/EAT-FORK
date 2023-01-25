//
//  PaymentModels.swift
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

enum Payment
{
    enum calculateMenu
    {
        struct Request
        {
            var addMenu: [Main.MainModels.MenuQuantity]
            var menuSumPrice: Double
        }
        struct Response
        {
            var menuSumPrice: Double
            var serviceCost: Double
            var taxCost: Double
            var totalPrice: Double
        }
        struct ResponseFail {
            var addMenu: [Main.MainModels.MenuQuantity]
        }
        struct ViewModel
        {
            var menuSumPriceLabelText: String
            var servicePriceLabelText: String
            var taxPriceLabelText: String
            var totalPriceLabelText: String
            var paidTotalPriceLabelText: String
        }
        struct ViewModelFail
        {
            var addMenu: [Main.MainModels.MenuQuantity]
        }
    }
}