/**
* Methods in this class are used for tracking time spend 
* in veriouse statuses and managing SLA's and milestones
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2019-07-01
*/
public class ActivityTrackingAndSLAManagement {
    /*
    * Track status changes actual laps time and business hours
    * 
    * @param List<SObject> newObjects
    */
    public static void trackStatus(List<SObject> newObjects, Map<Id, SObject> oldObjectsMap){

        List<Activity_Tracking__c> trackingInsertList = new List<Activity_Tracking__c>();
        List<Activity_Tracking__c> trackingUpdateList = new List<Activity_Tracking__c>();
        String objOldStatus = '';
        String objNewStatus = '';
        Map<Id, String> leadStatusMap = new Map<Id, String>();

        for(SObject obj :newObjects){

            SObjectType objType = obj.getSObjectType();
            SObject castRecord;

            if(objType == Lead.SObjectType){

                castRecord = (Lead)obj;
               
                Object fieldValue = castRecord.get('Status');
                objNewStatus = String.valueOf(fieldValue);
                
                Lead oldLead = (Lead)oldObjectsMap.get(castRecord.Id);
                objOldStatus = oldLead.Status;

                if( objNewStatus != objOldStatus){
                    leadStatusMap.put(castRecord.Id, objNewStatus);
                }

            }else if(objType == Case.SObjectType){
                castRecord = (Case)obj;
                //TO DO: Add code here for Case Status tracking
            }
        }

        if( leadStatusMap.size() > 0 ){
            //get default business hours
            List<BusinessHours> defaultBhrs = new BusinessHoursSelector().selectDefault();

            for( Lead newLead :new LeadsSelector().selectByIdsWithActivityTracking( leadStatusMap.keySet() ) ){

                //Check if business hours Id exists on lead, else use the default
                Id bhrsId = newLead.Business_Hours__c;
                
                if(String.isBlank(bhrsId)){
                    bhrsId = defaultBhrs[0].Id;
                }

                //update existing tracking records
                if( newLead.Activity_Tracking__r.size() > 0 ){
                    
                    //Business time tracked
                    Long timeDiff = BusinessHours.diff(bhrsId, newLead.Activity_Tracking__r[0].Start_Time__c, System.now());
                    Integer minDiff = (timeDiff.intValue() / 1000) / 60;
                    newLead.Activity_Tracking__r[0].Business_Time_Min__c = minDiff;

                    //Total time tracked
                    DateTime theStart = newLead.Activity_Tracking__r[0].Start_Time__c;
                    Long startTime = theStart.getTime();
                    Long endTime = DateTime.now().getTime();
                    Integer totalMinDiff = (( endTime.intValue() - startTime.intValue()) / 1000 ) / 60;
                    newLead.Activity_Tracking__r[0].Total_Time_Min__c = totalMinDiff;

                    //Set end time and user    
                    newLead.Activity_Tracking__r[0].End_Time__c = System.now();
                    newLead.Activity_Tracking__r[0].End_Initiator__c = UserInfo.getUserName();

                    trackingUpdateList.add( newLead.Activity_Tracking__r[0] );
                }   

                if(newLead.sd_Track_Status_Changes__c){

                     Activity_Tracking__c tracking = new Activity_Tracking__c();
                    tracking.Start_Initiator__c = UserInfo.getUserName();
                    tracking.Start_Time__c = System.now();
                    tracking.Status_Tracked__c = newLead.Status;
                    tracking.Lead__c = newLead.Id;

                    trackingInsertList.add(tracking);
                }
               
            }

            if( trackingInsertList.size() > 0){

                try{
                    insert trackingInsertList;
                }catch(DMLException ex){
                    System.debug(ex.getMessage());
                    AuditTrailLog.logException(ex, 'New', 'Error', 'ActivityTrackingAndSLAManagement', 'trackStatus', 'There was an error inserting Activity_Tracking__c records' );
                    throw ex;
                }
            }

             if( trackingUpdateList.size() > 0 ){

                try{
                    update trackingUpdateList;
                }catch(DMLException ex){
                    System.debug(ex.getMessage());
                    AuditTrailLog.logException(ex, 'New', 'Error', 'ActivityTrackingAndSLAManagement', 'trackStatus', 'There was an error updating Activity_Tracking__c records' );
                    throw ex;
                }
            }
        }
    }

    /*
    * Track status changes actual laps time and business hours
    * 
    * @param List<SObject> newObjects
    */
    public static void insertStatusTracking(List<SObject> newObjects){
        
        List<Activity_Tracking__c> trackingList = new List<Activity_Tracking__c>();
        String statusValue = '';
        Boolean shouldTrackStatus = false;

        for(SObject obj :newObjects){

            SObjectType objType = obj.getSObjectType();
            SObject castRecord;

            if(objType == Lead.SObjectType){

                castRecord = (Lead)obj;
               
                Object trackIndicator = castRecord.get('sd_Track_Status_Changes__c');
                shouldTrackStatus = Boolean.valueOf(trackIndicator);
                
                Object statusField = castRecord.get('Status');
                statusValue = String.valueOf(statusField);
                

                if(shouldTrackStatus){

                    Activity_Tracking__c tracking = new Activity_Tracking__c();
                    tracking.Start_Initiator__c = UserInfo.getUserName();
                    tracking.Start_Time__c = System.now();
                    tracking.Status_Tracked__c = statusValue;
                    tracking.Lead__c = castRecord.Id;

                    trackingList.add(tracking);
                }

            }else if(objType == Case.SObjectType){
                castRecord = (Case)obj;
                //TO DO: Add code here for Case Status tracking
            }
            
        }

        if( trackingList.size() > 0){
            try{

                insert trackingList;

            }catch(DMLException ex){

                System.debug(ex.getMessage());
                AuditTrailLog.logException(ex, 'New', 'Error', 'ActivityTrackingAndSLAManagement', 'insertStatusTracking', 'There was an error inserting Activity_Tracking__c records' );

                throw ex;
            }
        }
    }

}