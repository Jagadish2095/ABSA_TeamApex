/**
 * @description       : 
 * @author            : mohammedjunaid.usman@absa.africa
 * @last modified on  : 2021-09-27
 * @last modified by  : mohammedjunaid.usman@absa.africa
**/

public with sharing class MisssingFICARequirement {
    /**
* @description
*/
    public ID accountId {get;set;}
    
    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-09-27 
    * @return documentData 
    **/
    public documentData missingFICADocuments{
        get{
            documentData dataFields = new documentData();
            dataFields.missingDocuments = new List<string>();
            dataFields.refreshableDocuments = new List<string>();
            dataFields.missingFields = new List<string>();
            if(accountId != null && !string.isEmpty(accountId)){
                Account accRec = new AccountsSelector().selectAllById(accountId);
                String JSONString = accRec.FICA_Requirements__c;
                dataFields = (documentData)JSON.deserialize(JSONString, documentData.class);
            }
            return dataFields;
        }
        set{}
    }
    /**
* @description Container class that stores the Missing Documents and Fields to be displayed in the UI
*/
    public class documentData{
        /**
* @description
*/
        Public List<String> missingDocuments{get;set;}
        /**
* @description
*/
        Public List<String> refreshableDocuments{get;set;}
        /**
* @description
*/
        Public List<String> missingFields{get;set;}
    }
}