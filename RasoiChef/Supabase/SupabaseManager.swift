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
    
    var supabaseClient:SupabaseClient = SupabaseClient(supabaseURL:URL(string :"https://lplftokvbtoqqietgujl.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxwbGZ0b2t2YnRvcXFpZXRndWpsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk4NzA2NzQsImV4cCI6MjA1NTQ0NjY3NH0.2EOleVodMu4KFH2Zn6jMyXniMckbTdKlf45beahOlHM")
    
    
}
