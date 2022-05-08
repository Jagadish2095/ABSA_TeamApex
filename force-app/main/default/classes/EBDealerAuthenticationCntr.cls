/**
* @description controller class for DealerAuthenticationCustomerVerification
* @author manideep kenche
* @created 2021/10/21
* @work W-014039
*/

public class EBDealerAuthenticationCntr {
    
    
    
    /*** @description Fetch Dealer Information
* @param dCode
* @param abNumber
* @return String
*/
    @AuraEnabled
    public static String getDealerInfo(String dCode,String abNumber){
        
        AuthenticateDealer_Resp_IB_v1 response = AuthenticateDealer_IH_v1.AuthenticateDealer(dCode,abNumber);
        if(response?.BAPI_SF_DLR_DETAILS?.E_DLR_DETAILS == NULL){
            throw new AuraHandledException(
                'Error: Service returned no values for dealer details'
            );
        }
        return JSON.serialize(response);
        
    }
    
    /*** @description Fetch Contract Information
* @param accNumber
* @param abNumber
* @return String
*/
    @AuraEnabled
    public static String getContractInfo(String accNumber,String abNumber){
        list<String> acclist = new list<String>{accNumber};
            BAPISFAccntDescr_Resp_IB_v1 response = BAPISFAccntDescr_IH_v1.BAPISFAccntDescr(accList,abNumber);
        if(response?.BAPI_SF_ACCNT_DESCR?.ACCOUNT_RESP == NULL){
            throw new AuraHandledException(
                'Error: Service returned no values for Contract details'
            );
        }
        return JSON.serialize(response);
        
    }
    
    /*** @description Fetch Customer Information
* @param inpClientCode
* @param clntAcctNbr
* @return String
*/
    @AuraEnabled
    public static String getCustomerInfo(String inpClientCode,String clntAcctNbr){
        
        
        CIgetClientDetailsV12_Resp_IB_v1 response = CIgetClientDetailsV12_IH_v1.CIgetClientDetailsV12('0',inpClientCode,clntAcctNbr,'Gateway','BDP');
        return JSON.serialize(response);
    }
}