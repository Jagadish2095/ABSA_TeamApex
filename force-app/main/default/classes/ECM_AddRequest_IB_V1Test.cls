@isTest
public class ECM_AddRequest_IB_V1Test {
    static testMethod void testAll() {
        test.startTest();
        ECM_AddRequest_IB_V1 req = new ECM_AddRequest_IB_V1();
        ECM_AddRequest_IB_V1.AddRequest request = new ECM_AddRequest_IB_V1.AddRequest();
        request.Token = 'login.Token';
        request.FileName = 'fileName';
        //setDocumentECMInfo(request, parentId, acc, usr, documentType);
        request.Data = 'string';
        req.AddRequest = request;   
        ECM_AddRequest_IB_V1.FieldValues fv = new ECM_AddRequest_IB_V1.FieldValues();
        ECM_AddRequest_IB_V1.FieldValue fv2 = new ECM_AddRequest_IB_V1.FieldValue();
        req.fromGetResult(ECM_GetResult_IB_V1.getExample());
        test.stopTest();
    }
}