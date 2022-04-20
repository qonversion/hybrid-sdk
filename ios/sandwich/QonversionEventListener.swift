//
//  QonversionEventListener.swift
//  QonversionSandwich
//
//  Created by Kamo Spertsyan on 13.04.2022.
//  Copyright © 2022 Qonversion Inc. All rights reserved.
//

import Foundation

@objc public protocol QonversionEventListener {

  @objc func qonversionDidReceiveUpdatedPermissions(_ permissions: [String: Any])
  
  @objc func shouldPurchasePromoProduct(with productId: String)
}
