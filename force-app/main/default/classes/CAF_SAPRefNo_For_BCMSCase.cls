/** 
    * @description get SAP Ref Number
    * @author: Jaco de Lange
    * @return 
    
    */
public class CAF_SAPRefNo_For_BCMSCase implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    /** 
    * @description get SAP Ref Number
    * @author: Jaco de Lange
    * @return 
    * @param BC
    
    */
        public Database.QueryLocator start(Database.BatchableContext BC) {
            //get cases
            return Database.getQueryLocator('select Id, CaseNumber, Get_SAP_Ref_No__c, External_Reference_Number__c, External_Reference_Type__c FROM Case WHERE Get_SAP_Ref_No__c <> false LIMIT 1'); 
        }
        /** 
    * @description get SAP Ref Number
    * @author: Jaco de Lange
    * @param info
    * @param caseRecs
    
    */
        public void execute(Database.BatchableContext info, List<sObject> caseRecs) {

            List<Case> caseList = (List<Case>)caseRecs;
            if (caseList!=null){
                system.debug ('Case List : ' + caseList);

                Case cRec = caseList[0];
                
                Id aPCId = [SELECT Id FROM Application_Product_CAF__c WHERE Case_Number__c =: cRec.CaseNumber LIMIT 1].Id;
                system.debug ('Application Product ID : ' + aPCId);

                if (cRec.External_Reference_Number__c!=null){
                    System.debug('cRec.External_Reference_Number__c '+cRec.External_Reference_Number__c);
                    CAFGetCase_Resp_IB_v1 response = CAFGetCase_IH_v1.bcmsgetcasev1data(cRec.External_Reference_Number__c);
                    system.debug ('CAF Get Case Response : ' + response);

                    if (response == null) {
                        throw new AuraHandledException('storeSAPFields: response is null.');
                    }
                    if (response.GetCaseResponse == null || response.GetCaseResponse.TheCase == null || response.GetCaseResponse.TheCase.Data == null) {
                        System.debug('storeSAPFields: Unexpected response received. Service Response: ' + JSON.serialize(response));
                        throw new AuraHandledException('storeSAPFields: Unexpected response received. Service Response: ' + JSON.serialize(response));
                    }

                    String xmlData = EncodingUtil.base64Decode(response.GetCaseResponse.TheCase.Data).toString();
                    Dom.Document domDoc = new Dom.Document();
                    domDoc.load(xmlData);
            
                    Dom.XmlNode rootNode = domDoc.getRootElement();
                    system.debug ('Root Node Response : ' + rootNode);
                    string sapRefNode = rootNode.getChildElement('sapRefNo', null)?.getText();
                    string sapExternalReferenceNode = rootNode.getChildElement('sapExternalReference', null)?.getText();
                    string scoreResultNode = rootNode.getChildElement('scoreResult', null)?.getText();

                    Application_Product_CAF__c aPC = new Application_Product_CAF__c(
                        Id = aPCId,
                        SAP_Reference_Number__c = sapRefNode,
                        SAP_External_Reference__c = sapExternalReferenceNode,
                        SAP_Scoring_Status__c = scoreResultNode
                    );
                    update aPC;

                    Case cU = new case (
                        Id = cRec.Id,
                        Get_SAP_Ref_No__c = false
                    );
                    update cU;

                    //after update, abort the job
                    if (!Test.isRunningTest()){
                    	CronTrigger obj = [SELECT Id, CronJobDetail.Name, CronJobDetail.Id,State FROM CronTrigger where CronJobDetail.Name = 'Fetch SAP Ref No'];
                    	System.abortJob(obj.Id);
                	}
                }
            }
        }
        /** 
    * @description get SAP Ref Number
    * @author: Jaco de Lange
    * @param info
    
    */
        public void finish(Database.BatchableContext info) { }
}