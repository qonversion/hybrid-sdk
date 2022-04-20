//
//  Mappers.swift
//  QonversionSandwich
//
//  Created by Kamo Spertsyan on 11.04.2022.
//  Copyright © 2022 Qonversion Inc. All rights reserved.
//

import Foundation
import Qonversion

extension BridgeData {
    func clearEmptyValues() -> [String: Any] {
        func clear(_ value: Any?) -> Any? {
            if let value = value as? [Any?] {
                return value.compactMap {
                    clear($0)
                }
            } else if let value = value as? [String: Any?] {
                return value.compactMapValues {
                    clear($0)
                }
            } else {
                return value
            }
        }
        
        return compactMapValues {
            clear($0)
        }
    }
}

extension NSError {
  func toSandwichError() -> SandwichError {
    return SandwichError(
      code: String(code),
      domain: domain,
      details: localizedDescription,
      additionalMessage: userInfo[NSDebugDescriptionErrorKey] as? String
    )
  }
  
  func toMap() -> BridgeData {
    let errorMap = [
      "code": code,
      "domain": domain,
      "description": localizedDescription,
      "additionalMessage": userInfo[NSDebugDescriptionErrorKey]]
    
    return errorMap
  }
}

extension Qonversion.LaunchResult {
  func toMap() -> BridgeData {
    return [
      "uid": uid,
      "timestamp": NSNumber(value: timestamp).intValue * 1000,
      "products": products.mapValues { $0.toMap() },
      "permissions": permissions.mapValues { $0.toMap() },
      "userProducts": userPoducts.mapValues { $0.toMap() },
    ]
  }
}

extension Qonversion.Product {
  func toMap() -> BridgeData {
    return [
        "id": qonversionID,
        "storeId": storeID,
        "type": type.rawValue,
        "duration": duration.rawValue,
        "skProduct": skProduct?.toMap(),
        "prettyPrice": prettyPrice,
        "trialDuration": trialDuration.rawValue,
        "offeringId": offeringID
    ]
  }
}

extension Qonversion.Permission {
  func toMap() -> BridgeData {
    return [
      "id": permissionID,
      "associatedProduct": productID,
      "renewState": renewState.rawValue,
      "startedTimestamp": startedDate.toMilliseconds(),
      "expirationTimestamp": expirationDate.map { $0.toMilliseconds() },
      "active": isActive,
    ]
  }
}

extension Qonversion.Offerings {
  func toMap() -> BridgeData {
    return [
      "main": main?.toMap(),
      "availableOfferings": availableOfferings.map { $0.toMap() }
    ]
  }
}

extension Qonversion.Offering {
  func toMap() -> BridgeData {
    return [
      "id": identifier,
      "tag": tag.rawValue,
      "products": products.map { $0.toMap() }
    ]
  }
}

extension Qonversion.IntroEligibility {
  func toMap() -> BridgeData {
    return ["status": status.rawValue]
  }
}

extension Qonversion.Property {
  static func fromString(_ string: String) -> Self? {
    switch string {
    case "Email":
      return .email

    case "Name":
      return .name

    case "AppsFlyerUserId":
      return .appsFlyerUserID

    case "AdjustAdId":
      return .adjustUserID
      
    case "KochavaDeviceId":
      return .kochavaDeviceID
      
    case "CustomUserId":
      return .userID
      
    case "AdvertisingId":
      return .advertisingID
      
    default:
      return nil
    }
  }
}

extension Qonversion.AttributionProvider {
  static func fromString(_ string: String) -> Self? {
    switch string {
    case "AppsFlyer":
      return .appsFlyer
    case "Branch":
      return .branch
    case "Adjust":
      return .adjust
    case "AppleSearchAds":
      return .appleSearchAds
    case "AppleAdServices":
      return .appleAdServices
    default:
      return nil
    }
  }
}

extension Qonversion.ActionResultType {
  func toString() -> String {
    switch self {
    case .URL: return "url"
    case .deeplink: return "deeplink"
    case .navigation: return "navigate"
    case .purchase: return "purchase"
    case .restore: return "restore"
    case .close: return "close"
    default: return "unknown"
    }
  }
}

extension Qonversion.ActionResult {
  func toMap() -> BridgeData {
    let nsError = error as NSError?
    
    return ["type": type.toString(),
            "value": parameters,
            "error": nsError?.toMap()]
  }
}

extension Qonversion.AutomationsEventType {
  func toString() -> String {
    switch self {
    case .trialStarted: return "trial_started"
    case .trialConverted: return "trial_converted"
    case .trialCanceled: return "trial_canceled"
    case .trialBillingRetry: return "trial_billing_retry_entered"
    case .subscriptionStarted: return "subscription_started"
    case .subscriptionRenewed: return "subscription_renewed"
    case .subscriptionRefunded: return "subscription_refunded"
    case .subscriptionCanceled: return "subscription_canceled"
    case .subscriptionBillingRetry: return "subscription_billing_retry_entered"
    case .inAppPurchase: return "in_app_purchase"
    case .subscriptionUpgraded: return "subscription_upgraded"
    case .trialStillActive: return "trial_still_active"
    case .trialExpired: return "trial_expired"
    case .subscriptionExpired: return "subscription_expired"
    case .subscriptionDowngraded: return "subscription_downgraded"
    case .subscriptionProductChanged: return "subscription_product_changed"
    default: return "unknown"
    }
  }
}

extension QONAutomationsEvent {
  func toMap() -> BridgeData {
    return ["type": type.toString(),
            "timestamp": date.toMilliseconds()]
  }
}

extension SKProduct {
  func toMap() -> BridgeData {
    var map: BridgeData = [
      "localizedDescription": localizedDescription,
      "localizedTitle": localizedTitle,
      "productIdentifier": productIdentifier,
      "price": price.stringValue,
      "priceLocale": priceLocale.toMap(),
      "isDownloadable": isDownloadable,
      "downloadContentVersion": downloadContentVersion,
      "downloadContentLengths": downloadContentLengths
    ]
    
    if #available(iOS 11.2, macOS 10.13.2, *) {
      map["subscriptionPeriod"] = subscriptionPeriod?.toMap()
      map["introductoryPrice"] = introductoryPrice?.toMap()
    }
    
    if #available(iOS 12.2, macOS 10.14.4, *) {
      map["discounts"] = discounts.map { $0.toMap() }
    }

    if #available(iOS 12.0, macOS 10.14, *) {
      map["subscriptionGroupIdentifier"] = subscriptionGroupIdentifier
    }
      
    if #available(iOS 14.0, macOS 11.0, *) {
      map["isFamilyShareable"] = isFamilyShareable;
    }
    
    return map
  }
}

extension Locale {
  func toMap() -> BridgeData {
    return [
      "currencySymbol": currencySymbol,
      "currencyCode": currencyCode,
      "localeIdentifier": identifier
    ]
  }
}

@available(iOS 11.2, macOS 10.13.2, *)
extension SKProductSubscriptionPeriod {
  func toMap() -> BridgeData {
    return [
      "numberOfUnits": numberOfUnits,
      "unit": unit.rawValue
    ]
  }
}

@available(iOS 11.2, macOS 10.13.2, *)
extension SKProductDiscount {
  func toMap() -> BridgeData {
    var map: BridgeData = [
      "price": price.stringValue,
      "numberOfPeriods": numberOfPeriods,
      "subscriptionPeriod": subscriptionPeriod.toMap(),
      "paymentMode": paymentMode.rawValue,
      "priceLocale": priceLocale.toMap()
    ]
      
    if #available(iOS 12.2, macOS 10.14.4, *) {
      map["type"] = type
      map["identifier"] = identifier
    }
    
    return map
  }
}

extension Qonversion.ExperimentInfo {
  func toMap() -> BridgeData {
    return [
      "id": identifier,
      "group": [
        "type": group?.type
      ]
    ]
  }
}

extension Date {
    func toMilliseconds() -> Double {
      return timeIntervalSince1970 * 1000
    }
}

extension String {
  func toData() -> Data {
    let len = count / 2
    var data = Data(capacity: len)
    var i = startIndex
    for _ in 0..<len {
      let j = index(i, offsetBy: 2)
      let bytes = self[i..<j]
      if var num = UInt8(bytes, radix: 16) {
        data.append(&num, count: 1)
      }
      i = j
    }
    
    return data
  }
}
