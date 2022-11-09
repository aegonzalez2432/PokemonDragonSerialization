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
            print(baseDict)
            return self.parsePokemonManually(base: baseDict)
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parsePokemonManually(base: [String: Any]) -> Dragon? {
        
        guard let dmgRelaArr = base["damage_relations"] as? [String: Any] else {
            print("Failed Damage Relations Array")
            return nil
        }
        //Dmg Relations
        var returnDmgRelation: [DamageRelations] = []
        var dblDmgFrom: [NameLink] = []
        var dblDmgTo: [NameLink] = []
        var hlfDmgFrom: [NameLink] = []
        var hlfDmgTo: [NameLink] = []
        var noDmgFrm: [NameLink] = []
        var noDmgTo: [NameLink] = []
        var counter: Int = 1
        //var dmgRelID: String = ""
        dmgRelaArr.forEach{
            switch counter {
            case 1:
                //dmgRelID = "double_damage_from"
                guard let dmgDict = $0["double_damage_from"] as? [String: Any] else {return}
                dmgDict.forEach {_ in
                    guard let dmgRep = self.parseNameLink(nameLink: dmgDict) else {return}
                    dblDmgFrom.append(dmgRep)
                }
                counter += 1
            case 2:
                //dmgRelID = "double_damage_to"
                guard let dmgDict = $0["double_damage_to"] as? [String: Any] else {return}
                dmgDict.forEach {_ in
                    guard let dmgRep = self.parseNameLink(nameLink: dmgDict) else {return}
                    dblDmgTo.append(dmgRep)
                }
                counter += 1
            case 3:
                //dmgRelID = "half_damage_from"
                guard let dmgDict = $0["half_damage_from"] as? [String: Any] else {return}
                dmgDict.forEach {_ in
                    guard let dmgRep = self.parseNameLink(nameLink: dmgDict) else {return}
                    hlfDmgFrom.append(dmgRep)
                }
                counter += 1
                
            case 4:
                //dmgRelID = "half_damage_to"
                guard let dmgDict = $0["half_damage_to"] as? [String: Any] else {return}
                dmgDict.forEach {_ in
                    guard let dmgRep = self.parseNameLink(nameLink: dmgDict) else {return}
                    hlfDmgTo.append(dmgRep)
                }
                counter += 1
                
            case 5:
                //dmgRelID = "no_damage_from"
                guard let dmgDict = $0["no_damage_from"] as? [String: Any] else {return}
                dmgDict.forEach {_ in
                    guard let dmgRep = self.parseNameLink(nameLink: dmgDict) else {return}
                    noDmgFrm.append(dmgRep)
                }
                counter += 1
                
            case 6:
                //dmgRelID = "no_damage_to"
                guard let dmgDict = $0["no_damage_to"] as? [String: Any] else {return}
                dmgDict.forEach {_ in
                    guard let dmgRep = self.parseNameLink(nameLink: dmgDict) else {return}
                    noDmgTo.append(dmgRep)
                }
                counter += 1
                
            default:
                return
            }
            //            guard let dmgDict = $0[dmgRelID] as? [String: Any] else {return}
            //            dmgDict.forEach{_ in
            //                guard let dmgFromRep = self.parseNameLink(nameLink: dmgDict) else { return }
            //                dmgRArr.append(dmgFromRep)
            //            }
            let finalDmgRelation = DamageRelations(doubleFrom: dblDmgFrom, doubleTo: dblDmgTo, halfFrom: hlfDmgFrom, halfTo: hlfDmgTo, noneFrom: noDmgFrm, noneTo: noDmgTo)
            returnDmgRelation.append(finalDmgRelation)
        }
//            let damageRelation = DamageRelations(doubleFrom: dmgFromRep, doubleTo: dmgToRep, halfFrom: halfFromRep, halfTo: halfToRep, noneFrom: noneFromRep, noneTo: noneToRep)
            
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
        guard let movesArr = base["moves"] as? [String: Any] else {return nil}
        movesArr.forEach{_ in
            guard let movesRet = self.parseNameLink(nameLink: movesArr) else { return }
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
        
        
        
        return Dragon(damageRelations: returnDmgRelation, gameIndeces: returnGameIndeces, generation: genRation, id: identity, moveDmgClass: mvDmgReturn, moves: returnMoves, name: nombre, pokemons: returnPoke)
    }
    
    private func parseNameLink(nameLink: [String: Any]) -> NameLink? {
        guard let name = nameLink["name"] as? String else { return nil }
        guard let link = nameLink["url"] as? String else {return nil}
        return NameLink(name: name, link: link)
    }
    
}

    

