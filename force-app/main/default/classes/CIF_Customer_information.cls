/**
 *
 * @author  Nikolay Kibalov
 * @since   2021-06-04
 * @description : CIF_Customer_information
**/

public with sharing class CIF_Customer_information {

  
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-10-18 
    * @param recordId 
    * @return Case 
    **/
    @AuraEnabled
    public static Case getCase(Id recordId) {
        updateRiskRate(recordId);
        List<Case> listCases = new List<Case>();
        if(Case.SObjectType.getDescribe().isAccessible()) {
            listCases = [
                    SELECT CIF__c,Origin, Recordtype.Name, Recordtype.DeveloperName, Birth_Date__c, Product_Type__c, Last_Name__c, AccountId,ID_Type__c,Account.SBU_Segment__c,MissingDocuments__c
                    FROM Case
                    WHERE Id = :recordId
            ];
        } else {
            return null;
        }
       
        if (!listCases.isEmpty()) {
            return listCases[0];
        } else {
            throw new ApplicationException('There is no Case for this Id');
        }
    }

    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-10-26 
    * @param caseId 
    **/
    @AuraEnabled
    public static void updateRiskRate(string caseId) {
        Map<string, string> docMsgMap = New Map<string, string>{'ProofOfId'=>'Proof Of Identification','ProofOfAddress'=>'Proof Of Address','ProofOfAuthority'=>'Proof Of Authority','ProofOfIncome'=>'Proof Of Income'};
        String missingDocumentsString = '';
        List<Case> listCases = new List<Case>();
        if(Case.SObjectType.getDescribe().isAccessible()) {
            listCases = [
                    SELECT CIF__c,Origin,Recordtype.Name, Recordtype.DeveloperName, Birth_Date__c, Product_Type__c, Last_Name__c, AccountId,ID_Type__c,Account.SBU_Segment__c,MissingDocuments__c
                    FROM Case
                    WHERE Id = :caseId
            ];
        }
        
        if(listCases.size() > 0 && listCases[0].AccountId != null){
           ComplianceViewDashboardController.ComplianceData complianceData = ComplianceViewDashboardController.getData(listCases[0].AccountId);
            if(complianceData != null){
                if(complianceData.missingDocuments != null && complianceData.missingDocuments.size() > 0){
                     for(string dc: complianceData.missingDocuments){
                        if(docMsgMap.containsKey(dc)){
                    		missingDocumentsString +='&#8226; &nbsp; &nbsp; &nbsp;'.unescapeHtml4()+'  '+docMsgMap.get(dc)+'\n';
                		}
            		}
            			missingDocumentsString = missingDocumentsString.removeEnd('\n');
                }
                listCases[0].MissingDocuments__c = missingDocumentsString;
                update listCases[0];
            }
        }
    }

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-11-17 
    * @param objObject 
    * @param fld 
    * @return List<String> 
    **/
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        List < String > allOpts = new list < String > ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
            for (Schema.PicklistEntry a: values) {
                allOpts.add(a.getValue());
            }
        allOpts.sort();
        return allOpts;
    }   

}