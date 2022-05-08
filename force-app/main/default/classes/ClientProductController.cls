/**
* @author Diksha Wasekar:Absa
* @description Controller for ClientPrductView Component
* @since 8/8/2019
* @Modified by Muvhuso Nekhubvi Absa 31/01/2020
* @Modified  Kabelo Aphane Absa 25 June 2021
*/
public class ClientProductController {
    /**
	* @description Method to test get Products List
	* @param AccountId
	* @return List<DisplayProducts>
	*/
    @AuraEnabled 
    public static List<DisplayProducts> getProductsList(string AccountId){
        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accountWrapperList;
        List <DisplayProducts> displayproductList = new List<DisplayProducts>();
        String errorMessage = '';
        Account account = new AccountsSelector().selectById(AccountId);
        
        //call to webservice by account's CIF Number 
        if(account.CIF__c !=null){
            CIgetAcctLinkedToClientCode_Resp_IB_v1 resp=  CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode('SALESFORCE',account.cif__c);
            if(resp != null){
                if(resp.statuscode == 200){
                    CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_Cip047o cls_Cip047oWrapper = resp.cip047o;
                    
                    List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = cls_Cip047oWrapper.outputTable;
                    accountWrapperList = new List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable>();
                    
                    for(CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj: accTypes){
                        system.debug('**accWrObj***' + accWrObj);
                        DisplayProducts dspr= new DisplayProducts();
                        dspr.product = accWrObj.product;
                        dspr.productType = accWrObj.productType;
                        dspr.accNor = accWrObj.oaccntnbr;
                        dspr.branch = accWrObj.branch;
                        String tempAccount = String.valueOf(accWrObj.oaccntnbr);
                        if(tempAccount != null){
                            dspr.productSummary = accWrObj.product + ' . ' + accWrObj.productType + '  ( ******' + tempAccount.right(4) + ')';
                        }else{
                            dspr.productSummary = accWrObj.product + ' . ' + accWrObj.productType;
                        }
                        displayproductList.add(dspr);
                    }
                }
                else{
                    errorMessage = 'Invalid CIF.Please check cif for the account';
                    throw new AuraHandledException('Error: '+errorMessage); 
                }
            }
        }
        else{
            errorMessage = 'CIF not found for the Account';   
            throw new AuraHandledException('Error: '+errorMessage); 
            
        }
        
        return displayproductList;
    }
    
    /**
	* @description Wrapper Class To display Client product Record Types
	*/
    public class DisplayProducts{
        /**
		* @description product 
		*/
        @auraEnabled public String product {get;set;}
        /**
		* @description productType 
		*/
        @auraEnabled public String productType {get;set;}
        /**
		* @description accNor 
		*/
        @auraEnabled public String accNor {get;set;}
        /**
		* @description count 
		*/
        @auraEnabled public Integer count {get;set;}
        /**
		* @description productSummary 
		*/
        @auraEnabled public String productSummary {get;set;}
        /**
		* @description branch 
		*/
        @auraEnabled public String  branch {get;set;}
        /**
        * @description Wrapper Class constructor
		*/
        public DisplayProducts(){
            product='';
            productType ='';
            count =0;
            accNor = '';
            productSummary = '';
            branch ='';
        }
        
    }
    /**
	* @description getContactInfoRequest
	* @param I_ACCOUNT
	* @return BAPI_SF_IF22_contract_Resp_IB_v1
	*/
    @AuraEnabled 
    public static BAPI_SF_IF22_contract_Resp_IB_v1 getContactInfoRequest(String I_ACCOUNT) {
        
        BAPI_SF_IF22_contract_Resp_IB_v1 response = BAPI_SF_IF22_contract_IH_v1.getBAPISFIF22ContactInfov1(I_ACCOUNT);
        return response; 
    }
    /**
	* @description getContactInfoRequest
	* @param accountNo
	* @return BAPI_SF_AccountFinInfo_Resp_IB_v1
	*/
    @AuraEnabled
	public static BAPI_SF_AccountFinInfo_Resp_IB_v1 getAccFinInformation(String accountNo) {
		UsersSelector user = new UsersSelector();
		String abNumber = user.selectById(UserInfo.getUserId()).AB_Number__c;
		BAPI_SF_AccountFinInfo_Resp_IB_v1 responseBean = BAPI_SF_AccountFinInfo_IH_v1.accountFinancialInformation(accountNo, abNumber);
        
		return responseBean;

	}
}