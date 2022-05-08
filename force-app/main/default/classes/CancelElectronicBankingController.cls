/* Lightning cmp controller for Cancel Electronic Banking (Telephonic) 
 * Author: Lulu Rankwe
 * Date :  05/05/2020 
 */

public class CancelElectronicBankingController {
 
  /**
	* Cancel electronic Banking 
	* @Param accessAccount, ...
	* return string(result)
*/
    @AuraEnabled
    public static String cancelService(String accessAccount,String cancellationReason,String cancellationDesc,String replacedByTelBankin, String replacedByAtm,String replacedByMobile, String replacedByVendor,String replacedByDebitOrde, String replacedByPicknpay, String replacedByNothing){                        
        String output  = '';
        String errorMessage;
        String cancellationReasonTransl, siteCode, teller, supervisor;
        
        cancellationReasonTransl = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.IBCANCELSERVICE_TRANSL, 'Reason', cancellationReason, StringConstants.OUTBOUND_RECORD_TYPE); 
        User currentUser =  new UsersSelector().selectById(Userinfo.getUserId());
        siteCode = currentUser.SiteCode__c;  
        supervisor = currentUser.Supervisor__c;  
        teller = currentUser.Teller_Operator_Code__c;  
        
        IBCancelServicev1_Res_IB_v1 response = IBCancelService_IH_v1.cancelService(accessAccount,cancellationReasonTransl,cancellationDesc,replacedByTelBankin,replacedByAtm,replacedByMobile,replacedByVendor,replacedByDebitOrde,replacedByPicknpay,replacedByNothing,siteCode,teller,supervisor);
        IBCancelServicev1_Res_IB_v1.nbsmsgo  nbsmsgoBean = response.IBcancelServiceV1Response.nbsmsgo;
        IBCancelServicev1_Res_IB_v1.msgEntry msgEntryBean = nbsmsgoBean.msgEntry;
        
        if(response.statuscode == 200){  
            if(response.IBcancelServiceV1Response.nbsmsgo !=null ){
                if(nbsmsgoBean.nbrUserMsgs == '0' && nbsmsgoBean.nbrUserErrs == '0')  {
                    output =  'SUCCESSFUL PROCESS';
                }else{
                    output =  msgEntryBean.msgTxt;  
                }
                
            }                        
            
        }

        return output;
    }
    
    

    
        
}