import UIKit

struct Constants
{
	struct Colors
	{
		struct necter
		{
			static let yellow = UIColor(red: 237 / 255, green: 203 / 255, blue: 116 / 255, alpha: 1.0)
			static let gray = UIColor(red: 76 / 255, green: 76 / 255, blue: 77 / 255, alpha: 1.0)
		}

		struct bridgeType
		{
			/// Blue
			static let business = UIColor(red: 36 / 255, green: 123 / 255, blue: 160 / 255, alpha: 1.0)
			/// Red
			static let love = UIColor(red: 242 / 255, green: 95 / 255, blue: 92 / 255, alpha: 1.0)
			/// Green
			static let friendship = UIColor(red: 112 / 255, green: 193 / 255, blue: 179 / 255, alpha: 1.0)
		}
	}

	struct Sizes
	{
		static var screen: CGSize
		{
			return UIScreen.main.bounds.size
		}
	}
}
