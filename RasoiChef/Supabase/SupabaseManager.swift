//
//  SupabaseManager.swift
//  RasoiChef
//
//  Created by Ankit Jain on 18/02/25.
//

import Foundation
import Supabase




class SupabaseAuthenticationManager {
    private init(){
        
    }
    
    var shared = SupabaseAuthenticationManager()
    
    var supabaseClient:SupabaseClient = SupabaseClient(supabaseURL:URL(string :"https://nndvzirldpnnnbajkylb.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5uZHZ6aXJsZHBubm5iYWpreWxiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk4MDI2NTksImV4cCI6MjA1NTM3ODY1OX0.sh3mwRT8FwkS7Epwm3OesfZBXD4LkZgxsk6HNa_4pV4")
    
    
}
