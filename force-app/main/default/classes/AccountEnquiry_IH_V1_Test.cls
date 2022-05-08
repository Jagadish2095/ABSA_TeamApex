/**
 * @description       : AccountEnquiry_IH_V1_Test
 * @author            : Mradul Maheshwari
 * @last modified on  : 28-09-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-013340
 **/
@isTest
public with sharing class AccountEnquiry_IH_V1_Test {
  public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AccountEnquiry_V1';

  public static final String STATIC_RESOURCE_NAME_MOCK_NEGATIVE = 'Mock_Negative_AccountEnquiry_V1';

  @TestSetup
  static void makeData() {
    IntegrationTestDataFactory.insertIntegrationSettings(
      StringConstants.JITTERBIT2,
      new List<String>{ AccountEnquiry_IH_V1.INTEGRATION_SERVICE_NAME }
    );
  }

  @IsTest
  static void testPositive() {
    // Set mock callout class
    Test.setMock(
      HttpCalloutMock.class,
      Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
        StringConstants.POSITIVE_STRING,
        STATIC_RESOURCE_NAME_MOCK_POSITIVE
      )
    );

    Test.startTest();

    AccountEnquiry_Resp_IB_V1 responseBean = callHandlerMethod();
    System.assertEquals(200, responseBean.statusCode, 'Assert Passed');

    Test.stopTest();
  }

  private static AccountEnquiry_Resp_IB_V1 callHandlerMethod() {
    AccountEnquiry_Req_IB_V1 dummyBean = AccountEnquiry_Req_IB_V1.createDummyRequest();
    AccountEnquiry_Resp_IB_V1 responseBean = AccountEnquiry_IH_V1.accountEnquiryRequest(
      String.valueOf(dummyBean.MLB857I.MLB857I_INPUT_AREA.MLB857I_ACCT_NUMBER),
      dummyBean.MLB857I.MLB857I_INPUT_AREA.MLB857I_USER_ID
    );
    return responseBean;
  }
}