import SwiftUI
import CoreData


struct ContentView: View {
    //core data ve swiftuı entegrasyonunu yapar.
    @Environment(\.managedObjectContext) private var viewContext
    //calendarViewModel() deki fonksiyonları kullanmamız için referans alıyoruz.
    @StateObject private var viewModel = CalendarViewModel()
    
    //userDefaults(uygulamayı kapatsak bile küçük verileri saklar içerisinde) da isDarkMod diye değişken saklar
    @AppStorage("isDarkMod") private var isDarkMod = false
    @State private var showAddUsers = false
    @State private var userConfirmPasword = ""
    @State private var userSurname = ""
    @State private var userName = ""
    @State private var userPasword = ""
    @State private var showAddEvent = false //gösterilen etkinlik
    @State private var eventTitle = "" //etkinlik başlığı
    @State private var eventDate = Date() //etkinliğin tarihi
    @State private var eventCatagory = "" //etkinliğin katagorisi
    @State private var showAlert =  false //uyarı mesajı
    @State private var alertTitle = "" //uyarı mesajının başlığı
    
    
    
    
    
    @FetchRequest(
        entity: UsersEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \UsersEntity.name, ascending: true)],
        animation: .default)
    private var users: FetchedResults<UsersEntity>

    @FetchRequest(
        entity: Event.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Event.date, ascending: true)],
        animation: .default)
    private var events: FetchedResults<Event>

    
    
    
    
    
    /*
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UsersEntity.name, ascending: true)],
        animation: .default)
    private var users: FetchedResults<UsersEntity>
    
   
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Event.date, ascending: true)],
        animation: .default)
    private var events: FetchedResults<Event>*/
    
    var body: some View {
        NavigationView {
            VStack{
                VStack{
                   
                    //bir adet toogle ekliyoruz 2 seçenekli geçiş buttonu
                    Toggle(isOn: $isDarkMod){
                        //eğer isDarkMod true ise ıcon oxlarak gece ver false ise güneş iconu ver.
                        Image(systemName: isDarkMod ? "moon.stars.fill" : "sun.max")
                            .foregroundColor(.primary)
                    }.toggleStyle(.switch)
                        .frame(width: 150,height: 50)
                    
                }.preferredColorScheme(isDarkMod ? .dark : .light)// değişken true ise koyu ekran ile başlat false ise değişken açık ekranla başlat
                    .animation(.easeInOut , value: isDarkMod)
                
                
                
                //2 adet butona sahip yan yana bir şekilde ileri ve geri ıconlar bulunuyor. ortalarında ise ay ve yıl bulunuyor
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
                
                
                
                // günlerin isimlerini tek tek alır foreach ile teker teker gün e aktarır bu aldığı günleri localize ederek text e basar tek tek localize edemezse "" basar id :\.self -> işlemi hepsinin kendine ait bir benzersiz kimliği olması içindir.
                HStack{
                    ForEach(["Pzt" , "Sal" , "Çar" , "Perş" , "Cum" , "cmt" ,"pzr "] , id :\.self) { gün in
                        Text(NSLocalizedString(gün, comment: ""))
                            .frame(maxWidth: .infinity)
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                
                
                /*  
                
                
                */
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
                
                //etkinliği main de göstermek için list yapıyoruz
                List{
                    if events.isEmpty{
                        Text("Etkinlik Bulunamadı")
                            .foregroundColor(.gray)
                    } else{
                            ForEach(events) { event in
                                VStack(alignment: .leading){
                                    Text(event.title ?? "Başlıksız")
                                        .font(.headline)
                                    
                                    Text(event.date ?? Date() , style: .date)
                                        .font(.subheadline)
                                    if let category = event.catagory , !category.isEmpty{
                                        Text(category)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                }
                                
                            }
                        }.onDelete(perform: deleteEvents)
                     
                    }
                    
                }
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
                                viewModel.addEvent(id: UUID(), title: eventTitle, date: eventDate, catagory: eventCatagory, context: viewContext)
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
        Button(action: {showAddUsers = true}){
            Image(systemName: "person.fill")
                .foregroundColor(.blue)
                
        }
        .sheet(isPresented:$showAddUsers){
            Text("Kullanıcı Kayıt Formu")
                .font(.title)
                .foregroundColor(.orange)
                .padding()
            VStack{
                HStack{
                    Text("Kullanıcı Adı :")
                        .font(.callout)
                    TextField("Kullanıcı Adı", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                HStack{
                    Text("Şifre :")
                        .font(.callout)
                    SecureField("Şifre", text: $userPasword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                HStack{
                    Text("Şifre :")
                        .font(.callout)
                    SecureField("Şifre", text: $userConfirmPasword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
            }
            Button("Kayıt Ol"){
                guard userPasword == userConfirmPasword else{
                    alertTitle = "şifreler uyuşmuyor"
                    showAlert = true
                    return
                }
                viewModel.addUsers(
                    id: UUID(),
                    name: userName,
                    username: userName ,
                    password: userPasword,
                    confirmPassword: userConfirmPasword,
                    contexUser: viewContext)
                
                userName = ""
                   userPasword = ""
                   userConfirmPasword = ""
                   showAddUsers = false // sheet'i kapat
               }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Hata"), message: Text(alertTitle), dismissButton: .default(Text("Tamam")))
            }
                
            }
            .foregroundColor(.white)
            .padding()
            .font(.title2)
            .background(Color.blue)
            .cornerRadius(12)

            
        }
  
    
    private func selectedDate(gün: Int) -> Date {
            let components = Calendar.current.dateComponents([.year, .month], from: viewModel.currentDate)
            var dateComponents = DateComponents()
            dateComponents.year = components.year
            dateComponents.month = components.month
            dateComponents.day = gün
            return Calendar.current.date(from: dateComponents) ?? Date()
        }
    private func deleteEvents(offsets: IndexSet){
        withAnimation{
            offsets.map{ events[$0] }.forEach(viewContext.delete)
            do{
                try viewContext.save()
            }catch{
                print("etkinlik yok")
            }
        }
    }  }


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

