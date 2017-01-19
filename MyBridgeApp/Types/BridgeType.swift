import UIKit

enum BridgeType: String
{
	case all
	case business
	case love
	case friendship

	static let allValues = [all, business, love, friendship]

	var parseValue: String
	{
		switch self
		{
			case .all: return "All Types"
			case .business: return "Business"
			case .love: return "Love"
			case .friendship: return "Friendship"
		}
	}

	init (fromParseValue parseValue: String)
	{
		switch parseValue
		{
			case "All Types": self = .all
			case "Business": self = .business
			case "Love": self = .love 
			case "Friendship": self = .friendship
			default: self = .all
		}
	}

	var color: UIColor
	{
		switch self
		{
			case .all: return UIColor.black
			case .business: return Constants.Colors.bridgeType.business
			case .love: return Constants.Colors.bridgeType.love
			case .friendship: return Constants.Colors.bridgeType.friendship
		}
	}
}
