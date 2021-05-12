//
//  Extensions.swift
//  EmojiDictionary
//
//  Created by Степан Никитин on 05.03.2021.
//

import Foundation

extension Character {
    
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    var isCombinedIntoEmoji: Bool {
        unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
    }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
    
}


extension String {
    var isSingleEmoji: Bool {
        return count == 1 && containsEmoji
    }
    
    var containsEmoji: Bool {
        return contains { $0.isEmoji }
    }
    
    var containsOnlyEmoji: Bool {
        return !isEmpty && !contains { !$0.isEmoji }
    }
    
    var emojiString: String {
        return emojis.map { String($0) }.reduce("", +)
    }
    
    var emojis: [Character] {
        return filter { $0.isEmoji }
    }
    
    var emojiScalars: [UnicodeScalar] {
        return filter { $0.isEmoji }.flatMap { $0.unicodeScalars }
    }
}
