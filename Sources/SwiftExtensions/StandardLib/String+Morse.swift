//
//  File.swift
//  
//
//  Created by Jo on 2023/6/1.
//

import Foundation

///
///
/// 将字符串转换为莫斯电码
/// https://zh.wikipedia.org/zh-hans/%E6%91%A9%E5%B0%94%E6%96%AF%E7%94%B5%E7%A0%81
///
public extension String {
    func encodeToMorseCode(short: Character = "·", long: Character = "-", seperator: String = "/") -> String {
        return uppercased().compactMap {
            MorseCodes.shared.morse(of: $0)?.toString(short: short, long: long)
        }.joined(separator: seperator)
    }
    
    func decodeFromMorseCode(short: Character = "·", long: Character = "-", sepeartor: String = "/") -> String {
        return String(components(separatedBy: sepeartor).compactMap({
            MorseCodes.shared.morse(of: $0, short: short, long: long)
        }))
    }
}

private extension String {
    struct MorseCode {
        /// 将莫斯密码中的长短码转换为01后存起来
        var parts: [Int]
        /// 字符编码
        var code: Int
        /// 对应的字符
        var character: Character
        
        init(code: Int, character: Character) {
            self.code = code
            self.character = character
            var parts: [Int] = []
            var code = code
            
            while code > 1 {
                parts.insert(code % 2, at: 0)
                code = code / 2
            }
            
            self.parts = parts
        }
        
        func toString(short: Character, long: Character) -> String {
            return String(parts.map({ $0 == 1 ? long : short }))
        }
    }
    
    struct MorseCodes {
        static var shared = MorseCodes()
        
        private(set) var numberToChar: [Int: MorseCode] = [:]
        private(set) var charToMorse: [Character: MorseCode] = [
            "A":  MorseCode(code: 0b101,        character: "A"),
            "B":  MorseCode(code: 0b11000,      character: "B"),
            "C":  MorseCode(code: 0b11010,      character: "C"),
            "D":  MorseCode(code: 0b1100,       character: "D"),
            "E":  MorseCode(code: 0b10,         character: "E"),
            "F":  MorseCode(code: 0b10010,      character: "F"),
            "G":  MorseCode(code: 0b1110,       character: "G"),
            "H":  MorseCode(code: 0b10000,      character: "H"),
            "I":  MorseCode(code: 0b100,        character: "I"),
            "J":  MorseCode(code: 0b10111,      character: "J"),
            "K":  MorseCode(code: 0b1101,       character: "K"),
            "L":  MorseCode(code: 0b10100,      character: "L"),
            "M":  MorseCode(code: 0b111,        character: "M"),
            "N":  MorseCode(code: 0b110,        character: "N"),
            "O":  MorseCode(code: 0b1111,       character: "O"),
            "P":  MorseCode(code: 0b10110,      character: "P"),
            "Q":  MorseCode(code: 0b11101,      character: "Q"),
            "R":  MorseCode(code: 0b1010,       character: "R"),
            "S":  MorseCode(code: 0b1000,       character: "S"),
            "T":  MorseCode(code: 0b11,         character: "T"),
            "U":  MorseCode(code: 0b1001,       character: "U"),
            "V":  MorseCode(code: 0b10001,      character: "V"),
            "W":  MorseCode(code: 0b1011,       character: "W"),
            "X":  MorseCode(code: 0b11001,      character: "X"),
            "Y":  MorseCode(code: 0b11011,      character: "Y"),
            "Z":  MorseCode(code: 0b11100,      character: "Z"),
            "0":  MorseCode(code: 0b111111,     character: "0"),
            "1":  MorseCode(code: 0b101111,     character: "1"),
            "2":  MorseCode(code: 0b100111,     character: "2"),
            "3":  MorseCode(code: 0b100011,     character: "3"),
            "4":  MorseCode(code: 0b100001,     character: "4"),
            "5":  MorseCode(code: 0b100000,     character: "5"),
            "6":  MorseCode(code: 0b110000,     character: "6"),
            "7":  MorseCode(code: 0b111000,     character: "7"),
            "8":  MorseCode(code: 0b111100,     character: "8"),
            "9":  MorseCode(code: 0b111110,     character: "9"),
            ".":  MorseCode(code: 0b1010101,    character: "."),
            ":":  MorseCode(code: 0b1111000,    character: ":"),
            ",":  MorseCode(code: 0b1110011,    character: ","),
            ";":  MorseCode(code: 0b1101010,    character: ";"),
            "?":  MorseCode(code: 0b1001100,    character: "?"),
            "=":  MorseCode(code: 0b110001,     character: "="),
            "'":  MorseCode(code: 0b1011110,    character: "'"),
            "/":  MorseCode(code: 0b110010,     character: "/"),
            "!":  MorseCode(code: 0b1101011,    character: "!"),
            "-":  MorseCode(code: 0b1100001,    character: "-"),
            "_":  MorseCode(code: 0b1001101,    character: "_"),
            "\"": MorseCode(code: 0b1010010,    character: "\""),
            "(":  MorseCode(code: 0b110110,     character: "("),
            ")":  MorseCode(code: 0b1101101,    character: ")"),
            "$":  MorseCode(code: 0b10001001,   character: "$"),
            "&":  MorseCode(code: 0b101000,     character: "&"),
            "@":  MorseCode(code: 0b1011010,    character: "@"),
            "+":  MorseCode(code: 0b101010,     character: "+"),
        ]
        
        init() {
            for (_, mc) in charToMorse {
                numberToChar[mc.code] = mc
            }
        }
        
        func morse(of char: Character) -> MorseCode? {
            return charToMorse[char]
        }
        
        func morse(of codes: String, short: Character, long: Character) -> Character? {
            let sc = short
            let lc = long
            
            var result: Int = 0
            for (ind, char) in codes.reversed().enumerated() {
                if char == sc { continue }
                if char == lc {
                    result = result + Int(pow(2, Double(ind)))
                }
            }
            
            result += Int(pow(2, Double(codes.count)))
            return numberToChar[result]?.character
        }
    }
}
