trigger AccountContactTrigger on AccountContact__c (before insert, before update, before delete,
        after insert, after update , after delete, after undelete) {

    AccountContactTriggerHandler acTriggerHandler = new AccountContactTriggerHandler();

    if(Trigger.isAfter) {
        if (Trigger.isInsert) {
            acTriggerHandler.afterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            acTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete) {
            acTriggerHandler.afterDelete(Trigger.old);
        } else if (Trigger.isUndelete) {
            acTriggerHandler.afterUndelete(Trigger.new);
        }
    }
}