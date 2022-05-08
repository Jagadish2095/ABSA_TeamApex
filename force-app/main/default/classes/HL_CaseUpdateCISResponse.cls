/**@description HL_CaseUpdateCISResponse
*  @author  MV
*  @since 2021-06-05
* **/
public with sharing class HL_CaseUpdateCISResponse {
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
                         AND (DeveloperNAME = 'FIC_Archive' 
                              OR DeveloperNAME = 'FIC_Remediation' 
                              OR DeveloperNAME = 'New_Request' 
                              OR DeveloperNAME = 'Unassigned')]){
				queueNamesMap.put(g.DeveloperNAME,g.id);
        	}
        }
        case casRec = New case(Id=caseId);
        if(Case.sObjectType.getDescribe().isAccessible()) {
            casRec = [Select Id,AccountId,RecordType.Name,Type__c from Case where ID = :caseId LIMIT 1];            
        }
        casRec.Confidence__c =confiLevel;
        if(casRec.Type__c==null){
         	casRec.Type__c =casRec.RecordType.Name;   
        }
        if(casRec.AccountId != Null){
        	if(confiLevel =='High'){ 
                casRec.status ='Remediation';              
                casRec.OwnerId =queueNamesMap.get('FIC_Remediation');           
        	}       
            else if(confiLevel =='Low'){
                    casRec.status ='Remediation';            
                    casRec.OwnerId =queueNamesMap.get('FIC_Remediation'); 
            }
        	else if(confiLevel =='Unknown'){
            casRec.status ='New';
            casRec.OwnerId =queueNamesMap.get('Unassigned');
        	}
         //Check list size
         	if(isHighAndLow(caseId)){
            	casRec.status ='Remediation';
            	casRec.OwnerId =queueNamesMap.get('FIC_Remediation');
        	}
        
        	if(isLowAndUnknown(caseId)){
                casRec.status ='New';
                casRec.OwnerId =queueNamesMap.get('Unassigned');
        	}
        
        	if(isHighAndUnknown(caseId)){
                casRec.status ='New';
            	casRec.OwnerId =queueNamesMap.get('Unassigned');
        	}
            
            
            if(isLowAndLow(caseId)){
            	casRec.OwnerId =queueNamesMap.get('FIC_Remediation');
        	}
            
            if(isHighAndHigh(caseId)){
                casRec.OwnerId =queueNamesMap.get('FIC_Remediation');
            }
            
            if(isUnknownAndUnknown(caseId)){
                casRec.status ='New';
                casRec.OwnerId =queueNamesMap.get('Unassigned');
            }
        	
    }else{
        casRec.OwnerId =queueNamesMap.get('New_Request');
    }
        string errors;
        try{
            if(string.isNotBlank(caseId) && case.sObjectType.getDescribe().isUpdateable()){
                Update casRec;    
            }
        }catch (exception ex){
            errors = 'exception in case update...'+ex;
        }
    }
    /**
    * @description 
    * @author
    * @param caseId 
    * @return boolean 
    **/
    public static boolean isLowAndUnknown(String caseId){
        integer count = 0;
        for(Document__c document : [select Id ,ConfidenceLevel__c ,Case__c from Document__c where Case__c =: caseId]){
            if(document.ConfidenceLevel__c == 'Low' || document.ConfidenceLevel__c == 'UnKnown'){
                count++;
            }
        }
        if(count > 1){
            return true;
        }
        return false;
    }
    
    /**
    * @description 
    * @author
    * @param caseId 
    * @return boolean 
    **/
    
    public static boolean isHighAndLow(String caseId){
        integer count = 0;
        for(Document__c document : [select Id ,ConfidenceLevel__c ,Case__c from Document__c where Case__c =: caseId]){
            if(document.ConfidenceLevel__c == 'Low' || document.ConfidenceLevel__c == 'High'){
                count++;
            }
        }
        if(count > 1){
            return true;
        }
        return false;
    }

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-09-14 
    * @param caseId 
    * @return boolean 
    **/
    public static boolean isHighAndUnknown(String caseId){
        integer count = 0;
        for(Document__c document : [select Id ,ConfidenceLevel__c ,Case__c from Document__c where Case__c =: caseId]){
            if(document.ConfidenceLevel__c == 'UnKnown' || document.ConfidenceLevel__c == 'High'){
                count++;
            }
        }
        if(count > 1){
            return true;
        }
        return false;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-09-14 
    * @param caseId 
    * @return boolean 
    **/
    public static boolean isHighAndHigh(String caseId){
        integer count = 0;
        for(Document__c document : [select Id ,ConfidenceLevel__c ,Case__c from Document__c where Case__c =: caseId]){
            if(document.ConfidenceLevel__c == 'High' || document.ConfidenceLevel__c == 'High'){
                count++;
            }
        }
        if(count > 1){
            return true;
        }
        return false;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-09-14 
    * @param caseId 
    * @return boolean 
    **/
    public static boolean isLowAndLow(String caseId){
        integer count = 0;
        for(Document__c document : [select Id ,ConfidenceLevel__c ,Case__c from Document__c where Case__c =: caseId]){
            if(document.ConfidenceLevel__c == 'Low' || document.ConfidenceLevel__c == 'Low'){
                count++;
            }
        }
        if(count > 1){
            return true;
        }
        return false;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-09-14 
    * @param caseId 
    * @return boolean 
    **/
    public static boolean isUnknownAndUnknown(String caseId){
        integer count = 0;
        for(Document__c document : [select Id ,ConfidenceLevel__c ,Case__c from Document__c where Case__c =: caseId]){
            if(document.ConfidenceLevel__c == 'UnKnown' || document.ConfidenceLevel__c == 'UnKnown'){
                count++;
            }
        }
        if(count > 1){
            return true;
        }
        return false;
    }
}