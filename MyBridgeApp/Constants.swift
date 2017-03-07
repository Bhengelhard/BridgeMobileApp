//
//  Constants.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 12/16/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit

struct Constants {
	struct Colors {
		struct necter {
			static let yellow = UIColor(red: 237 / 255, green: 203 / 255, blue: 116 / 255, alpha: 1.0)
			static let gray = UIColor(red: 76 / 255, green: 76 / 255, blue: 77 / 255, alpha: 1.0)
            static let backgroundGray = UIColor(red: 218 / 255, green: 223 / 255, blue: 240 / 255, alpha: 1.0)
            static let textGray = UIColor(red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1.0)
		}

		struct bridgeType {
			/// Blue
			static let business = UIColor(red: 36 / 255, green: 123 / 255, blue: 160 / 255, alpha: 1.0)
			/// Red
			static let love = UIColor(red: 242 / 255, green: 95 / 255, blue: 92 / 255, alpha: 1.0)
			/// Green
			static let friendship = UIColor(red: 112 / 255, green: 193 / 255, blue: 179 / 255, alpha: 1.0)
		}
	}

	struct Sizes {
		static let screen: CGSize =  {
			return UIScreen.main.bounds.size
        }()
	}
    
    struct Fonts {
        /// BentonSansLight Size 14
        static let light14 = UIFont(name: "BentonSans-Light", size: 14)
        
        /// BentonSansLight Size 18
        static let light18 = UIFont(name: "BentonSans-Light", size: 18)
        
        /// BentonSansLight Size 24
        static let light24 = UIFont(name: "BentonSans-Light", size: 24)
        
        /// BentonSansBold Size 16
        static let bold16 = UIFont(name: "BentonSans-Bold", size: 16)
        
        /// BentonSansBold Size 24
        static let bold24 = UIFont(name: "BentonSans-Bold", size: 24)
    }
    
}
