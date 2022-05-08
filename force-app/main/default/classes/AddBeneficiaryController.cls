/**
* This is AddBeneficiary Lightning component Apex Controller Class
*
* @author  Chandra Bhushan Singh : ABSA
* @version v1.0
* @since   2020-12-11
*/


public class AddBeneficiaryController {
    
    /**
	* Retrieves retrieves client account account number based on AccountId
	*
	* @param   clientAccountId
	*return list of account
	* 
	*/ 
    
    @AuraEnabled
    public static String getAccountDetails(String clientAccountId){
        
        String errorMessage = '';
        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accountWrapperList;
        Set<Id> accIdSet = new Set<Id>();
        accIdSet.add(clientAccountId);
        List<Account> accountList = new AccountsSelector().selectById(accIdSet,1);
        if(accountList.size() > 0){
            if(String.isNotBlank(accountList[0].CIF__c)){
                CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(StringConstants.SALESFORCE_STRING,accountList[0].CIF__c);
                
                if(response.statusCode == 200){
                    CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_Cip047o cls_Cip047oWrapper = response.cip047o;
                    
                    List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = cls_Cip047oWrapper.outputTable;
                    System.debug('---accTypes------'+accTypes);
                    accountWrapperList = new List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable>();
                    
                    for(CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj: accTypes){
                        accountWrapperList.add(accWrObj);
                    }
                    return JSON.serialize(accountWrapperList);
                } else{
                    errorMessage = 'CIF not found for the Account';
                }
            }
        }
        return null ;
    }
    
    /*Creates a beneficiary
	*@param   productType,beneficiaryName,branchCode,targetAcc,accountNumber,accountType,beneficiaryReference,ownReference
	*return string of responseMessage
	*/ 
    
    @AuraEnabled
    public static String addBeneficiary(String  productTypeP, String beneficiaryNameP, String branchCodeP, String targetAccP, String accountNumberP,String accountTypeP ,String accessAccountP,String beneficiaryReferenceP,String ownReferenceP){
        CreateInstruction_Resp_IB_v1 resp = CreateInstruction_IH_v1.MBcreateInstruction(productTypeP, beneficiaryNameP, targetAccP, branchCodeP, accountNumberP,accountTypeP,accessAccountP, beneficiaryReferenceP, ownReferenceP);
        if(resp != null){
            if(resp.statusCode == 200){
                return resp.respDesc;
            }
        }
        return null;
    }
    
}