import Foundation

struct NetworkManager {
    
    static let shared = NetworkManager()
 
    private init() {}
    
    // MARK: - Private methods
    private func createURL(
        for endPoint: Endpoint,
        with query: String? = nil
    ) -> URL? {

        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = endPoint.path

        components.queryItems = makeParameters(for: endPoint, with: query).compactMap {
                
            URLQueryItem(name: $0.key, value: $0.value)
        }
        return components.url
    }
   
    private func makeParameters(for endpoint: Endpoint, with query: String?) -> [String:String] {
        
        var parameters = [String:String]()
        
        parameters["apiKey"] = API.apiKey
        parameters["language"] = "en"
        parameters["pageSize"] = "20"
        
        
        switch endpoint {
        case .doSearch(request: let request):
            parameters["q"] = request
        case .topHeadlines(category: let category):
            parameters["category"] = category
        }
        return parameters
        
    }
    
    /// Выполняет сетевой запрос и обрабатывает полученные данные.
       /// - Parameters:
       ///   - url: URL запроса.
       ///   - apiKey: Ключ API для аутентификации запроса.
       ///   - session: Сессия URLSession, используемая для выполнения запроса.
       ///   - completion: Блок обратного вызова, который выполняется с результатом запроса.
    private func makeRequest<T: Codable>(
        for url: URL,
        apiKey: String,
        using session: URLSession = .shared,
        completion: @escaping(Result<T, NetworkErrors>) -> Void
    ) {

        let request = URLRequest(url: url)
       print("URL: \(url.absoluteString)")
       
        session.dataTask(with: request) {data, response, error in
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unexpectedError))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                
                if let apiError = try? JSONDecoder().decode(ApiError.self, from: data) {
                     completion(.failure(.apiError(apiError)))
                 } else {
                     let defaultErrorMessage = "An error occurred"
                     completion(.failure(.serverError(statusCode: httpResponse.statusCode, message: defaultErrorMessage)))
                 }
                return
            }
        
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                let decodeData = try decoder.decode(T.self, from: data)
                completion(.success(decodeData))
                
            } catch {
                completion(.failure(.decodingError(error)))
            }
            return
        }.resume()
    }
    
    func fetchData(
        for request: String,
        completion: @escaping(Result<SearchResults, NetworkErrors>) -> Void
    ) {
        guard let url = createURL(for: .doSearch(request: request)) else { return }
        
        makeRequest(for: url, apiKey: API.apiKey, completion: completion)
    }
    
    func fetchTopHeadlines(
        category: String,
        completion: @escaping(Result<SearchResults, NetworkErrors>) -> Void
    ) {
        guard let url = createURL(for: .topHeadlines(category: category)) else { return }
        
        makeRequest(for: url, apiKey: API.apiKey, completion: completion)
    }
    
    func fetchCategories(
        for categories: [String],
        completion: @escaping (String, Result<SearchResults, NetworkErrors>) -> Void) {
            
        categories.enumerated().forEach { index, category in
            
            let delay = Double(index) * 0.5 // Задержка в секундах для каждого запроса
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                
                guard let url = self.createURL(for: .doSearch(request: category)) else { return }
                
                self.makeRequest(for: url, apiKey: API.apiKey) { result in
                    completion(category, result)
                }
            }
        }
    }
    
}
