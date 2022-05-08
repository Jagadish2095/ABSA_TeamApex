/**
 * @description       :
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-02
 * @last modified by  : PaulJohn.duRand@absa.africa
**/
public class CasaRiskProfileClient {
   private CASARiskProfileClientV7_Req_IB_v1 requestBean;
   private Account account;

  /**
  * @description
  * @author PaulJohn.duRand@absa.africa | 2021-08-02
  * @param objId
  * @return string
  **/
  public string callService(string objId){
    String oppId =  BranchFunctions.getOpportunityId(objId);
    String accountId =  BranchFunctions.getAccountId(objId);
    requestBean = CASARiskProfileClientV7_Req_IB_v1.GetInstance();
    populateClientDetails(accountId);
    populateProductDetails(oppId);
    String response = CASARiskProfileClientV7_IH_v1.CASARiskProfileClientRiskStatus(requestBean);
    account.CASA_Risk_Status__c =  (!response.contains('Error')) ? response : '';
       if (Schema.sObjectType.Account.isUpdateable()) {
           update account;
       }
       return response;
  }

/**
* @description
* @author PaulJohn.duRand@absa.africa | 2021-08-02
* @param accountId
**/
private void populateClientDetails(string accountId){
    account = [Select Id,Client_Type__c,ID_Type__pc,Client_Group__c,CASA_Reference_Number__pc,Occupation_Category__pc,Occupation_Status__pc,Income_Source__pc From Account where Id = :accountId ];
    requestBean = CASARiskProfileClientV7_Req_IB_v1.GetInstance();

    string clientType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
        'CIFCodesList',
        'Customertype',
        account.Client_Type__c,
        StringConstants.OUTBOUND_RECORD_TYPE
    );
    string idType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
        'CIFCodesList',
        'Idtype',
        account.ID_Type__pc,
        StringConstants.OUTBOUND_RECORD_TYPE
    );
    requestBean.WQriskProfileClientV7Request.companyForm = clientType + idType;
    requestBean.WQriskProfileClientV7Request.customerTypeCode = account.Client_Group__c;
    requestBean.WQriskProfileClientV7Request.customerSourceRefID = account.CASA_Reference_Number__pc;
    requestBean.WQriskProfileClientV7Request.customerSourceUniqueId = account.CASA_Reference_Number__pc;
    requestBean.WQriskProfileClientV7Request.occupation = account.Occupation_Category__pc;
    requestBean.WQriskProfileClientV7Request.employmentStatus = account.Occupation_Status__pc;
    CASARiskProfileClientV7_Req_IB_v1.AbsaSourceOfIncomeTable sofEntry = new CASARiskProfileClientV7_Req_IB_v1.AbsaSourceOfIncomeTable();
    sofEntry.absaSourceOfIncome = account.Income_Source__pc;
    requestBean.WQriskProfileClientV7Request.absaSourceOfIncomeTable.add(sofEntry);
}

  /**
  * @description
  * @author PaulJohn.duRand@absa.africa | 2021-08-02
  * @param oppId
  **/
  private void populateProductDetails(string oppId){
    OpportunityLineItemsSelector oppLineIteminstnce = new OpportunityLineItemsSelector();
    List<OpportunityLineItem> oppLineItem = oppLineIteminstnce.selectByOpportunityId(oppId);
    List<String> lineItemIds = new List<String>();
    for (OpportunityLineItem item : oppLineItem) {
        lineItemIds.add(item.Id);
    }
    List<Product2> p = [
        SELECT ProductCode, Price_Scheme_Code__c
        FROM Product2
        WHERE Id IN (SELECT Product2Id FROM OpportunityLineItem WHERE Id IN :lineItemIds AND ProductCode != NULL)
        WITH SECURITY_ENFORCED
    ];
    for (Product2 item : p) {
        CASARiskProfileClientV7_Req_IB_v1.ProductCodeTable prodEntry = new CASARiskProfileClientV7_Req_IB_v1.ProductCodeTable();
        CASARiskProfileClientV7_Req_IB_v1.SubProductCodeTable subProdEntry = new CASARiskProfileClientV7_Req_IB_v1.SubProductCodeTable();
        prodEntry.productCode = item.ProductCode;
        subProdEntry.subProductCode = item.Price_Scheme_Code__c;
        requestBean.WQriskProfileClientV7Request.productCodeTable.add(prodEntry);
        requestBean.WQriskProfileClientV7Request.subProductCodeTable.add(subProdEntry);
    }
  }
}