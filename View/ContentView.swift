import SwiftUI
import EventCore
struct ContentView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @AppStorage("isDarkMod") private var isDarkMod = false
    var body: some View {
        NavigationView {
            VStack{
                
                VStack{
                    Toggle(isOn: $isDarkMod){
                        Image(systemName: isDarkMod ? "moon.stars.fill" : "sun.max")
                            .foregroundColor(.primary)
                    }.toggleStyle(.switch)
                        .frame(width: 150,height: 50)
                    
                }.preferredColorScheme(isDarkMod ? .dark : .light)
                    .animation(.easeInOut , value: isDarkMod)
                
                
                HStack{
                    Button(action: {viewModel.oncekiAy()}) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.green)
                            .bold()
                    }
                    
                    Spacer()
                    Text("\(viewModel.ayAdiniGetir()) \(viewModel.yılGetir())")
                        .foregroundColor(.green)
                        .bold()
                    Spacer()
                    Button(action: {viewModel.sonrakiAy()}) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.green)
                            .bold()
                    }
                }.padding()
                
        HStack{
            ForEach(["Pzt" , "Sal" , "Çar" , "Perş" , "Cum" , "cmt" ,"pzr "] , id :\.self) { gün in
                Text(NSLocalizedString(gün, comment: ""))
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .foregroundColor(.gray)
            }
                }
        .padding(.horizontal)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(viewModel.ayinGunleri(), id: \.self) { gün in
                                        if gün > 0 {
                                            VStack {
                                                Text("\(gün)")
                                                    .padding(8)
                                                    .background(viewModel.gunuKontrolEt(gün) ? Color.green : (viewModel.selectedDay == gün ? Color.gray.opacity(0.3) : Color.clear))
                                                    .clipShape(Circle())
                                                    .foregroundColor(viewModel.gunuKontrolEt(gün) ? .white : .primary)
                            }
                        }
                        
                    }
                    
                }
            }
            .navigationTitle(NSLocalizedString("Etkinlik Takvimi", comment: ""))
                .frame(maxWidth: .infinity)
                
        }
        .padding()
    }
    
   
}

#Preview {
    ContentView()
}
