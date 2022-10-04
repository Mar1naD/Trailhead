trigger AccountIsPrimaryForContact on AccountContact__c (after insert, after update) {
    if (Trigger.isInsert && Trigger.isAfter){  
        new AccountIsPrimaryForContactClass().checkPrimary(Trigger.new);
    }
    
   if (Trigger.isUpdate && Trigger.isAfter){  
        new AccountIsPrimaryForContactClass().checkPrimary(Trigger.new);
    } 
}