import SwiftUI
import CoreData
import EventCore
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
  
    
    @State private var showAddEvent = false
    @State private var eventTitle = ""
    @State private var eventDate = Date()
    @State private var eventCatagory = ""
    @State private var showAlert =  false
    @State private var alertTitle = ""
    
    @StateObject private var viewModel = CalendarViewModel()
    @AppStorage("isDarkMod") private var isDarkMod = false
    
    
    @FetchRequest(
           sortDescriptors: [NSSortDescriptor(keyPath: \Event.date, ascending: true)],
           animation: .default)
       private var events: FetchedResults<Event>
    
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
                                    .background(
                                        Group {
                                            if viewModel.gunuKontrolEt(gün) && viewModel.selectedDay != gün{
                                                Color.gray
                                            } else if viewModel.selectedDay == gün {
                                                    Color.blue
                                            }else if viewModel.hoverDay == gün {
                                                Color.blue.opacity(0.7)
                                            }else{
                                                Color.clear
                                            }
                            
                                        }
                                    )
                                    .clipShape(Circle())
                                    .foregroundColor((viewModel.selectedDay == gün) ? .white : .primary)
                                    .onTapGesture {
                                        viewModel.selectedDay = gün
                                    }
                                    .onHover { isHovered in
                                        viewModel.hoverDay = isHovered ? gün : nil
                                    }
                            }
                        }
                    }
                }
                
                Button(action: {showAddEvent = true  }){ // true dediğimiz için ekran açılır.
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
            
            //modal'ın içerisinde nelerin mevcut olacağını sheet ile belirleriz , oluştururuz.
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
                                if !eventTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    viewModel.addEvent(id: UUID(), title: eventTitle, date: eventDate, catagory: eventCatagory)
                                    eventTitle = ""
                                    eventCatagory = ""
                                    showAddEvent = false //modal kapanır
                                }else{
                                    alertTitle = "Etkinlik başlığı boş bırakılamaz"
                                    showAlert = true
                                }
                            }.alert(isPresented: $showAlert){
                                Alert(title: Text("Hata") , message: Text(alertTitle), dismissButton: .default(Text("Tamam")))
                            }
                            .foregroundColor(.white)
                            .padding()
                            .font(.title2)
                            .background(Color.blue)
                            .cornerRadius(5)
                            
                            Button("İptal"){
                                showAddEvent = false //modal kapanır
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
