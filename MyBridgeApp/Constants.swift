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
			static let yellow = UIColor(red: 241 / 255, green: 128 / 255, blue: 62 / 255, alpha: 1.0)
			static let gray = UIColor(red: 76 / 255, green: 76 / 255, blue: 77 / 255, alpha: 1.0)
            static let backgroundGray = UIColor(red: 240 / 255, green: 240 / 255, blue: 245 / 255, alpha: 1.0)
            static let textDarkGray = UIColor(red: 22 / 255, green: 22 / 255, blue: 22 / 255, alpha: 1.0)
            static let textGray = UIColor(red: 159 / 255, green: 159 / 255, blue: 158 / 255, alpha: 1.0)
            static let buttonGray = UIColor(red: 218 / 255, green: 223 / 255, blue: 240 / 255, alpha: 1.0)
            static let orange = UIColor(red: 249 / 255, green: 163 / 255, blue: 35 / 255, alpha: 1.0)
		}
        
        struct singleMessages {
            static let outgoing = UIColor(red: 55 / 255, green: 56 / 255, blue: 56 / 255, alpha: 1.0)
            static let incoming = UIColor(red: 216 / 255, green: 216 / 255, blue: 216 / 255, alpha: 1.0)
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
        /// Helvetica Neue Size 14
        static let light14 = UIFont(name: "Helvetica Neue", size: 14)
        
        /// Helvetica Neue Size 18
        static let light18 = UIFont(name: "Helvetica Neue", size: 18)
        
        /// Helvetica Neue Size 24
        static let light24 = UIFont(name: "Helvetica Neue", size: 24)
        
        /// Helvetica Neue Size 16
        static let bold16 = UIFont(name: "BentonSans-Bold", size: 16)
        
        /// BentonSansBold Size 24
        static let bold24 = UIFont(name: "BentonSans-Bold", size: 24)
        
        /// BentonSansBold Size 48
        static let bold48 = UIFont(name: "BentonSans-Bold", size: 48)
    }
    
    /// 5
    static let cardLimit = 5
}
