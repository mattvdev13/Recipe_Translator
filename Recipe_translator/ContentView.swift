//
//  ContentView.swift
//  Recipe_translator
//
//  Created by Matthew Vine on 2/26/23.
//

import SwiftUI
import SwiftSoup
import EventKit

struct ContentView: View {
    @State private var targetsite: String = ""
    
    func Scanpage(URLI: String){
        guard let recipepage = URL(string: URLI) else {
            print("Invalid URL")
            exit(1)
        }
        
        do {
            let html = try String(contentsOf: url)
            let doc = try SwiftSoup.parse(html)
            
            let ingredientTags = try doc.select("ul.ingredients li")
            let ingredients = ingredientTags.map { try $0.text() }
            
            let eventStore = EKEventStore()
            eventStore.requestAccess(to: .reminder) { granted, error in
                guard granted, error == nil else {
                    print("Failed to access reminders")
                    exit(1)
                }
                
                for ingredient in ingredients {
                    let reminder = EKReminder(eventStore: eventStore)
                    reminder.title = ingredient
                    reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                    reminder.calendar = eventStore.defaultCalendarForNewReminders()
                    do {
                        try eventStore.save(reminder, commit: true)
                    } catch {
                        print("Failed to save reminder: \(error)")
                    }
                }
            }
        } catch {
            print("Failed to load webpage: \(error)")
            exit(1)
        }
        //parse webpage
        
        
        //add each to reminders as a single bullet point
        
        
        
        return
    }

    var body: some View {
        
        VStack {
           
            Text("Input Website URL Below")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            TextField("URL to translate", text: $targetsite)

            Button("Submit text", action: {Scanpage(URLI: targetsite)
            }
                   )
        }
        .padding()
        
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
