//
//  ContentViewModel.swift
//  AlefTest
//
//  Created by Дмитрий Константинов on 23.11.2021.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published public var kids: [Children] = []
    
    func removeAllKids() {
        self.kids.removeAll()
    }
    
    func removeChildren(_ children: Children) {
        let index = self.kids.firstIndex(of: children)
        self.kids.remove(at: index!)
    }
}
