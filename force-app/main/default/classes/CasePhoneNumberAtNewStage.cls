/**
* @description Case Phone Number At New Stage Description
*
*/

public class CasePhoneNumberAtNewStage {

/**
* @description check Satge As New Description
* @param CaseId
* @return string
*
*/    
    @AuraEnabled
    public static string checkSatgeAsNew(String CaseId){
        List<Case> cases;
        
        string statusofCase = '';
        if(string.isNotBlank(CaseId)){
            cases = [SELECT Id, Status FROM Case WHERE Id =:CaseId LIMIT 1];
            if(cases.size() > 0){
                statusofCase = 'TRUE';
            }else{
                statusofCase = 'FALSE';
            }
        }
        RETURN statusofCase;
    }
    
}