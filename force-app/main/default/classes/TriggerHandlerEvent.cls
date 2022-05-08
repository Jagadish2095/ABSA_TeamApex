/**
* Handler for the event trigger
* @author  Kyle Alexander
* @created 2018-06-06
*/

public without sharing class TriggerHandlerEvent extends TriggerHandler {

    public virtual override void beforeInsert(List<sObject> newRecords){
        //Cast sObject maps to Event maps
        List<Event> eventTriggerNew = (List<Event>)newRecords;

        for(Event event : eventTriggerNew) {
            EventTriggerFunctions.setValuesForEvent(event);
            EventTriggerFunctions.setEventNotificationTime(event);
        }
    }
}