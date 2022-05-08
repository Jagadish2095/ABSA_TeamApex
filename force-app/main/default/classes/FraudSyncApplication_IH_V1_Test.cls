/*
 * Integration Handler test class for FraudSyncApplication Service
 * @author André Pietersen
 * @created 2020-11-04
 */
@isTest
public class FraudSyncApplication_IH_V1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"applicationDateTime": "2020-07-12T08:30:09+10:00","header": {"channel": {             "channelDetails": [                 {                     "fieldName": "SITE_CODE",                     "value": "9082"                 },                 {                     "fieldName": "USER_ID",                     "value": "123456"                 },                 {                     "fieldName": "USER_TYPE",                     "value": "Employee"                 },                 {                     "fieldName": "BRANCH_NAME",                     "value": "cresta"                 },                 {                     "fieldName": "IP_ADDRESS",                     "value": "190.90.92"                 },                 {                     "fieldName": "TERMINAL_ID",                     "value": "23456"                 },                 {                     "fieldName": "OS",                     "value": "android"                 }             ],             "channelType": "BRANCH",             "channelName": "DSP"         },         "channelReference": "0986532222"     },     "productDetails": {         "campaignReference": 98765,         "limitAmount": 0,         "productSubType": "Cheque",         "productType": "SAVINGS"     },     "customerDetails": [         {             "addressDetails": [                 {                     "addressDateSince": 8,                     "addressType": "HOME_ADDRESS",                     "buildingName": "Absa building",                     "postalCode": 2194,                     "streetName": "Republic road",                     "streetNumber": 270,                     "suburbOrTown": "Randburg"                 }             ],             "creditDetails": {                 "grossIncome": 0,                 "totalExpenses": 0             },             "customerIndicator": "PRIMARY",             "customerType": "NEW_TO_BANK",             "dateOfBirth": "1994-03-25",             "employmentDetails": {                 "companyName": "Absa",                 "employmentSector": "Information and communication technology",                 "occupationLevel": "Manager",                 "occupationStatus": "Full Time Employed",                 "companyPhoneNumber": "string",                 "companyEmailAddress": "string",                 "occupationalStatusCode": 0             },             "firstName": "Cynthia",             "gender": "MALE",             "identity": {                 "idNumber": 9403250985081,                 "idType": "PASSPORT",                 "passportNationality": "ZIM"             },             "language": "english",             "lastName": "string",             "maritalStatus": "MARRIED",             "noOfDependants": 0,             "qualification": "Matric",             "residentialStatus": "Renter",             "tempPermitNo": "string",             "contactDetails": [                 {                     "contactDetailsType": "EMAIL_ADDRESS",                     "preferenceOrder": 0,                     "contactDetailsDescription": "PERSONAL_EMAIL",                     "correspondence": "test@absa.africa"                 },                 {                     "contactDetailsType": "PHONE_NUMBER",                     "preferenceOrder": 0,                     "contactDetailsDescription": "MOBILE_NUMBER",                     "correspondence": "0819908786"                 },                 {                     "contactDetailsType": "PHONE_NUMBER",                     "preferenceOrder": 0,                     "contactDetailsDescription": "HOME_PHONE",                     "correspondence": "0838491324"                 }             ]         }     ] }';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{FraudSyncApplication_IH_V1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        FraudSyncApplication_Resp_IB_V1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static FraudSyncApplication_Resp_IB_V1 callHandlerMethod() {        
        FraudSyncApplication_Req_IB_V1 dummyBean = FraudSyncApplication_Req_IB_V1.createDummyRequest();
        FraudSyncApplication_Resp_IB_V1 responseBean = FraudSyncApplication_IH_V1.syncFraudApplication(dummyBean);
        return responseBean;
    }
}