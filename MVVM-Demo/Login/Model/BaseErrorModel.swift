//
//  BaseErrorModel.swift
//  MVVM-Demo
//
//  Created by iMac on 08/07/2021.
//


import Foundation

struct BaseErrorModel: Codable {
    let message: String?
    let status_code: Int?
}

