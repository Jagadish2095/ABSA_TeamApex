/**
 * @description       : AccountEnquiry_IH_V1
 * @author            : Mradul Maheshwari
 * @last modified on  : 28-09-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-013340
 **/
public with sharing class AccountEnquiry_IH_V1 {
  public static final String INTEGRATION_SERVICE_NAME = 'Account Enquiry';

  /**
   * @description accountEnquiryRequest
   * @author Mradul Maheshwari | 14-09-2021
   * @param accountNumber
   * @param abNumber
   * @return AccountEnquiry_Resp_IB_V1
   **/
  public static AccountEnquiry_Resp_IB_V1 accountEnquiryRequest(
    String accountNumber,
    String abNumber
  ) {
    AccountEnquiry_Req_IB_V1 requestBean = AccountEnquiry_IU_V1.mapRequestFields(
      accountNumber,
      abNumber
    );
    AccountEnquiry_Resp_IB_V1 responseBean = (AccountEnquiry_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(
      requestBean,
      INTEGRATION_SERVICE_NAME,
      AccountEnquiry_Resp_IB_V1.class
    );

    return responseBean;
  }
}