/*
* Integration Utility Class for bcmsgetdocumentsforcase
* @author Haritha Police
* @created 20-01-2021
*/
public class CAFGetCase_IU_v1 {
	public static CAFGetCase_Req_IB_v1 mapReqfieldsForGetCase(String caseId){
        
        CAFGetCase_Req_IB_v1 requestBean = new CAFGetCase_Req_IB_v1();
        requestBean.GetCase = new CAFGetCase_Req_IB_v1.GetCase();
        requestBean.GetCase.id = caseId;
        requestBean.GetCase.retrievedBy = 'Salesforce';
        system.debug('requestBean---'+requestBean);
        return requestBean;
    }
    
    
}