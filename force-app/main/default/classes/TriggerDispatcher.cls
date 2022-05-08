public class TriggerDispatcher {

    public static Set<Id> processedBeforeRecords = new Set<Id>();
    public static Set<Id> processedAfterRecords = new Set<Id>();
    private static Set<String> skippedTriggers = new Set<String>();

    /**
    * Main method used to control how triggers are executed and handled.
    **/
    public static void run(TriggerHandler handler) {

        System.debug('BEFORE RECORDS: '+processedBeforeRecords);
        System.debug('AFTER RECORDS: '+processedAfterRecords);

        if(!skippedTriggers.contains( getHandlerName(handler) )) {

            if(Trigger.isBefore) {

                if(Trigger.isInsert) {
                    handler.beforeInsert(Trigger.new); 
                }

                if(Trigger.isUpdate) {

                    if(!processedBeforeRecords.containsAll(Trigger.newMap.keySet())) {
                        handler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
                    }

                    processedBeforeRecords.addAll(Trigger.newMap.keySet());
                }
                
                if(Trigger.isDelete) {
                    handler.beforeDelete(Trigger.oldMap); 
                }
            }

            if(Trigger.isAfter) {

                if(Trigger.isInsert) {
                    handler.afterInsert(Trigger.newMap); 
                }

                if(Trigger.isUpdate) {

                    if(!processedAfterRecords.containsAll(Trigger.newMap.keySet())) {
                        handler.afterUpdate(Trigger.newMap, Trigger.oldMap);
                    }

                    processedAfterRecords.addAll(Trigger.newMap.keySet());
                }
                
                if(Trigger.isDelete) {
                    handler.afterDelete(Trigger.oldMap); 
                }
                
                if(Trigger.isUnDelete) {
                    handler.afterUnDelete(Trigger.oldMap); 
                }
            }
        }
    }

    /**
    * Add a handler name to the list of handlers to skip when executing triggers.
    **/
    public static void skip(String handlerName) {

        skippedTriggers.add(handlerName);
    }

    /**
    * Adds multiple handler names to the list of handlers to skip when executing triggers.
    **/
    public static void skip(List<String> handlerNames) {
        
        for(String handlerName : handlerNames) {
            skip(handlerName);
        }
    }   

    /**
    * Removes a handler name from the list of skipped triggers.
    **/
    public static void resume(String handlerName) {

        skippedTriggers.remove(handlerName);
    }

    /**
    * Removes multiple handler names from the list of skipped triggers.
    **/
    public static void resume(List<String> handlerNames) {

        for(String handlerName : handlerNames) {
            resume(handlerName);
        }
    }

    /**
    * Gets the string name of an instance of an unknown class type.
    **/
    private static String getHandlerName(TriggerHandler handler) {
        
       return String.valueOf(handler).split(':')[0];
    }
}