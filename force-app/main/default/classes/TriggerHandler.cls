public virtual class TriggerHandler{
        

    public virtual void beforeInsert(List<sObject> newRecords) {
        System.debug('TriggerHandler : beforeInsert');
    }

    public virtual void beforeUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
        System.debug('TriggerHandler : beforeUpdate');
    }

    public virtual void beforeDelete(Map<Id, sObject> oldRecords) {
        System.debug('TriggerHandler : beforeDelete');
    }
    
    public virtual void afterInsert(Map<Id, sObject> newRecords) {
        System.debug('TriggerHandler : afterInsert');
    }

    public virtual void afterUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
         System.debug('TriggerHandler : afterUpdate');
    }

    public virtual void afterDelete(Map<Id, sObject> oldRecords) {
         System.debug('TriggerHandler : afterDelete');
    }

    public virtual void afterUnDelete(Map<Id, sObject> oldRecords) {
         System.debug('TriggerHandler : afterUnDelete');
    }
}