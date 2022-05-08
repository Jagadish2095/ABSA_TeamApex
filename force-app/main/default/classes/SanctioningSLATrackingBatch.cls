/**
* Sanctioning SLA Tracking batch to update business hours 
*
* @author  Almas Aleem :absa
* @since   2020-07-20
*/
global class SanctioningSLATrackingBatch implements Database.Batchable<Opportunity> {
    
    global Iterable<Opportunity> start(Database.BatchableContext BC){
        
        //dependent class in schedulable class can't be edited ,that's why used query instead of selector class                            
                        
        List<Opportunity> OpportunityList = [Select Id,Sanctioning_SLA_Start_Date__c,Sanctioning_SLA_Hours_Calculated__c,Sanctioning_SLA_End_Date__c,Is_Submitted_Sanctioning__c,
                                             Sanctioning_SLA_Temp_End_Date__c,Sanctioning_SLA_Hours__c,Sanctioning_SLA_Temp_Start_Date__c,More_Info_Category__c,More_Info_Decision__c
                                             From Opportunity
                                             Where 
                                             Sanctioning_SLA_Start_Date__c !=null
                                             AND
                                             Is_Submitted_Sanctioning__c = true
                                             AND 
                                             More_Info_Decision__c !=true
                                             ];  //paused opportunity not to included
        
        
        return OpportunityList;
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        if(scope !=null && scope.size()>0){
            
            
            
             //dependent class in schedulable class can't be edited ,that's why used query instead of selector class   
          //List<BusinessHours> bhList =  new BusinessHoursSelector().selectSanctioningBusinessHours();
          BusinessHours bh = [Select Id,name ,IsDefault From BusinessHours where name=:'Monday to Friday (8h00 - 16h30) excluding public holidays'];
            For(Opportunity opp :scope){
                Long CalculatedSLA;
                system.debug('before calculated SLA opp---'+opp);
                Boolean isResume =false;
                
                if(opp.Sanctioning_SLA_Start_Date__c !=null && opp.Sanctioning_SLA_End_Date__c == null && opp.Sanctioning_SLA_Temp_End_Date__c == null && opp.Sanctioning_SLA_Temp_Start_Date__c == null && !opp.More_Info_Decision__c ){
                    
                    CalculatedSLA = BusinessHours.diff(bh.Id, opp.Sanctioning_SLA_Start_Date__c, system.now());
                    
                }else if(opp.Sanctioning_SLA_Temp_Start_Date__c !=null && !opp.More_Info_Decision__c  && opp.Sanctioning_SLA_End_Date__c == null){
                      
                    CalculatedSLA = BusinessHours.diff(bh.Id, opp.Sanctioning_SLA_Temp_Start_Date__c, system.now());
                    system.debug('in resume---');
                    isResume = true;
                }else if(opp.Sanctioning_SLA_End_Date__c != null && opp.Sanctioning_SLA_Start_Date__c!=null ){
                      
                    CalculatedSLA = BusinessHours.diff(bh.Id, opp.Sanctioning_SLA_Start_Date__c, opp.Sanctioning_SLA_End_Date__c);
                    
                }
                
                system.debug('CalculatedSLA in long milliseconds---'+CalculatedSLA);
                Integer  calculatedDiffmin= (CalculatedSLA.intValue()/1000)/60;
           
                
               
                if (isResume){
                    
                    opp.Sanctioning_SLA_Hours_Calculated__c = opp.Sanctioning_SLA_Hours_Calculated__c + calculatedDiffmin;
                    
                }else{
                    opp.Sanctioning_SLA_Hours_Calculated__c = calculatedDiffmin;
                }
           
               
            Long hours = opp.Sanctioning_SLA_Hours_Calculated__c.longValue() / 60;
            Long minutes = Math.mod(opp.Sanctioning_SLA_Hours_Calculated__c.longValue(), 60);
            
             system.debug('hours--'+hours+'minutes--'+minutes);   
                
              opp.Sanctioning_SLA_Hours__c =hours +'h:'+minutes+'m';  
                system.debug('opp calculated SLA---'+opp);
            }
            try{
                update scope;
                
            }catch(Exception e){
                System.debug('exception--'+e.getMessage() +'Line Number--'+e.getLineNumber());
                
                
            }
            
        }
        
    }
    global void finish(Database.BatchableContext BC){
        
    }
    
}