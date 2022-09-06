//
//  SandwichError.swift
//  QonversionSandwich
//
//  Created by Kamo Spertsyan on 13.04.2022.
//  Copyright © 2022 Qonversion Inc. All rights reserved.
//

import Foundation

public class SandwichError: NSObject {
  public let code: String
  public let domain: String
  public let details: String
  public let additionalMessage: String?
  public var additionalInfo: [String: Any]
  
  public init(code: String,
              domain: String,
              details: String,
              additionalMessage: String?,
              additionalInfo: [String: Any] = [:]) {
    self.code = code
    self.domain = domain
    self.details = details
    self.additionalMessage = additionalMessage
    self.additionalInfo = additionalInfo
  }
}
