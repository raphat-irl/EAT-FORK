//
//  Response.swift
//  EAT&FORK
//
//  Created by MacbookAir M1 FoodStory on 14/1/2566 BE.
//

import Foundation

struct MenuResponse: Codable {
    var id: Int
    var name: String
    var desc: String
    var url: String
    var price: Int
    var image_url: String
}
