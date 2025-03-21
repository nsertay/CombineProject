//
//  CombineViewModel.swift
//  CombineProject
//
//  Created by Nurmukhanbet Sertay on 21.03.2025.
//

import Combine

class UserViewModel: ObservableObject {
    @Published var username: String = "Нурмуханбет"
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        $username
            .sink { newValue in
                print("Имя изменилось: \(newValue)")
            }
            .store(in: &cancellables)
    }
}
