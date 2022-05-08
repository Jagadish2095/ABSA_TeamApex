/*This is User Limits Lightning component Apex Controller Class
*
* @author Mashudu Raidimi
* @created 21/08/2020
*/

public class MobileIVRBeneficiaryController {
    /*Creates new mobiles beneficiary details based on client Id 
* @param clientAccountId
* return response message
*/    
    @AuraEnabled
    public static String addNewMobile(String clientAccountId,String cellNo , String ivrPaymentNo ,String description, String cellProvider){
        
        String cifKey =  getCIF(clientAccountId);
        
        addTBMobileBeneficiaries_Resp_IB_v1 responseBean = addTBMobileBeneficiaries_IH_v1.addTBMobileBeneficiaries(cifKey,cellNo,ivrPaymentNo,description,cellProvider); 
        
        if(responseBean!=null && responseBean.statusCode == 200){
            
            return JSON.serialize(responseBean);
        }
        return null;                               
    }
    /*Retrieves mobile's beneficiary details based on client Id 
* @param clientAccountId
* return mobile list
*/     
    @AuraEnabled
    public static String getNewMobile(String CIFKey){
        
        getMobileBeneficiaries_Resp_IB_v1 response = getMobileBeneficiaries_IH_v1.getMobileBeneficiaries(CifKey);
        
        if(response != null && response.statusCode == 200){
            if(response.mobileNumberList != null){
                return JSON.serialize(response.mobileNumberList);
            }
        }
        return null;
        
    }
    /*Get person's details based on client Id 
* @param clientAccountId
* return account CIF
*/
    @AuraEnabled 
    public static String getCIF(String clientAccountId){
        List<Account> beanL ;
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet,1);
        return accountList[0].CIF__c;  
    }
    /*Updates mobile's beneficiary details based on client Id 
* @param clientAccountId
* return response message
*/   
    @AuraEnabled
    public static String updateMobile(String clientAccountId,String cellNo , String ivrPaymentNo ,String description, String cellProvider){
        
        String cifKey =  getCIF(clientAccountId);
        
        updateTBMobileBeneficiaries_Resp_IB_v1 responseBean = updateTBMobileBeneficiaries_IH_v1.updateTBMobileBeneficiaries(cifKey,cellNo,ivrPaymentNo,description,cellProvider); 
        
        if(responseBean!=null && responseBean.statusCode == 200){
            return JSON.serialize(responseBean);
        }
        return null;                               
    }
    
}