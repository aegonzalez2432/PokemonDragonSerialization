//
//  NetworkManager.swift
//  DragonSerialization
//
//  Created by Consultant on 11/8/22.
//

import Foundation

final class NetworkManager{
    
    static let shared = NetworkManager()
    
    private init(){
        
    }
    
    
}
//MARK: Manual decoding
extension NetworkManager {
    func getPokemonManually() -> Dragon? {
        guard let path = Bundle.main.path(forResource: "ShootMeJSONDragon", ofType: "json") else { return nil }
        
        let url = URL(filePath: path)
        
        do {
            let data = try Data(contentsOf: url)
            
            let jsonObj = try JSONSerialization.jsonObject(with: data)
            guard let baseDict = jsonObj as? [String: Any] else { return nil }
            return self.parsePokemonManually(base: baseDict)
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parsePokemonManually(base: [String: Any]) -> Dragon? {
        
        var returnDmgRelation: [DamageRelations] = []
        var dblDmgFrom: [NameLink] = []
        var dblDmgTo: [NameLink] = []
        var hlfDmgFrom: [NameLink] = []
        var hlfDmgTo: [NameLink] = []
        var noDmgFrom: [NameLink] = []
        var noDmgTo: [NameLink] = []
        guard let dmgRelaArr = base["damage_relations"] as? [String: Any] else {
            print("Failed Damage Relations Array")
            return nil
        }
        guard let doubleDmgFrm = dmgRelaArr["double_damage_from"] as? [[String: Any]] else {return nil}
        doubleDmgFrm.forEach{ elem in
            //guard let dmgArray =  as? [String: Any] else {return}
            guard let returnDblDmgFrm = self.parseNameLink(nameLink: elem) else {return}
            dblDmgFrom.append(returnDblDmgFrm)
        }
        guard let doubleDmgTo = dmgRelaArr["double_damage_from"] as? [[String: Any]] else {return nil}
        doubleDmgTo.forEach{elem in
            guard let returnDblDmgTo = self.parseNameLink(nameLink: elem) else {return}
            dblDmgTo.append(returnDblDmgTo)
        }
        guard let halfDmgFrm = dmgRelaArr["half_damage_from"] as? [[String: Any]] else {return nil}
        halfDmgFrm.forEach{elem in
            guard let returnHlfDmgFrm = self.parseNameLink(nameLink: elem) else {return}
            hlfDmgFrom.append(returnHlfDmgFrm)
        }
        guard let halfDmgTo = dmgRelaArr["half_damage_to"] as? [[String: Any]] else {return nil}
        halfDmgTo.forEach{elem in
            guard let returnHlfDmgTo = self.parseNameLink(nameLink: elem) else {return}
            hlfDmgTo.append(returnHlfDmgTo)
        }
        guard let noDamageFrom = dmgRelaArr["no_damage_from"] as? [[String: Any]] else {return nil}
        noDamageFrom.forEach{elem in
            guard let returnNoDmgFrom = self.parseNameLink(nameLink: elem) else {return}
            noDmgFrom.append(returnNoDmgFrom)
        }
        guard let noDamageTo = dmgRelaArr["no_damage_to"] as? [[String: Any]] else {return nil}
        noDamageTo.forEach{elem in
            guard let returnNoDmgTo = self.parseNameLink(nameLink: elem) else {return}
            noDmgTo.append(returnNoDmgTo)
        }
            let finalDmgRelation = DamageRelations(doubleFrom: dblDmgFrom, doubleTo: dblDmgTo, halfFrom: hlfDmgFrom, halfTo: hlfDmgTo, noneFrom: noDmgFrom, noneTo: noDmgTo)
            returnDmgRelation.append(finalDmgRelation)

            
            //gameIndeces
        guard let gameIndecesArr = base["game_indices"] as? [[String: Any]] else { return nil }
        var returnGameIndeces: [GameIndex] = []
        gameIndecesArr.forEach{
            guard let gameIndex = $0["game_index"] as? Int else {return}
            guard let gen = $0["generation"] as? [String: Any] else { return }
            guard let returnGen = self.parseNameLink(nameLink: gen) else { return }
            let gameIndx = GameIndex(gameIndex: gameIndex, generation: returnGen)
            returnGameIndeces.append(gameIndx)
        }
        
        //generation
        guard let genration = base["generation"] as? [String: Any] else {return nil}
        guard let genRation = self.parseNameLink(nameLink: genration) else {return nil}
        
        //id
        guard let identity = base["id"] as? Int else {return nil}
        
        //moveDamageClass
        guard let mvDmgClass = base["move_damage_class"] as? [String: Any] else {return nil}
        guard let mvDmgReturn = self.parseNameLink(nameLink: mvDmgClass) else {return nil}

        //moves
        var returnMoves: [NameLink] = []
        guard let movesArr = base["moves"] as? [[String: Any]] else {
            print("Caught in moves")
            return nil}
        movesArr.forEach{elem in
            guard let movesRet = self.parseNameLink(nameLink: elem) else { return }
            returnMoves.append(movesRet)
            
        }
        //name
        guard let nombre = base["name"] as? String else {return nil}
        
        //pokemon
        var returnPoke: [Pokemon] = []
        guard let pokeArr = base["pokemon"] as? [[String: Any]] else {return nil}
        pokeArr.forEach{
            guard let pokemons = $0["pokemon"] as? [String: Any] else { return }
            guard let pokeName = self.parseNameLink(nameLink: pokemons) else {return}
            guard let slot = $0["slot"] as? Int else {return}
            let pokeTotal = Pokemon(pokemon: pokeName, slot: slot)
            returnPoke.append(pokeTotal)
        }
        
        
        return Dragon(damageRelations: returnDmgRelation,
                      gameIndeces: returnGameIndeces,
                      generation: genRation,
                      id: identity,
                      moveDmgClass: mvDmgReturn,
                      moves: returnMoves,
                      name: nombre,
                      pokemons: returnPoke)
    }
    
    private func parseNameLink(nameLink: [String: Any]) -> NameLink? {
        guard let name = nameLink["name"] as? String else { return nil }
        guard let link = nameLink["url"] as? String else {return nil}
        return NameLink(name: name, link: link)
    }
    
}

    

