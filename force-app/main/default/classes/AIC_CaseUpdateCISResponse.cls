/**@description AIC_CaseUpdateCISResponse
*  @author  Anu Dhaka
*  @since 2021-09-13
* **/
public with sharing class AIC_CaseUpdateCISResponse {
    /***
* @comment : caseUpdateOnCisResp
* @description Set values used for case owner update
* @param caseId
* @param confiLevel    
* **/
    public static void caseUpdateOnCisResp(string caseId, String confiLevel) {
        map<string, id> queueNamesMap=new map<string, id>();
        string ficArchiveGroupID;
        string nonFFRemID; 
        if(Group.sObjectType.getDescribe().isAccessible()) {
            for(Group g:[select Id,DeveloperNAME from Group 
                         where Type = 'Queue' 
                         AND (DeveloperNAME = 'Archive_AIC' 
                              OR DeveloperNAME = '' 
                              OR DeveloperNAME = 'New_Request'
                              OR DeveloperNAME = 'Verification_AIC'
                              OR DeveloperNAME = 'Unassigned_AIC')]){
        queueNamesMap.put(g.DeveloperNAME,g.id);
          }
        }
        case casRec = New case(Id=caseId);
        if(Case.sObjectType.getDescribe().isAccessible()) {
            casRec = [Select Id,RecordType.Name,Type__c from Case where ID = :caseId LIMIT 1];            
        }
        casRec.Confidence__c =confiLevel;
        if(casRec.Type__c==null){
           casRec.Type__c =casRec.RecordType.Name;   
        }
        if(confiLevel =='High'){ 
            casRec.status ='Resolved';            
            casRec.OwnerId = queueNamesMap.get('Archive_AIC');                        
        }       
        else if(confiLevel =='Low' || confiLevel =='Unknown'){
            casRec.status ='FIC not Verified';
            casRec.OwnerId = queueNamesMap.get('Verification_AIC');     
        }
        //Check list size
        try{
            if(string.isNotBlank(caseId) && case.sObjectType.getDescribe().isUpdateable()){
                Update casRec;    
            }                
        }catch (exception ex){
            ex.getCause();
        }
    }
}