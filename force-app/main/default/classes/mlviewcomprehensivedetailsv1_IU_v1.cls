public class mlviewcomprehensivedetailsv1_IU_v1 {
/* Creates a request bean
     * @return: mlviewcomprehensivedetailsv1_Req_IB_v1 bean object
     */
    public static mlviewcomprehensivedetailsv1_Req_IB_v1 mapRequestFields(String accountNumber) {
        UsersSelector userSelectorRef = new UsersSelector();
          User loggedinUser = userSelectorRef.selectById(UserInfo.getUserId());
              //[SELECT Id,SiteCode__c,Teller_Operator_Code__c,SiteType__c,Supervisor__c FROM User Where id=:userinfo.getUserId()];
        
        mlviewcomprehensivedetailsv1_Req_IB_v1 requestBean = new mlviewcomprehensivedetailsv1_Req_IB_v1();
        requestBean.MLviewComprehensiveDetailsV1 = new mlviewcomprehensivedetailsv1_Req_IB_v1.MLviewComprehensiveDetailsV1();
        requestBean.MLviewComprehensiveDetailsV1.nbsapdpi = new mlviewcomprehensivedetailsv1_Req_IB_v1.nbsapdpi();        
        requestBean.MLviewComprehensiveDetailsV1.mlp047i  = new mlviewcomprehensivedetailsv1_Req_IB_v1.mlp047i(); 
         requestBean.MLviewComprehensiveDetailsV1.nbsapdpi.trace ='Y';
         requestBean.MLviewComprehensiveDetailsV1.nbsapdpi.application ='BDP';
         requestBean.MLviewComprehensiveDetailsV1.nbsapdpi.channel ='BDP';
        
        requestBean.MLviewComprehensiveDetailsV1.mlp047i.accn = accountNumber; //'8052424088';
        requestBean.MLviewComprehensiveDetailsV1.mlp047i.functi ='R';
        requestBean.MLviewComprehensiveDetailsV1.mlp047i.prtell = loggedinUser.Teller_Operator_Code__c; //'999999';
        requestBean.MLviewComprehensiveDetailsV1.mlp047i.debug ='N';
        requestBean.MLviewComprehensiveDetailsV1.mlp047i.prsite = loggedinUser.SiteCode__c;// '034';
        requestBean.MLviewComprehensiveDetailsV1.mlp047i.func ='ONLI';
        requestBean.MLviewComprehensiveDetailsV1.mlp047i.tranIn ='MBDP';
        requestBean.MLviewComprehensiveDetailsV1.mlp047i.continue_sfdc ='0';
            
            
        return requestBean;
        }
      /* Creates a bean from the response 
* @param: HTTP Response
* @return: mlviewcomprehensivedetailsv1_Resp_IB_v1 bean object
* */
    
    public static mlviewcomprehensivedetailsv1_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        System.debug('respP body'+respP.getBody());//To be removed
        mlviewcomprehensivedetailsv1_Resp_IB_v1 responseBean = (mlviewcomprehensivedetailsv1_Resp_IB_v1)JSON.deserialize(respP.getBody(),mlviewcomprehensivedetailsv1_Resp_IB_v1.class);
        mlviewcomprehensivedetailsv1_Resp_IB_v1.mlviewcomprehensivedetailsv1Response WQgetAnalystCommentsresp = new mlviewcomprehensivedetailsv1_Resp_IB_v1.mlviewcomprehensivedetailsv1Response();
        responseBean.StatusMessage = respP.getStatus();
        responseBean.StatusCode = respP.getstatusCode();
        System.debug('mlviewcomprehensivedetailsv1 Service Success Response Bean after : ' + responseBean);//To be removed
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
* @param: Status Code
* @param: Status
* @param: message
* @return: mlviewcomprehensivedetailsv1_Resp_IB_v1 bean object
* */
    public static mlviewcomprehensivedetailsv1_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        mlviewcomprehensivedetailsv1_Resp_IB_v1 responseBean = new mlviewcomprehensivedetailsv1_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('mlviewcomprehensivedetailsv1 Service Failed Response Bean: ' + responseBean);//To be removed
        return responseBean;
    }
    
}