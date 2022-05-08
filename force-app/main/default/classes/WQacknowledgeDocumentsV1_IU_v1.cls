/**
* Apex Integration Utility Bean class for WQacknowledgeDocumentsV1 service
* @author  Anka Ganta : Absa
* @since   2020-04-15
*
**/
public class WQacknowledgeDocumentsV1_IU_v1 {
     /* Creates a Request Bean from the Account 
    * @param: List of Case objects
    * @return: WQacknowledgeDocumentsV1_Req_IB_v1 bean object
    * */
    public static WQacknowledgeDocumentsV1_Req_IB_v1 mapRequestFields(Account accRecP,List<String> docCodesListP,String docNoP,String VersionNoP){
        WQacknowledgeDocumentsV1_Req_IB_v1 requestBean = new WQacknowledgeDocumentsV1_Req_IB_v1();
        WQacknowledgeDocumentsV1_Req_IB_v1.Nbsapdpi Nbsapdpibean  = new WQacknowledgeDocumentsV1_Req_IB_v1.Nbsapdpi();
        WQacknowledgeDocumentsV1_Req_IB_v1.Wqp132i Wqp132ibean  = new WQacknowledgeDocumentsV1_Req_IB_v1.Wqp132i();
        
        List<WQacknowledgeDocumentsV1_Req_IB_v1.RequiredDocs> RequiredDocsbeanList = new List<WQacknowledgeDocumentsV1_Req_IB_v1.RequiredDocs>();
        WQacknowledgeDocumentsV1_Req_IB_v1.WQacknowledgeDocumentsV1 WQacknowledgeDocumentsV1bean  = new WQacknowledgeDocumentsV1_Req_IB_v1.WQacknowledgeDocumentsV1();
        
        
        Usersselector us = new Usersselector();
        List<User> userP = us.userwithSiteCode(UserInfo.getUserId());
        
        Nbsapdpibean.channel = 'ESP';
        Nbsapdpibean.application = 'ESP';
        Nbsapdpibean.trace = 'Y';
        System.debug('docCodesListP++'+docCodesListP);
        for(String docCodeInput:docCodesListP){
            WQacknowledgeDocumentsV1_Req_IB_v1.RequiredDocs RequiredDocsbean  = new WQacknowledgeDocumentsV1_Req_IB_v1.RequiredDocs();
            System.debug('docCodeInput++'+docCodeInput);
            if(docCodeInput != null){
                RequiredDocsbean.docCode = docCodeInput;
            }
               else{
                   RequiredDocsbean.docCode = '';
               }
            RequiredDocsbean.received = 'Y';
            RequiredDocsbean.inOrder = 'Y';
            RequiredDocsbean.nonConfirm = '';
            RequiredDocsbeanList.add(RequiredDocsbean);
            System.debug('RequiredDocsbean++'+RequiredDocsbean);
            System.debug('RequiredDocsbeanList36++'+RequiredDocsbeanList);
        }
        
        System.debug('RequiredDocsListbean39++'+RequiredDocsbeanList);
        if(accRecP.Client_Group__c == 'Non Individual' || accRecP.Client_Group__c == 'JOINT AND SEVERAL CLIENT'){
        Wqp132ibean.refNo = accRecP.CASA_Reference_Number__c;
        System.debug('casa number 2'+accRecP.CASA_Reference_Number__c);
        }else{
          Wqp132ibean.refNo = accRecP.CASA_Reference_Number__pc;  
        }    
        Wqp132ibean.version = VersionNoP;
        Wqp132ibean.branch = userP[0].SiteCode__c;
        Wqp132ibean.user = userP[0].AB_Number__c;
        if(docNoP != null){
        Wqp132ibean.docNo = docNoP;
        }
        else{
            Wqp132ibean.docNo = '';
        }
        Wqp132ibean.requiredDocs = RequiredDocsbeanList;
        
        WQacknowledgeDocumentsV1bean.nbsapdpi = nbsapdpibean;
        WQacknowledgeDocumentsV1bean.wqp132i = wqp132ibean;
        requestBean.WQacknowledgeDocumentsV1 = WQacknowledgeDocumentsV1bean;
        return requestBean;  
    }
  
    
    /* Creates a bean from the response 
    * @param: HTTP Response
    * @return: Generatedocumentsv7_Resp_IB_v1 bean object
    * */
    
    public static WQacknowledgeDocumentsV1_Resp_IB_v1 mapResponseFields(HttpResponse respP,Account accRec){
        System.debug('respP body'+respP.getBody());//To be removed
        
        WQacknowledgeDocumentsV1_Resp_IB_v1 responseBean = (WQacknowledgeDocumentsV1_Resp_IB_v1)JSON.deserialize(respP.getBody(),WQacknowledgeDocumentsV1_Resp_IB_v1.class);
        WQacknowledgeDocumentsV1_Resp_IB_v1.Wqp132o Wqp132oV1resp = new WQacknowledgeDocumentsV1_Resp_IB_v1.Wqp132o();
        //Generatedocumentsv7_Resp_IB_v1.Results resultsbean = new Wqgetanalystcommentsv7_Resp_IB_v1.Results();
        
        //String docNum = WQacknowledgeDocumentsV1resp.DocNo;
        if(Wqp132oV1resp.msgNo == '0'){
            String successMessage = Wqp132oV1resp.msg;
        }
        responseBean.StatusMessage = respP.getStatus();
        responseBean.StatusCode = respP.getstatusCode();
        System.debug('WQacknowledgeDocumentsV1 Service Success Response Bean after : ' + responseBean);//To be removed
        //accRec.CASA_Analyst_Comments__c = respP.commentDesc;
       
       
        return responseBean;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @param: Status Code
    * @param: Status
    * @param: message
    * @return: WQacknowledgeDocumentsV1_Resp_IB_v1 bean object
    * */
    public static WQacknowledgeDocumentsV1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        WQacknowledgeDocumentsV1_Resp_IB_v1 responseBean = new WQacknowledgeDocumentsV1_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('WQacknowledgeDocumentsV1 Service Failed Response Bean: ' + responseBean);//To be removed
        return responseBean;
    }
}