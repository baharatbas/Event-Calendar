//
//  CalendarViewModel.swift
//  Activity
//
//  Created by Bahar Atbaş on 28.04.2025.
//
import Foundation
import SwiftUI


class CalendarViewModel : ObservableObject{
    @Published var events: [Event] = []
    @Published  var selectedDate = Date()
    @Published  var selectedDay: Int? = nil
    private let calendar = Calendar.current
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
   
     func oncekiAy() {
        selectedDate = calendar.date(byAdding: .month, value: -1 ,to: selectedDate) ?? selectedDate
    }
    
     func sonrakiAy(){
        selectedDate = calendar.date(byAdding: .month, value: +1, to: selectedDate) ?? selectedDate
        
    }
    
     func ayAdiniGetir() -> String{
        let ay = calendar.component(.month, from: selectedDate)
        return aylar[ay-1]
        
    }
    
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
     func gunuKontrolEt(_ gün: Int) -> Bool {
        let bugün = calendar.component(.day, from: Date())
        let secilenAy = calendar.component(.month, from: selectedDate)
        let seciliYıl = calendar.component(.year, from: selectedDate)
        let bugununAy = calendar.component(.month, from: Date())
        let bugununYıl = calendar.component(.year, from: Date())
        return bugün == gün && secilenAy == bugununAy && seciliYıl == bugununYıl
    }
     func hasEventOnDay(_ gün:Int) -> Bool{
        let targetDate = calendar.date(from: DateComponents(
            year: calendar.component(.year, from: selectedDate),
            month: calendar.component(.month, from: selectedDate),
            day : gün
        ))
         return !eventsForDate(targetDate ?? selectedDate).isEmpty
        
    }
    func eventsForDate(_ date: Date) -> [Event] {
        let calendar = Calendar.current
        return events.filter {
            calendar.isDate($0.date, inSameDayAs: date)
        }
    }
    //yeni etkinlik eklemek.
    func addEvent(id : UUID ,title : String , date : Date  , catagory : String){
        let newEvent = Event(id: id, title: title, date: date,  catagory: catagory)
        events.append(newEvent)

    }
    
}
