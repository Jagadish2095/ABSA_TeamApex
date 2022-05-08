/**
 * Test Class for BusinessTrace Service
 * @author Englarmerdge Mongwe
 * @created 2021-01-08
 */
@IsTest
public class BusinessTrace_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"BusinessTraceResponse":{"BusinessTraceResult":"<?xml version=\'1.0\' encoding=\'UTF-8\'?><KreditSearchTransaction xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\' xsi:noNamespaceSchemaLocation=\'http://kreditlinkxp.kredit.co.za/KreditSearch/KreditSearchTransaction.xsd\'><Header><TxnId>KMSG</TxnId><Function>CORP</Function><ClientNumber>12</ClientNumber><OperatorId>ABSACT</OperatorId><TxnType>31</TxnType><TxnStatus>01</TxnStatus><Error1></Error1><Error2></Error2><Error3></Error3><Error4></Error4><Error5></Error5><BureauReference></BureauReference><ClientReference></ClientReference><InquiryDate>080121</InquiryDate><InquiryTime>071048</InquiryTime><EchoData>ABSA TRACE</EchoData></Header><CompanySearch><Request><RegIDIndicator></RegIDIndicator><RegistrationIDNumber></RegistrationIDNumber><BusinessName>EXPERIAN</BusinessName><SearchWord1>EXPERIAN</SearchWord1><SearchWord2></SearchWord2><SearchWord3></SearchWord3><StartAlpha></StartAlpha><KIFile>K</KIFile><JudgementFile>N</JudgementFile><ListedCoyFile>Y</ListedCoyFile><SubsidiaryFile>N</SubsidiaryFile><CIPROFile>Y</CIPROFile><KreditChequeFile>N</KreditChequeFile><MaxResults></MaxResults><StartKimNo></StartKimNo></Request><Results><EndOfResults>Y</EndOfResults><NumberOfResults>5</NumberOfResults><ResultSet><ResultLine><HeadingIndicator></HeadingIndicator><SourceFile>35</SourceFile><KIInternalNumber>5835437</KIInternalNumber><CompanyName>EXPERIAN</CompanyName><CompanyIndicators>FE</CompanyIndicators><ReportDate>20210108</ReportDate><RelatedInfo>BRYANSTON</RelatedInfo><FileIndicators>C</FileIndicators><RegistrationNumber></RegistrationNumber><EntityType></EntityType><Status>Active</Status><NJO>O</NJO><AddInfo></AddInfo></ResultLine><ResultLine><HeadingIndicator></HeadingIndicator><SourceFile>35</SourceFile><KIInternalNumber>335496</KIInternalNumber><CompanyName>EXPERIAN</CompanyName><CompanyIndicators>FDTBE</CompanyIndicators><ReportDate>20210108</ReportDate><RelatedInfo></RelatedInfo><FileIndicators>C</FileIndicators><RegistrationNumber>199300454210</RegistrationNumber><EntityType>Registered as External to SA</EntityType><Status>AR Deregistration Final</Status><NJO>O</NJO><AddInfo></AddInfo></ResultLine><ResultLine><HeadingIndicator></HeadingIndicator><SourceFile>35</SourceFile><KIInternalNumber>7729041</KIInternalNumber><CompanyName>EXPERIAN</CompanyName><CompanyIndicators>F</CompanyIndicators><ReportDate>20210108</ReportDate><RelatedInfo>BRYANSTON</RelatedInfo><FileIndicators>C</FileIndicators><RegistrationNumber></RegistrationNumber><EntityType></EntityType><Status>Active</Status><NJO>O</NJO><AddInfo></AddInfo></ResultLine><ResultLine><HeadingIndicator></HeadingIndicator><SourceFile>35</SourceFile><KIInternalNumber>6854994</KIInternalNumber><CompanyName>EXPERIAN</CompanyName><CompanyIndicators>FE</CompanyIndicators><ReportDate>20210108</ReportDate><RelatedInfo>JACO.PRETORIUS@GMAIL</RelatedInfo><FileIndicators>C</FileIndicators><RegistrationNumber></RegistrationNumber><EntityType></EntityType><Status>Active</Status><NJO>O</NJO><AddInfo></AddInfo></ResultLine><ResultLine><HeadingIndicator></HeadingIndicator><SourceFile>25</SourceFile><KIInternalNumber>692453</KIInternalNumber><CompanyName>EXPERIAN</CompanyName><CompanyIndicators>FD</CompanyIndicators><ReportDate>20210106</ReportDate><RelatedInfo>SUNNINGHILL</RelatedInfo><FileIndicators>R</FileIndicators><RegistrationNumber>199300454210</RegistrationNumber><EntityType>Registered as External to SA</EntityType><Status>Deregistration Process</Status><NJO></NJO><AddInfo></AddInfo></ResultLine></ResultSet></Results></CompanySearch></KreditSearchTransaction>"}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{BusinessTrace_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        businessTraceTestMock();

        Test.startTest();

        BusinessTrace_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    public static void businessTraceTestMock() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
    }

    private static BusinessTrace_Resp_IB_v1 callHandlerMethod() {
        BusinessTrace_Req_IB_v1 dummyBean = BusinessTrace_Req_IB_v1.createDummyRequest();
        BusinessTrace_Resp_IB_v1 responseBean = BusinessTrace_IH_v1.BusinessTrace(dummyBean.BusinessTrace.BusinessName, dummyBean.BusinessTrace.SearchWord1, dummyBean.BusinessTrace.SearchWord2, dummyBean.BusinessTrace.SearchWord3);
        return responseBean;
    }
}