import UIKit

enum BridgeType: String
{
	case all
	case business
	case love
	case friendship

	static let allValues = [all, business, love, friendship]
}

// MARK: - Colors

extension BridgeType
{
	var color: UIColor
	{
		switch self
		{
			case .all: return .black
			case .business: return Constants.Colors.bridgeType.business
			case .love: return Constants.Colors.bridgeType.love
			case .friendship: return Constants.Colors.bridgeType.friendship
		}
	}
}

fileprivate enum Parse: String
{
	case all = "All Types"
	case business = "Business"
	case love = "Love"
	case friendship = "Friendship"
}

extension BridgeType
{
	/// A string for sending to Parse for storage.
	var parseValue: String
	{
		switch self
		{
			case .all: return Parse.all.rawValue
			case .business: return Parse.business.rawValue
			case .love: return Parse.love.rawValue
			case .friendship: return Parse.friendship.rawValue
		}
	}

	/// A native BridgeType, using a string return from Parse storage.
	init (fromParseValue parseValue: String)
	{
		switch parseValue
		{
			case Parse.all.rawValue: self = .all
			case Parse.business.rawValue: self = .business
			case Parse.love.rawValue: self = .love 
			case Parse.friendship.rawValue: self = .friendship
			default: self = .all
		}
	}	
}
