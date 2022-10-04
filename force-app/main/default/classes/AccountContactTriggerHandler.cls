public with sharing class AccountContactTriggerHandler {

    AccountContactService acService;
    public AccountContactTriggerHandler(){
        acService = new AccountContactService();
    }
    public void afterInsert(List<AccountContact__c> acList) {
        acService.setPrimaryByAC(acList);
    }

    public void afterUpdate(List<AccountContact__c> acNewList, Map<Id, AccountContact__c> acOldMap) {
        acService.setPrimaryByChangedAC(acNewList, acOldMap);
    }

    public void afterDelete(List<AccountContact__c> acList) {
        acService.setPrimaryByContact(acList);
    }
    public void afterUndelete(List<AccountContact__c> acList) {
        acService.setPrimaryByAC(acList);
    }

}