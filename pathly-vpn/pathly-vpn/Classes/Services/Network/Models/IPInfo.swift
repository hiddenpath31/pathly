//
//  IPInfo.swift
//  pathly-vpn
//
//  Created by Александр on 11.11.2024.
//

import Foundation

struct Info: Codable {
    var ip: String?
    var postal: String?
    var country: String?
    var city: String?
    
    func toItems() -> [DataInfoDTO] {
        let ip = DataInfoDTO.init(item: .ip, dataString: self.ip ?? "-")
        let location = DataInfoDTO.init(item: .location, dataString: self.city ?? "-")
        let postal = DataInfoDTO.init(item: .postal, dataString: self.postal ?? "-")
        let country = DataInfoDTO.init(item: .country, dataString: self.country ?? "-")
        return [ip, location, postal, country]
    }
    
}
