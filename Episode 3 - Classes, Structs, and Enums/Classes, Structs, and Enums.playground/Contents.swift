
//This playground is built to demonstrate the concepts covered in Episode 3 of Fireside Swift: Classes, Structs, and Enums (oh my)

import Foundation

//The Rarity enum describes how rare a certain item is.  Raghav is of course the most legendary.
enum Rarity {
    
    case common
    case uncommon
    case rare
    case epic
    case raghav
    
}

//The SpecialTraits enum describes the special traits an item may have.
enum SpecialTraits {
    
    case ofFire
    case ofStorm
    case ofFrost
    case ofAcid
    
}

//The WeaponType enum describes the different types of weapons.
enum WeaponType {
    
    case sword
    case axe
    case bow
    case dagger
}

//The ArmorType enum describes the different types of armor.
enum ArmorType {
    
    case shirt
    case pants
    case gloves
    case helm
    case boots
    
}

//The Item class is the parent class of all item types - weapons, armor, jewelry.
class Item {
    
    var rarity: Rarity
    var specialTraits: [SpecialTraits]!
    var minLevel: Int
    
    var price: Int
    var durability: Double = 1.0
    
    init(rarity: Rarity, minLevel: Int, price: Int, specialTraits: [SpecialTraits]!) {
        self.rarity = rarity
        self.minLevel = minLevel
        self.price = price
        
        if let theTraits = specialTraits {
            self.specialTraits = theTraits
        }
    }
    
    func getDamaged() {
        
        durability -= 0.1
        
    }
    
    func fallApart() {
        
        durability = 0
    
    }
    
}

//The item subclasses.
class Weapon: Item {
    
    var damage: Int
    var weaponType: WeaponType
    var fireDmg: Int
    var coldDmg: Int
    var acidDmg: Int
    var elecDmg: Int
    
    init(rarity: Rarity, minLevel: Int, price: Int, damage: Int, weaponType: WeaponType, fireDmg: Int, coldDmg: Int, acidDmg: Int, elecDmg: Int, specialTraits: [SpecialTraits]!) {
        
        //Why do I need to have the subcass variables before the super.init call?
        self.damage = damage
        self.weaponType = weaponType
        self.fireDmg = fireDmg
        self.coldDmg = coldDmg
        self.acidDmg = acidDmg
        self.elecDmg = elecDmg
        
        super.init(rarity: rarity, minLevel: minLevel, price: price, specialTraits: specialTraits)

    }
    
    func toString() {
        print("\(self.rarity), \(self.minLevel), \(self.price), \(self.damage), \(self.weaponType), \(self.fireDmg), \(self.coldDmg), \(self.acidDmg), \(self.elecDmg)")
    }
    
}

class Armor: Item {
    
    var defense: Int
    var armorType: ArmorType
    var fireRes: Double
    var coldRes: Double
    var acidRes: Double
    var elecRes: Double
    
    init(rarity: Rarity, minLevel: Int, price: Int, defense: Int, armorType: ArmorType, fireRes: Double, coldRes: Double, acidRes: Double, elecRes: Double, specialTraits: [SpecialTraits]!) {
        
        self.defense = defense
        self.armorType = armorType
        self.fireRes = fireRes
        self.coldRes = coldRes
        self.acidRes = acidRes
        self.elecRes = elecRes
        
        super.init(rarity: rarity, minLevel: minLevel, price: price, specialTraits: specialTraits)
        
    }
    
    func toString() {
        print("\(self.rarity), \(self.minLevel), \(self.price), \(self.defense), \(self.armorType), \(self.fireRes), \(self.coldRes), \(self.acidRes), \(self.elecRes)")
    }
    
}

struct Merchant {
    
    var balance: Int
    var inventory: [Item] = []
    
    init(balance: Int, inventorySize: Int) {
        
        //Set the balance to the integer passed in.  This allows for the creation of merchants with different balances
        self.balance = balance
        
        //Generate the inventory based on the inventorySize passed in.  It should always be a multiple of 10.
        let finalSize = inventorySize * 10
        
        //I'm dealing with Ints, not a 0-indexed array.  Start at one and not zero to get the proper number of items in the inventory.
        for _ in 1...finalSize {
            
            self.inventory.append(dropLoot())
            
        }
        
    }
    
    //Need the mutating keyword to change the value of the item.
    mutating func repair(_ item: Item) {
        
        item.durability = 1.0
        
    }
    
    //Need the mutating keyword to change the value of the item.
    mutating func sell(item indexOfItem: Int) -> Item{
        
        balance += inventory[indexOfItem].price
        return inventory.remove(at: indexOfItem)
        
    }
    
    //Need the mutating keyword to change the value of the item.
    mutating func buy(_ item: Item) {
        
        if balance >= item.price {
            inventory.append(item)
            balance -= item.price
        } else {
            print("I don't have enough to buy that item!")
        }
        
    }
    
}

func dropLoot() -> Item {
    
    let rarity: Rarity
    let minLevel: Int = Int((arc4random() % 20) + 1)
    let price: Int
    let specialTraits: [SpecialTraits]!
    
    //Roll for rarity level
    let rarityLevel = arc4random() % 100
    
    if rarityLevel <= 60 {
        rarity = Rarity.common
        print("item with a rarity of \(rarity)")
    } else if rarityLevel > 60 && rarityLevel <= 80 {
        rarity = Rarity.uncommon
        print("item with a rarity of \(rarity)")
    } else if rarityLevel > 80 && rarityLevel <= 90 {
        rarity = Rarity.rare
        print("item with a rarity of \(rarity)")
    } else if rarityLevel > 90 && rarityLevel <= 98 {
        rarity = Rarity.epic
        print("item with a rarity of \(rarity)")
    } else {
        rarity = Rarity.raghav
        print("tem with a rarity of \(rarity)")
    }
    
    switch rarity {
    case .common:
        specialTraits = nil
        
        //Determine price off of rarity level.
        price = 5
    case .uncommon:
        //Roll for one special trait
        specialTraits = determineSpecialTraits(1)
        
        //Determine price off of rarity level.
        price = 10
        
        print("The uncommon special traits are \(specialTraits)")
    case .rare:
        //Roll for two special traits
        specialTraits = determineSpecialTraits(2)
        
        //Determine price off of rarity level.
        price = 20
        
        print("The rares special traits are \(specialTraits)")
    case .epic:
        //Roll for three special traits
        specialTraits = determineSpecialTraits(3)
        
        //Determine price off of rarity level.
        price = 40
        
        print("The epic special traits are \(specialTraits)")
    case .raghav:
        //You get EIGHT special traits....WHAT?!?!?!?!?
        specialTraits = determineSpecialTraits(8)
        
        //Determine price off of rarity level.
        price = 9000
        
        print("He *does* exist!  The Raghav special traits are \(specialTraits)")
    }
    
    let coinFlip = arc4random() % 2
    
    if coinFlip == 0 {
        print("Generating a weapon")
        return generateWeapon(rarity: rarity, minLevel: minLevel, price: price, specialTraits: specialTraits)
    } else {
        print("Generating a peice of armor")
        return generateArmor(rarity: rarity, minLvl: minLevel, price: price, specialTraits: specialTraits)
    }
    
}

func determineSpecialTraits(_ traitCount: Int) -> [SpecialTraits] {
    
    var traits: [SpecialTraits] = []
    print("Determinging the special traits with a count of \(traitCount)")
    for _ in 0...traitCount {
        let theTrait = arc4random() % 4
        
        if theTrait == 0 {
            traits.append(SpecialTraits.ofFire)
        } else if theTrait == 1 {
            traits.append(SpecialTraits.ofStorm)
        } else if theTrait == 2 {
            traits.append(SpecialTraits.ofFrost)
        } else if theTrait == 3 {
            traits.append(SpecialTraits.ofAcid)
        }
    }
    
    return traits
}

func generateWeapon(rarity: Rarity, minLevel: Int, price: Int, specialTraits: [SpecialTraits]!) -> Weapon {
    
    //Determine base damage
    let baseDmg = Int(minLevel / 2)
    var fireDmg = 0
    var elecDmg = 0
    var coldDmg = 0
    var acidDmg = 0
    
    //Unwrap the special traits if they exist.
    if let theTraits = specialTraits {
        for trait in theTraits {
            
            switch trait {
            case .ofFire:
                fireDmg += 1
            case .ofStorm:
                elecDmg += 1
            case .ofFrost:
                coldDmg += 1
            case .ofAcid:
                acidDmg += 1
            }
        }
    }
    
    //Determine type of weapon
    let weaponChoice = arc4random() % 4
    
    if weaponChoice == 0 {
        return Weapon(rarity: rarity, minLevel: minLevel, price: price, damage: baseDmg, weaponType: .sword, fireDmg: fireDmg, coldDmg: coldDmg, acidDmg: acidDmg, elecDmg: elecDmg, specialTraits: specialTraits)
    } else if weaponChoice == 1 {
        return Weapon(rarity: rarity, minLevel: minLevel, price: price, damage: baseDmg, weaponType: .axe, fireDmg: fireDmg, coldDmg: coldDmg, acidDmg: acidDmg, elecDmg: elecDmg, specialTraits: specialTraits)
    } else if weaponChoice == 2 {
        return Weapon(rarity: rarity, minLevel: minLevel, price: price, damage: baseDmg, weaponType: .bow, fireDmg: fireDmg, coldDmg: coldDmg, acidDmg: acidDmg, elecDmg: elecDmg, specialTraits: specialTraits)
    } else {
        return Weapon(rarity: rarity, minLevel: minLevel, price: price, damage: baseDmg, weaponType: .dagger, fireDmg: fireDmg, coldDmg: coldDmg, acidDmg: acidDmg, elecDmg: elecDmg, specialTraits: specialTraits)
    }
    
}

func generateArmor(rarity: Rarity, minLvl: Int, price: Int, specialTraits: [SpecialTraits]!) -> Armor {
    
    var fireRes = 1.0
    var elecRes = 1.0
    var coldRes = 1.0
    var acidRes = 1.0
    
    //Unwrap the special traits if they exist.
    if let theTraits = specialTraits {
        for trait in theTraits {
            
            switch trait {
            case .ofFire:
                fireRes *= 2.0
            case .ofStorm:
                elecRes *= 2.0
            case .ofFrost:
                coldRes *= 2.0
            case .ofAcid:
                acidRes *= 2.0
            }
        }
    }
    
    let armorChoice = arc4random() % 5
    
    if armorChoice == 0 {
        let defense = Int(Double(minLvl) * 2.5)
        return Armor(rarity: rarity, minLevel: minLvl, price: price, defense: defense, armorType: .shirt, fireRes: fireRes, coldRes: coldRes, acidRes: acidRes, elecRes: elecRes, specialTraits: specialTraits)
    } else if armorChoice == 1 {
        let defense = Int(Double(minLvl) * 2.5)
        return Armor(rarity: rarity, minLevel: minLvl, price: price, defense: defense, armorType: .pants, fireRes: fireRes, coldRes: coldRes, acidRes: acidRes, elecRes: elecRes, specialTraits: specialTraits)
    } else if armorChoice == 2 {
        let defense = Int(Double(minLvl) * 2.5)
        return Armor(rarity: rarity, minLevel: minLvl, price: price, defense: defense, armorType: .gloves, fireRes: fireRes, coldRes: coldRes, acidRes: acidRes, elecRes: elecRes, specialTraits: specialTraits)
    } else if armorChoice == 3 {
        let defense = Int(Double(minLvl) * 2.5)
        return Armor(rarity: rarity, minLevel: minLvl, price: price, defense: defense, armorType: .boots, fireRes: fireRes, coldRes: coldRes, acidRes: acidRes, elecRes: elecRes, specialTraits: specialTraits)
    } else {
        let defense = Int(Double(minLvl) * 2.5)
        return Armor(rarity: rarity, minLevel: minLvl, price: price, defense: defense, armorType: .helm, fireRes: fireRes, coldRes: coldRes, acidRes: acidRes, elecRes: elecRes,specialTraits: specialTraits)
    }
    
}

var inventory: [Item] = []

for index in 0...10 {
    
    inventory.append(dropLoot())
    
}


print("Time for the merchants!")
var minorMerchant = Merchant(balance: 1000, inventorySize: 1)
var mediumMerchant = Merchant(balance: 2000, inventorySize: 2)
var majorMerchant = Merchant(balance: 3000, inventorySize: 3)
//Lol don't generate this, unless you want a large loop.
//var raghavTheMerchant = Merchant(balance: 5500, inventorySize: 20)

/*
minorMerchant.buy(inventory[1])
mediumMerchant.buy(inventory[1])
majorMerchant.buy(inventory[1])
*/

//The minorMerchant is bought out by the mediumMerchant
for item in minorMerchant.inventory {
    
    mediumMerchant.buy(item)
    
}

for item in mediumMerchant.inventory {
    
    if item is Weapon {
        let weapon = item as! Weapon
        print("Rarity: \(weapon.rarity), minLvl: \(weapon.minLevel), price: \(weapon.price), damage: \(weapon.damage), type: \(weapon.weaponType), fireDmg: \(weapon.fireDmg), "
            + "coldDmg: \(weapon.coldDmg), acidDmg: \(weapon.acidDmg), elecDmg: \(weapon.elecDmg)")
    } else {
        let armor = item as! Armor
        print("Rarity: \(armor.rarity), minLvl: \(armor.minLevel), price: \(armor.price), defense: \(armor.defense), type: \(armor.armorType), fireRes: \(armor.fireRes), "
            + "coldRes: \(armor.coldRes), acidRes: \(armor.acidRes), elecRes: \(armor.elecRes)")
    }
    
}

print("The medium merchant now has a balance of \(mediumMerchant.balance) and an inventory with \(mediumMerchant.inventory.count) items while the minor merchant has "
    + "\(minorMerchant.balance) and an inventory with \(minorMerchant.inventory.count) items.")
