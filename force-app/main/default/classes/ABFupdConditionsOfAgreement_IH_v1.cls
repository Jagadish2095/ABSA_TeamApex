/*
* Integration Handler for get conditions of agreement
* @author Almas Aleem:Absa  
* @created 2020-12-02
*/
public class ABFupdConditionsOfAgreement_IH_v1 {
    
public static final String INTEGRATION_SERVICE_NAME = 'ABFupdConditionsOfAgreement';
   
    public static ABFupdConditionsOfAgreement_Resp_IB_v1 GetABFupdConditions(User user,String acctNumber,ABFupdAccountStatusV1_Resp_IB_V1 ABFresponse,String landlordWaiverInd,String insuranceInd,String elecTransferInd,String contractSigned,
                                                    Integer mandateNum,Integer tellerNum) {
        
          ABFupdConditionsOfAgreement_Req_IB_v1 requestBean = ABFupdConditionsOfAgreement_IU_v1.mapRequestFields(user,acctNumber,ABFresponse,landlordWaiverInd, insuranceInd, elecTransferInd,contractSigned,
                                                     mandateNum,tellerNum); //request mapping
          system.debug('requestBean'+requestBean);
        
          ABFupdConditionsOfAgreement_Resp_IB_v1 responseBean = (ABFupdConditionsOfAgreement_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ABFupdConditionsOfAgreement_Resp_IB_v1.class); //service callout
        return responseBean;
    }
}