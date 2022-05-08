/*
* @Description Controller Test Class For CPBCertificateController class
* @author  Diksha Wasekar :Mphatek
* @version v1.0
* @since   2021-09-29
*/
@isTest
public class CPBCertificateControllerTest {
@testSetup
static void dataCreation(){
    Id personRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordtypeId();
    Account account = new Account(RecordTypeID=personRecordTypeId ,
                                    FirstName='CHRISTOPHER',
                                    LastName='BURGER',
                                    ID_Number__pc='7707077777087'
                                    );
    insert account;
}


@isTest
public static void callCPBService(){
    // Set mock callout class
    Test.setMock(HttpCalloutMock.class, new CPBValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING));
    Account acc=[select id,ID_Number__pc, Name from Account where ID_Number__pc='7707077777087'];
    Test.startTest();
    String respCPBStr = CPBCertificateController.getCPBServiceDetails(acc.Id);
    System.assertNotEquals(null, respCPBStr);
    Test.stopTest();
}

@isTest
public static void getExistingAddress(){
    // Set mock callout class
    Account acc=[select id,ID_Number__pc, Name from Account where ID_Number__pc='7707077777087'];
    CPBValidate_Mock_ApiRest cpbMock = new CPBValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING);
    String respCPBStr = cpbMock.respond(null).getBody();

    Test.startTest();
    List<Address__c> residentialAddress = CPBCertificateController.getExistingAddress(acc.Id,respCPBStr);
    System.assertNotEquals(null, residentialAddress);
    Test.stopTest();
}




}