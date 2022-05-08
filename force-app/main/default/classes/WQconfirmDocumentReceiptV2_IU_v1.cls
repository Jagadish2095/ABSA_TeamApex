/**
* Apex Integration Utility Bean class for WQconfirmDocumentReceiptV2 service
* @author  Anka Ganta : Absa
* @since   2020-06-22
*
**/
public class WQconfirmDocumentReceiptV2_IU_v1 {
    /* Creates a Request Bean from Generatedocumentsv7 response 
    * @param: List of Case objects
    * @return: WQconfirmDocumentReceiptV2_Req_IB_v1 bean object
    * */
    public static WQconfirmDocumentReceiptV2_Req_IB_v1 mapRequestFields(Account accRecP,List<String> docCodesListP,String docNoP,String VersionNoP){
        WQconfirmDocumentReceiptV2_Req_IB_v1 requestBean = new WQconfirmDocumentReceiptV2_Req_IB_v1();
        WQconfirmDocumentReceiptV2_Req_IB_v1.Nbsapdpi Nbsapdpibean  = new WQconfirmDocumentReceiptV2_Req_IB_v1.Nbsapdpi();
        WQconfirmDocumentReceiptV2_Req_IB_v1.Wqp131i Wqp131ibean  = new WQconfirmDocumentReceiptV2_Req_IB_v1.Wqp131i();
        
        List<WQconfirmDocumentReceiptV2_Req_IB_v1.RequiredDocs> RequiredDocsbeanList = new List<WQconfirmDocumentReceiptV2_Req_IB_v1.RequiredDocs>();
        WQconfirmDocumentReceiptV2_Req_IB_v1.WQconfirmDocumentReceiptV2 WQconfirmDocumentReceiptV2bean  = new WQconfirmDocumentReceiptV2_Req_IB_v1.WQconfirmDocumentReceiptV2();
        
        
        Usersselector us = new Usersselector();
        List<User> userP = us.userwithSiteCode(UserInfo.getUserId());
        
        Nbsapdpibean.channel = 'ESP';
        Nbsapdpibean.application = 'ESP';
        Nbsapdpibean.trace = 'Y';
        System.debug('docCodesListP++'+docCodesListP);
        for(String docCodeInput:docCodesListP){
            WQconfirmDocumentReceiptV2_Req_IB_v1.RequiredDocs RequiredDocsbean  = new WQconfirmDocumentReceiptV2_Req_IB_v1.RequiredDocs();
            System.debug('docCodeInput++'+docCodeInput);
            if(docCodeInput != null){
                RequiredDocsbean.docCode = docCodeInput;
            }
               else{
                   RequiredDocsbean.docCode = '';
               }
            RequiredDocsbean.received = 'Y';
            RequiredDocsbean.inOrder = 'Y';
            RequiredDocsbean.scanYn = 'Y';
            RequiredDocsbeanList.add(RequiredDocsbean);
            System.debug('RequiredDocsbean++'+RequiredDocsbean);
            System.debug('RequiredDocsbeanList36++'+RequiredDocsbeanList);
        }
        
        System.debug('RequiredDocsListbean39++'+RequiredDocsbeanList);
        if(accRecP.Client_Group__c == 'Non Individual' || accRecP.Client_Group__c == 'JOINT AND SEVERAL CLIENT'){
        Wqp131ibean.refNo = accRecP.CASA_Reference_Number__c;
        System.debug('casa number 2'+accRecP.CASA_Reference_Number__c);
        }else{
            Wqp131ibean.refNo = accRecP.CASA_Reference_Number__pc;
        }
        Wqp131ibean.version = VersionNoP;
        Wqp131ibean.branch = userP[0].SiteCode__c;
        Wqp131ibean.user = userP[0].AB_Number__c;
        if(docNoP != null){
        Wqp131ibean.docNo = docNoP;
        }
        else{
            Wqp131ibean.docNo = '';
        }
        Wqp131ibean.requiredDocs = RequiredDocsbeanList;
        
        WQconfirmDocumentReceiptV2bean.nbsapdpi = nbsapdpibean;
        WQconfirmDocumentReceiptV2bean.wqp131i = wqp131ibean;
        requestBean.WQconfirmDocumentReceiptV2 = WQconfirmDocumentReceiptV2bean;
        return requestBean;  
    }
  
    
    /* Creates a bean from the response 
    * @param: HTTP Response
    * @return: Generatedocumentsv7_Resp_IB_v1 bean object
    * */
    
    public static WQconfirmDocumentReceiptV2_Resp_IB_v1 mapResponseFields(HttpResponse respP,Account accRec){
        System.debug('respP body'+respP.getBody());//To be removed
        
        WQconfirmDocumentReceiptV2_Resp_IB_v1 responseBean = (WQconfirmDocumentReceiptV2_Resp_IB_v1)JSON.deserialize(respP.getBody(),WQconfirmDocumentReceiptV2_Resp_IB_v1.class);
        WQconfirmDocumentReceiptV2_Resp_IB_v1.Wqp131o Wqp131oresp = new WQconfirmDocumentReceiptV2_Resp_IB_v1.Wqp131o();
        //Generatedocumentsv7_Resp_IB_v1.Results resultsbean = new Wqgetanalystcommentsv7_Resp_IB_v1.Results();
        
        //String docNum = WQacknowledgeDocumentsV1resp.DocNo;
        if(Wqp131oresp.msgNo == '0'){
            String successMessage = Wqp131oresp.msg;
        }
        responseBean.StatusMessage = respP.getStatus();
        responseBean.StatusCode = respP.getstatusCode();
        System.debug('WQconfirmDocumentReceiptV2 Service Success Response Bean after : ' + responseBean);//To be removed
        return responseBean;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @param: Status Code
    * @param: Status
    * @param: message
    * @return: WQconfirmDocumentReceiptV2_Resp_IB_v1 bean object
    * */
    public static WQconfirmDocumentReceiptV2_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        WQconfirmDocumentReceiptV2_Resp_IB_v1 responseBean = new WQconfirmDocumentReceiptV2_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('WQconfirmDocumentReceiptV2 Service Failed Response Bean: ' + responseBean);//To be removed
        return responseBean;
    }
}