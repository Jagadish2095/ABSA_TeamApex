/**
 * @description       : FordAvafIndicator
 * @author            : Mradul Maheshwari
 * @last modified on  : 18-10-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-014878
 **/
public with sharing class FordAvafIndicatorCntr {
  /**
   * @description getContractDetailsfromServer
   * @author Mradul Maheshwari | 07-10-2021
   * @param iAccount
   * @return String
   **/
  @AuraEnabled
  public static String getContractDetailsfromServer(String iAccount) {
    User currentUser = new UsersSelector().selectById(UserInfo.getUserId());

    if (String.isBlank(currentUser.AB_Number__c)) {
      return 'Error: Blank value provided for currentUser AB_Number__c.';
    }

    if (String.isBlank(iAccount) || iAccount == null) {
      return 'Error: Blank value provided for Account Number';
    }
    BAPISFContrDetails_Resp_IB_v1 responseBean = BAPISFContrDetails_IH_v1.BAPISFContrDetails(
      iAccount,
      currentUser.AB_Number__c
    );

    if (responseBean == null) {
      return 'Error: Blank response received from service.';
    }
    if (responseBean.BAPI_SF_CONTR_DETAILS[0] != null) {
      if (
        responseBean.BAPI_SF_CONTR_DETAILS[0].E_CONTR_DETAILS.E_RESPONSE != 0
      ) {
        return 'Error: ' +          responseBean.BAPI_SF_CONTR_DETAILS[0].E_CONTR_DETAILS.E_RESPONSE_DESC;
      }
    }

    if (responseBean.BAPI_SF_CONTR_DETAILS.isEmpty()) {
      return 'Error: Unexpected response received. Service Response: ' +        json.serialize(responseBean);
    }

    if (responseBean.statusCode != 200) {
      return 'Error: ' + responseBean.message;
    }

    List<BAPISFContrDetails_Resp_IB_v1.BAPI_SF_CONTR_DETAILS> contractDetails = responseBean.BAPI_SF_CONTR_DETAILS;
    return JSON.serialize(contractDetails);
  }
}