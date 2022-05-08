/* Lightning cmp controller for displaying the relevant job execution flow to users based upon case type
 Author: Saurabh
 Date : 24/09/2019  */


 public class ExecuteJobController {
    
    @AuraEnabled
    public static casewithservicetype CaseDetails(Id caseId ){

        try {

            List<Case> caselist = new CasesSelector().selectByIdWithSLAInfo(caseId,1);
            Id serviceGroupTypeId ;
            Service_Group_Type__c sgt = new Service_Group_Type__c();

            if(String.isNotBlank( caselist[0].sd_Service_Group_Type_Id__c )){

                serviceGroupTypeId = caselist[0].sd_Service_Group_Type_Id__c;
                sgt = new ServiceGroupTypesSelector().selectByServiceGrpTypeId(serviceGroupTypeId);
                
            }  

            casewithservicetype returncasewithservicetype = new casewithservicetype();
            returncasewithservicetype.caseobj = caselist[0];
            returncasewithservicetype.sgtobj = sgt;
            
            return returncasewithservicetype; 

           }  
        
        catch (Exception e) {
             
            
            // "Convert" the exception into an AuraHandledException
            
            throw new AuraHandledException('Something went wrong: '
                                           + e.getMessage()); 
            
        }    
        
        
    }
    
    
    public class casewithservicetype{
        @AuraEnabled  public Case caseobj {get;set;}
        @AuraEnabled  public Service_Group_Type__c sgtobj {get;set;}
    }

    /**
     * Rudolf Niehaus
     * Auto classify the Case based on the selected job
     * 
     * @param  String caseRecordId
     * @param  Service_Group_Type__c serviceGroupType 
     * 
     */
    @AuraEnabled
    public static void classifyCase(String caseRecordId, Service_Group_Type__c serviceGroupType ){

        String errorMsg = 'Exception';
        AuraHandledException ex = new AuraHandledException(errorMsg);

        try{
            
            if(caseRecordId != null){
                
                Case caseObj = new Case(Id=caseRecordId);
                caseObj.Type__c = serviceGroupType.Service_Type__r.Name;
                caseObj.Subtype__c = serviceGroupType.Service_Type__r.Subtype__c;
                caseObj.Product__c = serviceGroupType.Service_Type__r.Product__c;
                caseObj.sd_Service_Group__c = serviceGroupType.Service_Group__r.Name;
                caseObj.sd_Service_Group_Type_Id__c = serviceGroupType.Id; 
                caseObj.sd_Service_Level_Id__c = serviceGroupType.Service_Level__c; 
                caseObj.sd_Service_Group_Id__c = serviceGroupType.Service_Group__c;
                caseObj.sd_Communication_Plan_Id__c = serviceGroupType.sd_Communication_Plan__c;

                //Rudolf Niehaus - Make sure we assign a valid busisness hours id to the case, else it throws an exception
                //Get the org default if not valid
                if(String.isNotBlank(serviceGroupType.Service_Group__r.Business_Hours__c)){
                    caseObj.BusinessHoursId = serviceGroupType.Service_Group__r.Business_Hours__c;
                }else{
                    
                    //get default business hours
                    List<BusinessHours> defaultBhrs = new BusinessHoursSelector().selectDefault();

                    if(defaultBhrs.size() > 0){
                        caseObj.BusinessHoursId = defaultBhrs[0].Id;
                    }
                    
                }

                caseObj.Status = 'In Progress';
                
                update caseObj;
            }

        }catch(DmlException e){
            throw new AuraHandledException( e.getMessage());
        }

    }

    /**  W-019387
    * @description Gets flow linked to Service Type
    * @author Lehlohonolo.Matsoso@absa.africa | 2022-03-11
    * @param serviceTypeName
    * @return String
    **/
    @AuraEnabled
    public static String getFlowNameByServiceType(String serviceTypeName ){
        return [Select Flow__c From Service_Group_Type__c Where Service_Type__r.Name =: serviceTypeName].Flow__c;
    }

}