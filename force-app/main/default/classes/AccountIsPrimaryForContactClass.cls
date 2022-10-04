public with sharing class AccountIsPrimaryForContactClass{
    
    public void checkPrimary(List<AccountContact__c> accountContacts){
        
        Set<AccountContact__c> checks = new Set<AccountContact__c>();
        Set<id> unchecks = new Set<id>();
        List<AccountContact__c> updateAccountContacts = new List<AccountContact__c>();
        
        fillCheckCollections(accountContacts, checks, unchecks);
        
        if(unchecks.size() > 0){
            
            updateAccountContacts.addAll(uncheck(unchecks));
        }
        if(checks.size() > 0){
           
            updateAccountContacts.addAll(check(checks));
        }
        
        if(updateAccountContacts.size() > 0){
            
            update updateAccountContacts;
        }  
    }
    
    private List<AccountContact__c> check(Set<AccountContact__c> checks){
        
        List<AccountContact__c> updateAccountContacts = new List<AccountContact__c>();
        Set<Id> contactSet = new Set<Id>();
        for (AccountContact__c accountContactFromParameter: checks){
            contactSet.add(accountContactFromParameter.Contact__c);
        }
        
        List<AccountContact__c> existAccConts = [SELECT Id, Contact__c
                                                 FROM AccountContact__c
                                                 WHERE Contact__c In:contactSet AND isPrimary__c = true];
        for(AccountContact__c accountContactFromParameter: checks){
            for(AccountContact__c accountContactFromDB: existAccConts){
                Id contactIdFromDB = accountContactFromDB.Contact__c;
                Id contactIdFromParameter = accountContactFromParameter.Contact__c;           
                if(contactIdFromDB == contactIdFromParameter && accountContactFromDB.Id != accountContactFromParameter.Id){
                    accountContactFromDB.isPrimary__c = false;
                    updateAccountContacts.add(accountContactFromDB);
                }
            }
        }  
       return updateAccountContacts;
    }
    
    private List<AccountContact__c> uncheck(Set<id> unchecks){
        List<AccountContact__c> updateAccountContacts = new List<AccountContact__c>();
        
        List<AccountContact__c> existAccConts = [SELECT Id, Contact__c, isPrimary__c, CreatedDate
                                                 FROM AccountContact__c
                                                 WHERE Contact__c In:unchecks 
                                                 ORDER By Contact__c, isPrimary__c DESC, CreatedDate DESC
                                                ];
        
        for(id contactId: unchecks){
            for(AccountContact__c accountContact: existAccConts){
                if(contactId != accountContact.Contact__c){
                    continue;
                }
                if(accountContact.isPrimary__c == false){
                    AccountContact__c updateAccountContact = accountContact;
                    updateAccountContact.isPrimary__c = true;
                    updateAccountContacts.add(updateAccountContact);
                }
                break;          
            }
        }
        
        return updateAccountContacts;
    }
    
    private void fillCheckCollections(
        List<AccountContact__c> accountContacts,
        Set<AccountContact__c> checks,
        Set<id> unchecks){            
            
            for(AccountContact__c accountContact :accountContacts){
                if(accountContact.isPrimary__c == true){
                    Boolean FlagContains = false;
                    for(AccountContact__c accountContactChecks: checks){
                        if (accountContactChecks.Contact__c == accountContact.Contact__c){
                           FlagContains = true;
                        }
                    }
                    if(FlagContains == false){
                       checks.add(accountContact);       
                    }       		
                } else {
                    if(!unchecks.contains(accountContact.Contact__c)){
						unchecks.add(accountContact.Contact__c);       
                    }               
                }
            }
            
            removeDuplicatesFromUnchecked(checks, unchecks);
            
           
        }
    
    private void removeDuplicatesFromUnchecked(
        Set<AccountContact__c> checks,
        Set<id> unchecks){
             for(AccountContact__c accountContact: checks){
                if(unchecks.contains(accountContact.Contact__c)){
                    unchecks.remove(accountContact.Contact__c);
                }
            }  
        }
    
}