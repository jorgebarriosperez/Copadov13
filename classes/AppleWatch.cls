Public with sharing Class AppleWatch{
 Public Static void appleWatchmethod(list<Opportunity> lopt ){
    for (Opportunity opp : lopt) {
        Task t        = new Task();
        t.Subject     = 'Apple Watch Promo';
        t.Description = 'Send them one ASAP';
        t.Priority    = 'High';
        t.WhatId      = opp.Id;
        //TEST EN MUERTEEE CONFLICTO MUERTE
        insert t;
        //TEST EN MUERTEEE CONFLICTO
             }
  }
 }
