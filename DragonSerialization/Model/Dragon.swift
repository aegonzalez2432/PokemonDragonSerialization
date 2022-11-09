//
//  Dragon.swift
//  DragonSerialization
//
//  Created by Consultant on 11/8/22.
//

import Foundation

struct Dragon {
    let damageRelations: [DamageRelations]
    let gameIndeces: [GameIndex]
    let generation: NameLink
    let id: Int
    let moveDmgClass: NameLink
    let moves: [NameLink]
    let name: String
    let pokemons: [Pokemon]
    
}

struct DamageRelations {
    //let damageRelation: [NameLink]
    let doubleFrom: [NameLink]
    let doubleTo: [NameLink]
    let halfFrom: [NameLink]
    let halfTo: [NameLink]
    let noneFrom: [NameLink]
    let noneTo: [NameLink]
    
}
struct Pokemon {
    let pokemon: NameLink
    let slot: Int
}


struct GameIndex {
    let gameIndex: Int
    let generation: NameLink
}

struct NameLink {
    let name: String
    let link: String
}

