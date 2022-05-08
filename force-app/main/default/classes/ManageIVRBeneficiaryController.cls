/**
* Controller for Manage IVR Beneficiary Lightning component
* @author   Mashudu Raidimi
* @created 2020-08-18
*/
public class ManageIVRBeneficiaryController {
 /*Retrieves a list of beneficiaty 
 * @param clientAccountId,srcAcc
 * return a list of beneficiary details
 */
    @AuraEnabled
    public static String mblistinstrpersourceacc(String clientAccountId ,String srcAcc){
        String cifKey = getCIF(clientAccountId);
        
        MBlistInstructionsPerSrcAccV1_Resp_IB_v1 responseBean = MBlistInstructionsPerSrcAccV1_IH_v1.mblistinstrpersourceaccv1(cifKey,srcAcc);
          
        if(responseBean != null){
        	if(responseBean.statusCode == 200){	
            	if(responseBean.MBlistInstructionsPerSourceAccV1Response != null){
                	if(responseBean.MBlistInstructionsPerSourceAccV1Response.mbs326o != null){
                    	if(responseBean.MBlistInstructionsPerSourceAccV1Response.mbs326o.instruction != null){
                        	return JSON.serialize(responseBean.MBlistInstructionsPerSourceAccV1Response.mbs326o.instruction);
                    	}
                        //added code
                       return  JSON.serialize(responseBean.MBlistInstructionsPerSourceAccV1Response.mbs326o.respDesc);
                	}
            	}
        	}
         }
       
        return null;

        
    }
 /*Update an IVR beneficiary 
 * @param beneficiaryName,trgAccNumber
 * return successfully string message
 */
    @AuraEnabled
    public static String updateBeneficiary(String beneficiaryName,String trgAccNumber,String trgAccType, String trgBranchCode,String ivrCustNo, String clientAccountId,
                                           String srcAcc,String tieb,String instrNo,String srcAccType, String srcStmtRef, String trgStmtRef){
        
        String cif = getCIF(clientAccountId);
        system.debug('Brach code length : '+trgBranchCode.length());
        
        if(trgBranchCode.length() > 6){
        String trgBranchCodeId = '0';
        Set<Id> branchCodeSet = new Set<Id>();
        branchCodeSet.add(trgBranchCode);
        List<Lookup__c> lookupList = new LookupsSelector().selectById(branchCodeSet); 
                
                if(lookupList != null && lookupList.size() > 0) {
                    trgBranchCode = lookupList[0].Branch_Code__c;
                    
                }
        }
        Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBupdateInstructionV1_IH_v1.updateIVRbeneficiary(beneficiaryName, trgAccNumber, trgAccType,  trgBranchCode, ivrCustNo, cif, srcAcc,tieb,instrNo, srcAccType,srcStmtRef,trgStmtRef) ;
       
        MBupdateInstructionV1_Resp_IB_v1 responseBean = (new List<MBupdateInstructionV1_Resp_IB_v1>(responseMap.keySet()))[0];
        
        if(responseBean != null & responseBean.statusCode ==200){
            
           MBupdateInstructionV1_Resp_IB_v1.MBupdateInstructionV1Response cls_retrieveTransactionInqWrapper = responseBean.MBupdateInstructionV1Response;
           MBupdateInstructionV1_Resp_IB_v1.Mbp300o Mbp300o = cls_retrieveTransactionInqWrapper.mbp300o;
            
            //return Mbp300o.respDesc;
            return JSON.serialize(Mbp300o);
        }
        return null;
        
    }
 /*Add an IVR beneficiary 
 * @param beneficiaryName,trgAccNumber
 * return successfully string message
 */
    @AuraEnabled
    public static String addBeneficiary(String  productTypeP, String beneficiaryNameP, String branchCodeP, String targetAccP, String accountNumberP,String accountTypeP ,String accessAccountP,String beneficiaryReferenceP,String ownReferenceP){
        
        CreateInstruction_Resp_IB_v1 resp = CreateInstruction_IH_v1.MBcreateInstruction(productTypeP, beneficiaryNameP, targetAccP, branchCodeP, accountNumberP,accountTypeP,accessAccountP, beneficiaryReferenceP, ownReferenceP);
        
        if(resp != null){//new changes added
            if(resp.statusCode == 200){
                return JSON.serialize(resp);
            }
        }
    
    	return null;
        
    }
 /*Delete an IVR beneficiary based on client Id 
 * @param clientAccountId
 * return successfully string message
 */
    @AuraEnabled
    public static string deleteBeneficiary(String clientAccountId,String tieb,String instrNo){
        
        String cif = getCIF(clientAccountId);
        
        
        Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = MBdeleteInstructionV2_IH_v1.MBdeleteInstructionForIVR(cif,tieb,instrNo);
        MBdeleteInstructionV2_Resp_IB_v1 responseBean = (new List<MBdeleteInstructionV2_Resp_IB_v1>(responseMap.keySet()))[0];
        
        MBdeleteInstructionV2_Resp_IB_v1.Mbp306o respData = responseBean.MBdeleteInstructionV2Response.Mbp306o;
                    
                    if(respData != null) {
                        //Beneficiary removed successfull
                        if(respData.respCode == '0') {
                            return respData.instrRefName + ' Successfully Removed'; 
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
    
    @AuraEnabled
    public static Map<String,String> caseClose(String caseId){
        Map<String,String> returnMap = new Map<String,String>();
        try{
            Update new Case(Id=caseId, Status='Closed');
            returnMap.put('isSuccess', 'true');
        }catch(exception ex){            
            returnMap.put('isSuccess', 'false');
            returnMap.put('errorMessage', ex.getMessage());           
        }
      return returnMap;
      
    }
    
    @AuraEnabled
    public static Lookup__c getBankIdByName(String bankName) {

		List<Lookup__c> lookupList = new LookupsSelector().selectByName(BankName);    
        
        if(lookupList != null && lookupList.size() > 0) {
            return lookupList[0];
        } else {
            return null;
        }
        
    }

}