public with sharing class AccountContactService {

    private AccountContactRepository acRepository = new AccountContactRepository();
    private Map<Id, Id> uncheckIsPrimaryMap = new Map<Id, Id>();
    private Set<Id> addPrimaryCheckToLastElementSet = new Set<Id>();

    public void setPrimaryByAC(List<AccountContact__c> acList){

        setPrimary(getAccountContactList(acList));

    }

    public void setPrimaryByContact(List<AccountContact__c> acList){

        setPrimary(getAccountContactListByContact(acList));

    }

    public void setPrimaryByChangedAC(List<AccountContact__c> acNewList, Map<Id, AccountContact__c> acOldMap) {
        List<AccountContact__c> acList = new List<AccountContact__c>();
        for (AccountContact__c ac: acNewList){
            if(acOldMap.get(ac.Id).isPrimary__c != ac.isPrimary__c){
                acList.add(ac);
            }
        }
        setPrimary(getAccountContactList(acList));
    }

    private void setPrimary(List<AccountContact__c> acDBList){

        System.debug('acDBList size ' + acDBList.size());
        Set<Id> cntPrimarySet = new Set<Id>();
        for(AccountContact__c ac: acDBList){
            Id cntId = ac.Contact__c;
            if (cntPrimarySet.contains(cntId)){
                System.debug('We already set isPrimary by' + cntId + ', for: ' + ac.Name);
                continue;
            }
            cntPrimarySet.add(cntId);
            System.debug('isPrimary = ' + ac.isPrimary__c+ ', for: ' + ac.Name);
            if(ac.isPrimary__c){
                uncheckIsPrimaryMap.put(ac.Id, ac.Contact__c);
            }else{
                addPrimaryCheckToLastElementSet.add(ac.Contact__c);
            }

        }

        updateRecords();

    }

    private void updateRecords() {
        List<AccountContact__c> acUpdateList = new List<AccountContact__c>();

        if (uncheckIsPrimaryMap.size() > 0){
            acUpdateList.addAll(removePrimaryCheckFromOtherElements(uncheckIsPrimaryMap.keySet(), uncheckIsPrimaryMap.values()));
        }
        if (addPrimaryCheckToLastElementSet.size() > 0){
            acUpdateList.addAll(addPrimaryCheckToLastElement(addPrimaryCheckToLastElementSet));
        }

        if (acUpdateList.size() > 0){
            System.debug('Update ' + acUpdateList.size() + ' records');
            
            update acUpdateList;
        }
    }

    private List<AccountContact__c> getAccountContactList(List<AccountContact__c> acList) {
        System.debug('By ac search ' + acList.size());
        return acRepository.getAccountContact(acList);
    }

    private List<AccountContact__c> getAccountContactListByContact(List<AccountContact__c> acList) {
        Set<Id> cntSet = new Set<Id>();
            for (AccountContact__c ac: acList){
                cntSet.add(ac.Contact__c);
                System.debug('ac.Contact__r.Id ' + ac.Contact__c);
            }
            System.debug('By contact search ' + cntSet.size());
            return acRepository.getAccountContact(cntSet);
    }

    private List<AccountContact__c> removePrimaryCheckFromOtherElements(Set<Id> acList, List<Id> cntList){
        List<AccountContact__c> acUpdateList = new List<AccountContact__c>();
        for(AccountContact__c acUpdate : acRepository.getAccountContactIsPrimary(acList, cntList)){
            acUpdate.isPrimary__c = false;
            acUpdateList.add(acUpdate);
            System.debug('Set isPrimary = ' + acUpdate.isPrimary__c+ ', for: ' + acUpdate.Name);
        }
        return acUpdateList;
    }

    private List<AccountContact__c> addPrimaryCheckToLastElement(Set<Id> cntSet){
        List<AccountContact__c> acUpdateList = new List<AccountContact__c>();
        for (Contact cnt: acRepository.getContactAndLastAccountContact(cntSet)){

            if(cnt.AccountContacts__r.size() == 0){
                continue;
            }
            if(cnt.AccountContacts__r[0].isPrimary__c){
                continue;
            }

            AccountContact__c acUpdate = cnt.AccountContacts__r[0];
            acUpdate.isPrimary__c = true;
            acUpdateList.add(acUpdate);
            System.debug('Set isPrimary = ' + acUpdate.isPrimary__c+ ', for: ' + acUpdate.Name);
        }
        return acUpdateList;
    }

}