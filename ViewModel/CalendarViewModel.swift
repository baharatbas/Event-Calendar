//
//  CalendarViewModel.swift
//  Activity
//
//  Created by Bahar Atbaş on 28.04.2025.
//
import Foundation
import SwiftUI
import CoreData


class CalendarViewModel : ObservableObject{
    
    @Published var currentDate = Date() //güncel tarihi alırız burada
    @Published var events: [AppEvent] = [] //Appevent 'den tanımladığımız değerleri almak için events değişkenini oluştururuz bunuda publish yaparız ki başka dosyalarımıza enetegre edebilmek için
    @Published var users :[users] = []
    @Published  var selectedDate = Date() // seçilen tarih bugünün tarihi
    @Published  var selectedDay: Int? = nil // seçilen gün
    @Published  var hoverDay: Int? = nil //
    
    //CoreData işlemleri  veri tabanında bir veriyi eklemek , silmek ,güncellemek istiyorsan bu contex üzerinden yaparsın
    var contex : NSManagedObjectContext!
    //yeni etkinlik eklemek.
    func addEvent(id: UUID, title: String, date: Date, catagory: String, context: NSManagedObjectContext) {
        let newEvent = Event(context: context) //yeni bir event oluşturu
        newEvent.id = id
        newEvent.title = title
        newEvent.date = date
        newEvent.catagory = catagory.isEmpty ? nil : catagory
        
        do {
            try context.save() // veri tabanına kaydeder.
            print("✅ Etkinlik başarıyla kaydedildi: \(title), Tarih: \(date), Kategori: \(catagory)")
        } catch {
            print("❌ Etkinlik kaydedilirken hata oluştu: \(error.localizedDescription)")
        }
    }
    
    var contexUser : NSManagedObjectContext!
    func addUsers(id: UUID , name: String , username: String ,password: String , confirmPassword: String , contexUser: NSManagedObjectContext){
        let newUsers = UsersEntity(context: contexUser)
        newUsers.id = id
        newUsers.name = name
        newUsers.username = username
        newUsers.password = password
        newUsers.confirmPassword = confirmPassword
        
        do{
            try contexUser.save()
            print("kişi kaydedildi :Adı \(name) , Soyadı \(username)")
        }catch{
            print("kişi kaydedilemedi :\(error.localizedDescription)")
        }
        
        
    }

    
    private let calendar = Calendar.current
    //tüm aylatı localized ediliyor.
    private let aylar = [
        NSLocalizedString("Ocak", comment: "") ,
        NSLocalizedString("Şubat", comment: "") ,
        NSLocalizedString("Mart", comment: "") ,
        NSLocalizedString("Nisan", comment: "") ,
        NSLocalizedString("Mayıs", comment: "") ,
        NSLocalizedString("Haziran", comment: "") ,
        NSLocalizedString("Temmuz", comment: "") ,
        NSLocalizedString("Ağustos", comment: "") ,
        NSLocalizedString("Eylül", comment: "") ,
        NSLocalizedString("Ekim", comment: "") ,
        NSLocalizedString("Kasım", comment: "") ,
        NSLocalizedString("Aralık", comment: "") ,
    ]
   
    //tasarımdaki geri buttonuna basıldığında "<"
     func oncekiAy() {
        selectedDate = calendar.date(byAdding: .month, value: -1 ,to: selectedDate) ?? selectedDate
    }
    
     func sonrakiAy(){
        selectedDate = calendar.date(byAdding: .month, value: +1, to: selectedDate) ?? selectedDate
        
    }
    
    //selectedDate da yani seçili olan tarihten .month değişkenini alır yani ayı component de selecktedData dan belili bir parça çekildiği için kullanılır.
    //aylar dizi olarak tutulduğu için 0 dan başlamaası için aylardan 1 çıkartırız 0-> ocak , 1-> şubat vs...
     func ayAdiniGetir() -> String{
        let ay = calendar.component(.month, from: selectedDate)
        return aylar[ay-1]
        
    }
    
    //selectedDate den yine belirli bir yıl parçası alındığı için component olarak alınır.
     func yılGetir() -> String{
        return String(calendar.component(.year, from: selectedDate))
        
    }
     func ayinGunleri() -> [Int] {
        guard let ayinIlkGünü = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate)),
              let ayinSonGunu = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: ayinIlkGünü)
        else { return [] }

        //ayın ilk hafta gününü bulur pazartesi ->1 salı->2 ...
        let ayınİlkHaftaGünü = calendar.component(.weekday, from: ayinIlkGünü)
        let toplamGünSayısı = calendar.component(.day, from: ayinSonGunu)
        let boslukSayisi = (ayınİlkHaftaGünü + 5) % 7
        var gunler = Array(repeating: 0, count: boslukSayisi)
        gunler.append(contentsOf: 1...toplamGünSayısı)
        return gunler
    }
    
    //bugünün güncel tarihleri ve seçilen tarihler ile aynı olup olmadığı kontrol edilir
     func gunuKontrolEt(_ gün: Int) -> Bool {
        let bugün = calendar.component(.day, from: Date())
        let secilenAy = calendar.component(.month, from: selectedDate)
        let seciliYıl = calendar.component(.year, from: selectedDate)
        let bugununAy = calendar.component(.month, from: Date())
        let bugununYıl = calendar.component(.year, from: Date())
        return bugün == gün && secilenAy == bugununAy && seciliYıl == bugununYıl
    }
    
    //şeçilen tarihte etkinlik olup olmadığını kontrol eder.
     func hasEventOnDay(_ gün:Int) -> Bool{
        let targetDate = calendar.date(from: DateComponents(
            year: calendar.component(.year, from: selectedDate),
            month: calendar.component(.month, from: selectedDate),
            day : gün
        ))
         return !eventsForDate(targetDate ?? selectedDate).isEmpty
        
    }
    func eventsForDate(_ date: Date) -> [AppEvent] {
        let calendar = Calendar.current
        return events.filter {
            calendar.isDate($0.date, inSameDayAs: date)
        }
    }
    
}
