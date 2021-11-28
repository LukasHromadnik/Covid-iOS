//
//  Region.swift
//  Czechia
//
//  Created by Lukáš Hromadník on 09.03.2021.
//

import Foundation

extension Region {
    enum Variant: String, Codable {
        case praha
        case stredocesky
        case jihocesky
        case plzensky
        case karlovarsky
        case ustecky
        case liberecky
        case kralovehradecky
        case pardubicky
        case vysocina
        case jihomoravsky
        case olomoucky
        case zlinsky
        case moravskoslezsky

        var code: String {
            switch self {
            case .praha: return "CZ010"
            case .stredocesky: return "CZ020"
            case .jihocesky: return "CZ031"
            case .plzensky: return "CZ032"
            case .karlovarsky: return "CZ041"
            case .ustecky: return "CZ042"
            case .liberecky: return "CZ051"
            case .kralovehradecky: return "CZ052"
            case .pardubicky: return "CZ053"
            case .vysocina: return "CZ063"
            case .jihomoravsky: return "CZ064"
            case .olomoucky: return "CZ071"
            case .zlinsky: return "CZ072"
            case .moravskoslezsky: return "CZ080"
            }
        }
        
        var name: String {
            switch self {
            case .ustecky: return "Ústecký"
            case .plzensky: return "Plzeňský"
            case .jihomoravsky: return "Jihomoravský"
            case .zlinsky: return "Zlínský"
            case .olomoucky: return "Olomoucký"
            case .pardubicky: return "Pardubický"
            case .karlovarsky: return "Karlovarský"
            case .jihocesky: return "Jihočeský"
            case .vysocina: return "Vysočina"
            case .stredocesky: return "Středočeský"
            case .praha: return "Praha"
            case .liberecky: return "Liberecký"
            case .kralovehradecky: return "Královéhradecký"
            case .moravskoslezsky: return "Moravskoslezský"
            }
        }
    }
}
