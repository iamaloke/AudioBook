//
//  AudioViewModel.swift
//  AudioBook
//
//  Created by Alok Kumar on 27/04/25.
//

import Combine
import SwiftUI

final class AudioViewModel: ObservableObject {
    
    @Published var audios: [Audio] = []
    @Published var asyncAudio: [Audio] = []
    @Published var callbackAudio: [Audio] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    func fetchAudio() {
        fetch()
            .sink { completion in
                switch completion {
                    case .finished: print("Data fetched succussfully!")
                    case .failure(let error): print("Error: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.audios = response.results
            }
            .store(in: &cancellables)
    }
    
    func fetch() -> AnyPublisher<AudioResponse, Error> {
        let decoder = JSONDecoder()
        guard let url = URL(string: "https://itunes.apple.com/search?term=Alex") else { return Fail(error: NSError(domain: "url not valid", code: 404)).eraseToAnyPublisher() }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .decode(type: AudioResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func fetchAudioAsync() async {
        do {
            let response: AudioResponse = try await fetch()
            asyncAudio = response.results
        } catch {
            print(error)
        }
    }
    
    func fetchAudioCallback() {
        fetch { [weak self] (result: Result<AudioResponse, Error>) in
            guard let self = self else { return }
            switch result {
                case .success(let data): self.callbackAudio = data.results
                case .failure(let failure): print(failure)
            }
        }
    }
    
    func fetch<T: Decodable>() async throws -> T {
        guard let url = URL(string: "https://itunes.apple.com/search?term=Alex") else {
            throw NSError(domain: "url not valid", code: 404)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Response is not valid", code: 500)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw error
        }
    }
    
    func fetch<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "https://itunes.apple.com/search?term=Alex") else {
            completion(.failure(NSError(domain: "urls is not valid", code: 404)))
            return
        }
        
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache.shared
        config.requestCachePolicy = .returnCacheDataElseLoad
        
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let httpResponse = response as? HTTPURLResponse, let data = data, (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NSError(domain: "Response is not valid", code: 500)))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
}
