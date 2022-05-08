@isTest
public class CAFGetCase_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"GetCaseResponse": {"theCase": {"Id": "0b5f6d1b-fd6b-4cdd-928b-a346fa7c7b06","ParentId": "ddcc7c7a-e9e6-46fe-9fbc-c9de72633e57","ReferenceNumber": "1611667564966","DefinitionId": "fe968521-6b2e-4ac4-8673-f54f26c94507","DefinitionVersion": "1","Password": "sap","Data": "PENyZWF0ZUFWQUZBcHBsaWNhdGlvbj48b3JpZ2luYXRvclVzZXJJZD5FU1A8L29yaWdpbmF0b3JVc2VySWQ+PGJ1c3NPcmlnaW5hdG9yUmVmTm8+MTYxMTY2NzU2NDk2NjwvYnVzc09yaWdpbmF0b3JSZWZObz48aW50ZXJuZXRDdXN0b21lclJlZk5vPjIwMjEwMTU4ODAxMDAwNzkzNDQ8L2ludGVybmV0Q3VzdG9tZXJSZWZObz48aW5kaWNhdG9yU2hvcnRUZXJtSW5zPlk8L2luZGljYXRvclNob3J0VGVybUlucz48c3RpUG9saWN5TnVtYmVyPjA8L3N0aVBvbGljeU51bWJlcj48c3RpQ29tcGFueT5BQlNBPC9zdGlDb21wYW55PjxsYW5kTG9yZFdhaXZlckluZD5OPC9sYW5kTG9yZFdhaXZlckluZD48aW5kaWNhdG9yRGViaXRPcmRlcj5ZPC9pbmRpY2F0b3JEZWJpdE9yZGVyPjxjdXJyZW50QmFua0JyYW5jaD4wMDAwMDA8L2N1cnJlbnRCYW5rQnJhbmNoPjxjdXJyZW50QmFua0FjY05vPjE0MDcwMTc5NDA8L2N1cnJlbnRCYW5rQWNjTm8+PHN0YXRlbWVudEluZGljYXRvcj5FPC9zdGF0ZW1lbnRJbmRpY2F0b3I+PHN0YXRlbWVudEVtYWlsMT5tcHVtaS5tYWdhZ3VsYUBhYnNhLmFmcmljYTwvc3RhdGVtZW50RW1haWwxPjxzZWN0aW9uMTI5Tm90aWNlPjAyPC9zZWN0aW9uMTI5Tm90aWNlPjxkZWFsZXJDb2RlPjAwMDA1MTAwMTA8L2RlYWxlckNvZGU+PGNhZlNpdGVDb2RlPjU1ODg8L2NhZlNpdGVDb2RlPjxhYnNhU2l0ZUNvZGU+NTU4ODwvYWJzYVNpdGVDb2RlPjxhbGxpYW5jZUNvZGU+MTwvYWxsaWFuY2VDb2RlPjxmaW5hbmNlVHlwZT4wMElTQTwvZmluYW5jZVR5cGU+PHB1cmNoYXNlUHJpY2U+NjUwMDAwLjAwIDwvcHVyY2hhc2VQcmljZT48ZGVwb3NpdEFtdD4wLjAwIDwvZGVwb3NpdEFtdD48ZGVhbGVyVHJhZGVJbkFtdD4wLjAwIDwvZGVhbGVyVHJhZGVJbkFtdD48ZGVhbGVyQ2FzaERlcG9zaXRBbXQ+MC4wMCA8L2RlYWxlckNhc2hEZXBvc2l0QW10PjxyZXNpZHVhbFZhbHVlPjAuMDAgPC9yZXNpZHVhbFZhbHVlPjxpbml0aWF0aW9uRmVlPjEyMDcuNTAgPC9pbml0aWF0aW9uRmVlPjxjb21tRG9jRmVlPjEwMDAuMDAgPC9jb21tRG9jRmVlPjxwYXltZW50RnJlcXVlbmN5PjAxPC9wYXltZW50RnJlcXVlbmN5PjxwZXJpb2RSZXBheW1lbnQ+NjA8L3BlcmlvZFJlcGF5bWVudD48cmF0ZVR5cGU+TDwvcmF0ZVR5cGU+PGludGVyZXN0UmF0ZVByZWZlcnJlZD4xNS4wPC9pbnRlcmVzdFJhdGVQcmVmZXJyZWQ+PGNhc2FSZWZOdW1iZXI+MDAwMDAwMDAwPC9jYXNhUmVmTnVtYmVyPjxjb250cmFjdFN0YXJ0RGF0ZT4yMDIxLTAxLTI2PC9jb250cmFjdFN0YXJ0RGF0ZT48Zmlyc3RQYXltZW50RGF0ZT4yMDIxLTAzLTAxPC9maXJzdFBheW1lbnREYXRlPjxlc3BHdWlkUmVmZXJlbmNlPjE2MTE2Njc1NjQ5NjY8L2VzcEd1aWRSZWZlcmVuY2U+PHNhcFJlZk5vPjIwMjEwMTU4ODAxMDAwNzkzNDQ8L3NhcFJlZk5vPjxzY29yZVJlc3VsdD5BPC9zY29yZVJlc3VsdD48Y3JlZGl0TGluZT5OPC9jcmVkaXRMaW5lPjxzYWxlc0JyYW5jaD5BQlNBQjwvc2FsZXNCcmFuY2g+PC9DcmVhdGVBVkFGQXBwbGljYXRpb24+","Status": "QueuedForProcessing","Created": "2021-01-26T15:26:11.783","Updated": "2021-01-26T16:14:16.533","DisplayName": null,"FreeTextTag": null}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CAFGetCase_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        CAFGetCase_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static CAFGetCase_Resp_IB_v1 callHandlerMethod() {
        CAFGetCase_Req_IB_v1 dummyBean = CAFGetCase_Req_IB_v1.createDummyRequest();
        CAFGetCase_Resp_IB_v1 responseBean = CAFGetCase_IH_v1.bcmsgetcasev1data(dummyBean.GetCase.Id);
        return responseBean;
    }
}