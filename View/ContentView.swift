import SwiftUI
import EventCore
struct ContentView: View {
    @State private var showAddEvent = false
    @State private var eventTitle = ""
    @State private var eventDate = Date()
    @State private var eventCatagory = ""
    
    
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
                            .foregroundColor(.blue)
                            .bold()
                    }
                    
                    Spacer()
                    Text("\(viewModel.ayAdiniGetir()) \(viewModel.yılGetir())")
                        .foregroundColor(.blue)
                        .bold()
                    Spacer()
                    Button(action: {viewModel.sonrakiAy()}) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.blue)
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
                
                Button(action: {showAddEvent = true }){
                    Text("Etkinlik Ekle")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle(NSLocalizedString("Etkinlik Takvimi", comment: ""))
                .frame(maxWidth: .infinity)
                .sheet(isPresented: $showAddEvent){
                    VStack{
                        TextField("Etkinlik Başlığı" , text: $eventTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                            .padding()
                        
                        DatePicker("Tarih" ,selection: $eventDate , displayedComponents: [.date])
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                        
                        TextField("Katagori (isteğe Bağlı) " , text: $eventCatagory)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        HStack{
                            Button("Kaydet"){
                                viewModel.addEvent(id: UUID(), title: eventTitle, date: eventDate, catagory: eventCatagory)
                                eventTitle = ""
                                eventCatagory = ""
                                showAddEvent = false
                            }
                            .foregroundColor(.white)
                            .padding()
                            .font(.title2)
                            .background(Color.blue)
                            .cornerRadius(5)
                            
                            Button("İptal"){
                                showAddEvent = true
                            }
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(5)
                        }
                    }
                }
                
        }
        .padding()
    }
    
   
}

#Preview {
    ContentView()
}
