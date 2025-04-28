import SwiftUI
import EventCore
struct ContentView: View {
    @StateObject private var viewModel = CalendarViewModel()
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Button(action: {viewModel.oncekiAy()}) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .bold()
                    }
                    Spacer()
                    Text("\(viewModel.ayAdiniGetir()) \(viewModel.yılGetir())")
                    Spacer()
                    Button(action: {viewModel.sonrakiAy()}) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
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
                                                    .background(viewModel.gunuKontrolEt(gün) ? Color.blue : (viewModel.selectedDay == gün ? Color.gray.opacity(0.3) : Color.clear))
                                                    .clipShape(Circle())
                                                    .foregroundColor(viewModel.gunuKontrolEt(gün) ? .white : .primary)
                            }
                        }
                        
                    }
                    
                }
            }
            .navigationTitle(NSLocalizedString("Etkinlik Takvimi", comment: ""))
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
        }
    }
    
   
}

#Preview {
    ContentView()
}
