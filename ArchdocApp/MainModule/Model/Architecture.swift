//
//  Architecture.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation

struct Architecture: Codable {
    var title: String
    var detail: String
    var imageName: String
    var bookmark: Bool = false
    
    static var architecture: [Architecture] = [
        Architecture(title: "Усадьба Альбрехтов",
                     detail: "Россия, Ленинградская область, Кингисеппский район,деревня Котлы",
                     imageName: "Albrekhtov"),
        Architecture(title: "Усадьба Куммолово",
                     detail: "Россия, Ленинградская область, Ломоносовский район,Копорское сельское поселение",
                     imageName: "Kummolovo"),
        Architecture(title: "Усадьба Красная Горка",
                     detail: "Россия, Псковская область, Дедовический район, деревня Красные Горки",
                     imageName: "KrasnayaGorka"),
        Architecture(title: "Усадьба Ванюковых",
                     detail: "Россия, Новгородская область, Солецкий район, Горское сельское поселение",
                     imageName: "Vanyukovikh"),
        Architecture(title: "Усадьба Волышово",
                     detail: "Россия, Псковская область, Порховский район, деревня Волышово",
                     imageName: "Volishovo"),
        Architecture(title: "Усадьба Вязье",
                     detail: "Россия, Псковская область, Дедовический район, деревня Вязье",
                     imageName: "Viazie")]
    
}
