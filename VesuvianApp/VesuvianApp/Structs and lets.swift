//
//  Structs and lets.swift
//  VesuvianApp
//
//  Created by Carlo Esposito on 14/06/24.
//

import Foundation
import SwiftSoup

let stations: [Station] = [
  Station(id: 1, name: "NAPOLI PORTA NOLANA"),
  Station(id: 3, name: "NAPOLI PIAZZA GARIBALDI"),
  Station(id: 4, name: "VIA GIANTURCO"),
  Station(id: 5, name: "SAN GIOVANNI A TEDUCCIO"),
  Station(id: 6, name: "BARRA"),
  Station(id: 26, name: "SANTA MARIA DEL POZZO"),
  Station(id: 27, name: "SAN GIORGIO A CREMANO"),
  Station(id: 28, name: "CAVALLI DI BRONZO"),
  Station(id: 29, name: "PORTICI BELLAVISTA"),
  Station(id: 30, name: "PORTICI VIA LIBERTÀ"),
  Station(id: 31, name: "ERCOLANO SCAVI"),
  Station(id: 32, name: "ERCOLANO MIGLIO D'ORO"),
  Station(id: 33, name: "TORRE DEL GRECO"),
  Station(id: 34, name: "VIA SANT'ANTONIO"),
  Station(id: 801, name: "MONTESANTO"),
  Station(id: 802, name: "CORSO V. EMANUELE"),
  Station(id: 803, name: "FUORIGROTTA"),
  Station(id: 804, name: "MOSTRA"),
  Station(id: 805, name: "EDENLANDIA"),
  Station(id: 806, name: "AGNANO"),
  Station(id: 808, name: "BAGNOLI"),
  Station(id: 107, name: "POZZUOLI"),
  Station(id: 814, name: "CANTIERI"),
  Station(id: 815, name: "ARCO FELICE"),
  Station(id: 816, name: "LUCRINO"),
  Station(id: 818, name: "FUSARO"),
  Station(id: 819, name: "TORREGAVETA"),
  Station(id: 820, name: "PIAVE"),
  Station(id: 821, name: "SOCCAVO"),
  Station(id: 822, name: "RIONE TRAIANO"),
  Station(id: 823, name: "LA TRENCIA"),
  Station(id: 824, name: "PIANURA"),
  Station(id: 825, name: "PISANI"),
  Station(id: 827, name: "QUARTO CENTRO"),
  Station(id: 109, name: "QUARTO"),
  Station(id: 828, name: "QUARTO OFFICINA"),
  Station(id: 829, name: "GROTTA DEL SOLE"),
  Station(id: 830, name: "LICOLA")
]


@Observable
final class Vesuviana{
    private init(){}
    
    static let shared = Vesuviana()
    
    func fetchTrains(_ partenze: Bool, _ posizioni: Int) async throws{
        let url = URL(string: "https://orariotreni.eavsrl.it/teleindicatori/ws_getData.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let postData = "tipoLista=\(partenze ? "P" : "A")&codLoc=\(posizioni)".data(using: .utf8)
        request.httpBody = postData
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        guard let str = String(data: responseData, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        let doc: Document = try SwiftSoup.parse(str)
        let trainRows = try doc.select("tr.testoGiallo")
        
        times = []
        
        for row in trainRows.array() {
            let treno = try row.select("td.numTreno").text()
            let cat = try row.select("td.categoria").text()
            let dest = try row.select("div.destinazione").text()
            let info = try row.select("td.informazioni marquee").text()
            let bin = try row.select("td.binario").text()
            let ora = try row.select("td.orario").text()
            let rit = try row.select("td.ritardo").text()
            
            let train = Train(treno: treno, cat: cat, dest: dest, info: info, bin: bin, ora: ora, rit: rit)
            times.append(train)
        }
    }


    var times: [Train] = []
}

struct Station{
    let id: Int
    let name: String
}

struct Train{
    let id = UUID()
    let treno: String
    let cat: String
    let dest: String
    let info: String?
    let bin: String?
    let ora: String
    let rit: String?
}


