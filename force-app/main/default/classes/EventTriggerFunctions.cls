/**
 * Created by kylealexander on 2018/08/01.
 */

public with sharing class EventTriggerFunctions {
    /**
     * Method that sets custom opportunity lookup and contact lookup on an activity.
     * This is for use by process builder every time an event is created
     *
     * @param event current event instance
     */
    public static void setValuesForEvent(Event event){
        
        if(event.WhatId != null){
            String checkIfIsOpportunity = String.valueOf(event.WhatId).substring(0, 3);
            //006 is prefix of opportunity record - this is done because the whatId is referenced
            if(checkIfIsOpportunity == '006'){
                Opportunity opp = new OpportunitiesSelector().selectByActivityId(event.WhatId, 1);
                Account acc = new AccountsSelector().selectByOpportunityId(opp.AccountId, 1);
                
                //Id personRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                Id personRecordType = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Individual_Client').getRecordTypeId();
                //Check if Record Type is Person Account
                if(personRecordType == acc.RecordTypeId){
                    Contact con = new ContactsSelector().selectByPersonId(acc.PersonContactId, 1);
                    
                    event.Opportunity__c = opp.id;
                    event.Contact__c = con.id;
                }
            }
        }
    }

    /**
     * Method that sets NotificationTime__c on event which is used by process builder to send out notifications at that time
     *
     * @param triggerNew
     */
    public static void setEventNotificationTime(Event event){
        if(event.WhatId != null){
            String checkIfIsOpportunity = String.valueOf(event.WhatId).substring(0, 3);
            //006 is prefix of opportunity record - this is done because the whatId is referenced
            if(checkIfIsOpportunity == '006'){
                if(event.StartDateTime != null){
                    //Set default time to same date but at 10am for comparison
                    Datetime defaultDateTime = Datetime.newinstance(event.StartDateTime.year(), event.StartDateTime.month(), event.StartDateTime.day(), 10, 0, 0);
                    //If the start time is less than 10am then set to previous day at 3pm
                    //Else set the notification time as the start time minus 4 hours
                    if(event.StartDateTime < defaultDateTime){
                        //Set the Events NotificationTime__c to previous day at 3PM
                        Datetime previousDateTime = Datetime.newinstance(event.StartDateTime.year(), event.StartDateTime.month(), event.StartDateTime.day() - 1, 15, 0, 0);
                        event.NotificationTime__c = Datetime.valueOf(previousDateTime);
                    }
                    else{
                        //Set the Events NotificationTime__c to 4 Hours prior to start time
                        event.NotificationTime__c = event.StartDateTime.addHours(-4);
                    }
                }
            }
        }
    }
}