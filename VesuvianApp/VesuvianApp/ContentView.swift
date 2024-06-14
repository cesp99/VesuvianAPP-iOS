//
//  ContentView.swift
//  VesuvianApp
//
//  Created by Carlo Esposito on 14/06/24.
//

import SwiftUI


struct ContentView: View {
    
    @State var posizioni: Int = 1
    @State var partenze: Bool = false
    
    
    var body: some View {
        ScrollView{
            VStack {
                
                Text("Stazione")
                Picker(selection: $posizioni, label: Text("")) {
                    ForEach(stations, id: \.id){ i in
                        Text(i.name).tag(i.id)
                    }
                }
                
                HStack{
                    Button("Partenze"){
                        partenze = true
                        
                        print(partenze)
                        
                        Task{
                            do{
                                try await Vesuviana.shared.fetchTrains(partenze, posizioni)
                                
                            } catch{
                                print(error)
                            }
                        }
                    }.buttonStyle(.bordered).buttonBorderShape(.capsule)
                    
                    Button("Arrivi"){
                        partenze = false
                        
                        print(partenze)
                        
                        Task{
                            do{
                                try await Vesuviana.shared.fetchTrains(partenze, posizioni)
                                
                            } catch{
                                print(error)
                            }
                        }
                    }.buttonStyle(.bordered).buttonBorderShape(.capsule)
                }
                .onAppear{
                    Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
                        Task{
                            do{
                                try await Vesuviana.shared.fetchTrains(partenze, posizioni)
                                
                            } catch{
                                print(error)
                            }
                        }
                    }
                }
                
                Divider()
                
                ScrollView(.horizontal) {
                    LazyVGrid(columns: Array(repeating: .init(.fixed(93), spacing: 13), count: 7), spacing: 13) {
                            Text("TRENO")
                            Text("CAT")
                            Text("DEST")
                            Text("INFO")
                            Text("BIN")
                            Text("ORA")
                            Text("RIT")
                        
                        Divider()
                        Divider()
                        Divider()
                        Divider()
                        Divider()
                        Divider()
                        Divider()
                            
                        ForEach(Vesuviana.shared.times, id: \.id){ i in
                            Text(i.treno)
                            Text(i.cat)
                            Text(i.dest)
                            Text(i.info ?? "")
                            Text(i.bin ?? "")
                            Text(i.ora)
                            Text(i.rit ?? "")
                        }
                    }.font(.callout)
                }
                
            }
            .padding()
        }
    }
}

#Preview {
    ContentView().preferredColorScheme(.dark)
}


