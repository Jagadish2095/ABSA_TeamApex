/*
* Integration Utility  Bean for IBCancelServicev1 Service
* @author Lulu Rankwe
* @created 05-05-2020
*/

public class IBCancelServicev1_IU_v1 {
    
     /* Creates a request bean
     * @return: IBCancelServicev1_Req_IB_v1 bean object
     */
    public static IBCancelServicev1_Req_IB_v1 mapRequestFields(String accessAccount,String cancellationReason,String cancellationDesc,String replacedByTelBankin, String replacedByAtm,String replacedByMobile,String replacedByVendor,String replacedByDebitOrde, 
                                                               String replacedByPicknpay, String replacedByNothing,String siteCode, String teller,String supervisor){
        IBCancelServicev1_Req_IB_v1 reqBean = new IBCancelServicev1_Req_IB_v1();
        IBCancelServicev1_Req_IB_v1.nhp456i nhp456iBean  = new IBCancelServicev1_Req_IB_v1.nhp456i();
        IBCancelServicev1_Req_IB_v1.nbsapdpi nbsapdpiBean  = new IBCancelServicev1_Req_IB_v1.nbsapdpi();
        IBCancelServicev1_Req_IB_v1.nbsmsgi nbsmsgiBean  = new IBCancelServicev1_Req_IB_v1.nbsmsgi();
        IBCancelServicev1_Req_IB_v1.finalMsgId finalMsgIdBean = new IBCancelServicev1_Req_IB_v1.finalMsgId();

                                                                   

        nbsapdpiBean.channel = 'BDP';
        nbsapdpiBean.application = 'BDP';
        nbsapdpiBean.trace = 'Y';
        
        nbsmsgiBean.msgLanguage = 'E';
        nbsmsgiBean.msgTarget = 'STD';
        
        finalMsgIdBean.finalMsgClass = '';
        finalMsgIdBean.finalMsgCode = '';
        
        nhp456iBean.branch = siteCode;
        nhp456iBean.subBranch = siteCode;
        nhp456iBean.siteType = '034'; 
        nhp456iBean.teller = teller;
        nhp456iBean.manager = '999999';
        nhp456iBean.agencyCode = '034';
        nhp456iBean.workstation = '99';
        nhp456iBean.supervisor = supervisor;
        nhp456iBean.accessAccount = accessAccount;
        nhp456iBean.cancellationReason =cancellationReason;
        nhp456iBean.cancellationDesc = cancellationDesc;
        nhp456iBean.cancellationWhy = cancellationDesc;
        nhp456iBean.replacedByIbMobile = replacedByMobile;
        nhp456iBean.replacedByTelBankin = replacedByTelBankin;
        nhp456iBean.replacedByAtm = replacedByAtm;
        nhp456iBean.replacedByVendor = replacedByVendor;
        nhp456iBean.replacedByDebitOrde = replacedByDebitOrde;
        nhp456iBean.replacedByPicknpay = replacedByPicknpay;
        nhp456iBean.replacedByNothing = replacedByNothing;
        
        IBCancelServicev1_Req_IB_v1.IBcancelServiceV1 IBcancelServiceV1Bean = new IBCancelServicev1_Req_IB_v1.IBcancelServiceV1();
        IBcancelServiceV1Bean.nbsapdpi = nbsapdpiBean;
        IBcancelServiceV1Bean.nbsmsgi = nbsmsgiBean;
        IBcancelServiceV1Bean.nhp456i = nhp456iBean;
        
        nbsmsgiBean.finalMsgId = finalMsgIdBean;
        reqBean.IBcancelServiceV1 = IBcancelServiceV1Bean;
        
        return reqBean;     
    }

     /* Creates a bean from the response
     * @param: HTTP Response
     * @return: IBCancelServicev1_Res_IB_v1 bean object
     */
    public static IBCancelServicev1_Res_IB_v1 mapResponseFields(HttpResponse responseP){
        
		//System.debug('Create  Response body: ' + responseP.getBody());
        IBCancelServicev1_Res_IB_v1 responseBean = (IBCancelServicev1_Res_IB_v1)JSON.deserialize(responseP.getBody(), IBCancelServicev1_Res_IB_v1.class);       
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getstatusCode();
        
        System.debug('Create Response bean: ' + responseBean);
        return responseBean;

    }
    
     /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: IBCancelServicev1_Res_IB_v1 bean object
     * */
    public static IBCancelServicev1_Res_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        IBCancelServicev1_Res_IB_v1 responseBean = new IBCancelServicev1_Res_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
    
    
    
    
}