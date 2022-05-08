/*
* Integration Utility Class for bcmsgetdocumentsforcase
* @author Haritha Police
* @created 20-01-2021
*/
public class CAFGetDocumentsforCase_IU_v1 {
    @AuraEnabled
public static CAFGetDocumentsforCase_Req_IB_v1 mapRequestfieldsOfGenerateDocsForCase(string caseId){
        
      CAFGetDocumentsforCase_Req_IB_v1 requestBean = new CAFGetDocumentsforCase_Req_IB_v1();
        requestBean.GetDocumentsForCase = new CAFGetDocumentsforCase_Req_IB_v1.GetDocumentsForCase();
        requestBean.GetDocumentsForCase.id = caseId;
        requestBean.GetDocumentsForCase.retrievedBy = 'Salesforce';
     	requestBean.GetDocumentsForCase.showHidden = 'false';
    	system.debug('requestBean----'+requestBean);
        return requestBean;
    }
}