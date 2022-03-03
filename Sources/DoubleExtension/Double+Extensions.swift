//
//  Double+Extensions.swift
//  mtx
//
//  Created by Jean Philippe on 23/11/2017.
//  Copyright © 2017 Cityway. All rights reserved.
//

import Foundation
import CoreLocation

extension String {
    func bundleLocale() -> String {
        NSLocalizedString(self, comment: "")
    }
}

public struct ValueDisplayable<T> {
    public let value: T
    public let unit: String?
}

public extension Double {
    func kilometersToLocalizedDistance(decimals: Int = 1) -> ValueDisplayable<String> {
        return (self * 1000).metersToLocalizedDistance(decimals: decimals)
    }
    
    func metersToLocalizedDistance(decimals: Int = 1) -> ValueDisplayable<String> {
        switch (self, Locale.current.usesMetricSystem) {
        case (let value, true) where value < 1000:
            return ValueDisplayable<String>(value: "\(value)",
                                            unit: NSLocalizedString("meters short", comment: ""))
        case (let value, true):
            var format = "%0.\(decimals)"
            format += decimals == 0 ? "d" : "f"
            return ValueDisplayable<String>(value: String(format: format, value.km()),
                                            unit: NSLocalizedString("kilometers short", comment: ""))
        case (_, false):
            return ValueDisplayable<String>(value: "\(self.rounded(toPlaces: decimals))",
                                            unit: NSLocalizedString("miles short", comment: ""))
        }
    }
    
    var minutesToLocalizedTime: ValueDisplayable<String> {
        (self * 60.0).secondsToLocalizedTime
    }
    
    var secondsToLocalizedTime: ValueDisplayable<String> {
        if self / 3600.0 > 1.0 {
            return ValueDisplayable<String>(value: self.readableTime(), unit: nil)
        } else {
            return ValueDisplayable<String>(value: "\(Int(self/60.0))",
                                            unit: NSLocalizedString("minutes short", comment: "minutes short"))
        }
    }
    
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// Convert 1000 meters to 1km
    func km(_ decimals: Int = 1) -> Double {
        return (self/1000).rounded(toPlaces: decimals)
    }
    
    /// Convert a Double into localized distance String
    func localizedDistance(addSpace: Bool = true, force: Bool = false) -> String? {
        let returnBlock: () -> String? = {
            if self > 999 {
                if addSpace {
                    return "\(self.km()) \(NSLocalizedString("kilometers short", comment: ""))"
                } else {
                    return "\(self.km())\(NSLocalizedString("kilometers short", comment: ""))"
                }
            } else {
                if addSpace {
                    return "\(Int(self.rounded(toPlaces: 0))) \(NSLocalizedString("meters short", comment: ""))"
                } else {
                    return "\(Int(self.rounded(toPlaces: 0)))\(NSLocalizedString("meters short", comment: ""))"
                }
            }
        }
        
        guard force == false else {
            return returnBlock()
        }
            
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            return nil
            
        case .authorizedAlways, .authorizedWhenInUse:
            return returnBlock()
            
        @unknown default:
            return nil
        }
    }
    
    func readablePrice(currency: String = "€") -> String {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency
        return formatter.string(from: self as NSNumber) ?? "n/a"
    }
    
    func readableTime() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: self) ?? ""
    }
    
}
