/**=================================================================================================================================
* Last Modified By By: Eduardo Salia
* Last Modified Date: 29/03/2021
* @description Test Class for getDocumentsVA Class
===================================================================================================================================**/
@isTest
public class getDocumentsVATest
{
    @testSetup static void setup()
    {

        insertSettings();
        Id caseSupportRecordTypeId = Schema.SObjectType.Case_Support__c.getRecordTypeInfosByName().get('Policy').getRecordTypeId();
        
        Document_Template__c docTem = new Document_Template__c();
        docTem.Name = 'BrokerNote';
        //string xmlString= '';
        string xmlString= '<Schema><CallStart>{{Event.Call_Start__c}}</CallStart><FirstName>{{Case.First_Name__c}}</FirstName><LastName>{{Case.Last_Name__c}}</LastName><IDNumber>{{Case.Customer_ID__c}}</IDNumber><BirthDate>{{Case.Birth_Date__c}}</BirthDate><HomePhone>{{Case.Home_Phone__c}}</HomePhone><WorkNumber>{{Case.Work_Phone__c}}</WorkNumber><Mobile>{{Case.Mobile__c}}</Mobile>'+
            '<Email>{{Case.Email__c}}</Email><Name>{{Name}}</Name><PolicyProviderCode>{{PolicyProviderCode}}</PolicyProviderCode><PolicyProviderName>{{PolicyProviderName}}</PolicyProviderName>{{#Case_Support__c}}<PolicyDetails><PolicyNumber>{{Policy_Number__c}}</PolicyNumber><PolicyType>{{Policy_Type__c}}</PolicyType><PolicyProvider>{{Product_Provider__c}}</PolicyProvider></PolicyDetails>{{/Case_Support__c}}</Schema>';
        
        docTem.XML__c = xmlString;
        docTem.Document_Type__c = 'BrokerNote';
        docTem.Template_Id__c = '209';
        docTem.ECM_Item_Type__c ='Ent_Agreement';
        INSERT docTem;
        
        list<user> lstUsr = TestDataFactory.getTestUsers('System Administrator',1);
        lstUsr[0].Advisor_Code__c='98705';
        lstUsr[0].Sanlam_Code__c='SAN987';
        lstUsr[0].AIMS_Code__c='AIM098';
        lstUsr[0].Liberty_Code__c='LIN765';
        lstUsr[0].Momentum_Code__c='MOM876';
        INSERT lstUsr;

        Account accObj2= new Account();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        accObj2.RecordTypeId=accountRecordTypeId;
        accObj2.FirstName = 'Test';
        accObj2.LastName = 'Test';
        accObj2.CIF__c = 'LOUWNJ 019';
        INSERT accObj2;
        
        Id CaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Broker Note').getRecordTypeId();
        List<Case> cs = TestDataFactory.getCases(CaseRecordTypeId,2);
        cs[0].accountid = accObj2.id;
        cs[0].Adviser__c = lstUsr[0].id; 
        cs[0].Adviser_First_Name__c='Ter';
        cs[0].Adviser_Last_Name__c='Last';
        cs[0].Adviser_Code__c ='98705'; 
        cs[0].Mobile__c ='9045678903'; 
        cs[0].Alternate_Phone1__c ='9045678903'; 
        cs[0].Alternate_Phone2__c ='9045678903'; 
        cs[0].Alternate_Phone3__c ='9045678903'; 
        cs[0].Alternate_Phone4__c ='9045678903'; 
        cs[0].Alternate_Phone5__c ='9045678903'; 
        cs[0].Alternate_Phone6__c ='9045678903'; 
        cs[0].Alternate_Phone7__c ='9045678903';
        INSERT cs;
        
        Case_Support__c csObj = new Case_Support__c();
        csObj.RecordTypeId=caseSupportRecordTypeId;
        csObj.Case__c=cs[0].Id; 
        csObj.Product_Provider__c= 'Sanlam';
        csObj.Policy_Number__c ='7654Pol';
        INSERT csObj;
        
        Case_Support__c csObj1 = new Case_Support__c();
        csObj1.RecordTypeId=caseSupportRecordTypeId;
        csObj1.Product_Provider__c= 'AIMS';
        csObj1.Case__c=cs[0].Id; 
        csObj1.Policy_Number__c ='7634Pol';
        INSERT csObj1;
        
        Case_Support__c csObj2 = new Case_Support__c();
        csObj2.RecordTypeId=caseSupportRecordTypeId;
        csObj2.Product_Provider__c= 'AIMS';
        csObj2.Case__c=cs[0].Id; 
        csObj2.Policy_Number__c ='76364Pol';
        INSERT csObj2;
        
        Case_Support__c csObj3 = new Case_Support__c();
        csObj3.RecordTypeId=caseSupportRecordTypeId;
        csObj3.Product_Provider__c= 'Momentum';
        csObj3.Case__c=cs[0].Id; 
        csObj3.Policy_Number__c ='77364Pol';
        INSERT csObj3;
        
        Case_Support__c csObj4 = new Case_Support__c();
        csObj4.RecordTypeId=caseSupportRecordTypeId;
        csObj4.Product_Provider__c= 'Liberty Life';
        csObj4.Case__c=cs[0].Id; 
        csObj4.Policy_Number__c ='75434Pol';
        INSERT csObj4;
        
        Case_Support__c csObj5 = new Case_Support__c();
        csObj5.RecordTypeId=caseSupportRecordTypeId;
        csObj5.Product_Provider__c= 'Absa Life';
        csObj5.Case__c=cs[0].Id; 
        csObj5.Policy_Number__c ='75543Pol';
        INSERT csObj5;
        
        cs[0].SelectedPoliciesID__c=csObj.id+';'+csObj1.Id+';'+csObj2.Id+';'+csObj3.Id+';'+csObj4.Id+';'+csObj5.Id;
        UPDATE cs;
        
        Document__c docObj = new Document__c();
        docObj.Case__c = cs[0].Id;
        docObj.Name ='BrokerNote_AIMS_AIMS_AIMS_67_87_98';
        docObj.ECM_Type__c ='Ent_Agreement';
        docObj.Reference__c ='Ref1234';
        docObj.IsActive__c = true;
        INSERT docObj;  
        
        QuickText QText= new QuickText();      
        QText.Message='Hi How R U';
        QText.name = 'BrokerNote';
        INSERT QText;
        
        
        System.runAs(lstUsr[0])
        {
            EmailTemplate e = new EmailTemplate (developerName = 'test',isActive = true, TemplateType= 'Text',FolderId = UserInfo.getUserId(), Name = 'BrokerNotePDF'); // plus any other fields that you want to set
            INSERT e;
        }
    }
    /**
     * @description Method1 Description
     *
     */
    @isTest 
    public static void brokerNoteMethod(){
        string TemplateName='BrokerNote';
        case cs= [select id,Adviser__c,Adviser_First_Name__c,Adviser_Last_Name__c,Adviser_Code__c,Mobile__c,accountid from case limit 1];
        system.assertNotEquals(null, cs);
        user usr= [select id,AB_Number__c,FirstName,Sanlam_Code__c,AIMS_Code__c,Liberty_Code__c,Momentum_Code__c,Skills_Products__c,Advisor_Code__c from user limit 1];
        Document__c docObj = [select id,name from Document__c limit 1];
        Test.startTest();
        getDocumentsVA.SendBrokerNotes(docObj.id,cs.id);
        getDocumentsVA.generateNewDocument(cs.id, TemplateName );
        getDocumentsVA.generateNewDocument(cs.id, '' );
        getDocumentsVA.FetchDocumentId(cs.id);
        getDocumentsVA.getDocumentContent(docObj.id);
        getDocumentsVA.getCustomer(cs.id);
        getDocumentsVA.userData();
        getDocumentsVA.dispatchSMS(usr.id, cs.id, '+2706365473680','test', 'BrokerNote', 'test Service',true); 
        //getDocumentsVA.createTask('TestUser', '+270636547368', usr.id, cs.id, UserInfo.getUserId(), 'Test', null);
        getDocumentsVA.getContacts((string)cs.id);
        
        Test.stopTest();
        
        getDocumentsVA.getActiveNoteBrokerPDF(cs.id);
        getDocumentsVA.getVirtualAdviserDetails(cs.id);
        getDocumentsVA.FetchDocumentId(cs.id);
    }
    /**
     * @description insertSettings Description
     *
     */
    public static void insertSettings()
    {
        List<String> endpoints = new List<String>();
        endpoints.add('ECM Query Path');
        endpoints.add('ECM Authenication Path');
        endpoints.add('ECM Add Path');
        endpoints.add('ECM Logout Path');
        endpoints.add('ECM GetItemType Path');
        endpoints.add('ECM Get Path');
        endpoints.add('ECM GetItemTypes Path');
        IntegrationTestDataFactory.insertIntegrationSettings('API Manager', endpoints);
    }
    /**
     * @description ECM_Mock_ApiRest Description
     *
     */
    public class ECM_Mock_ApiRest implements HttpCalloutMock
    {
        /**
         * @description body Description
         *
         */
        public String body { get; set; }
        /**
         * @description ECM_Mock_ApiRest Description
         *
         */
        public ECM_Mock_ApiRest() {}
        /**
         * @description ECM_Mock_ApiRest Description
         *
         * @param body (String): Write the parameter description
         */
        public ECM_Mock_ApiRest(String body) {
            this.body = body;
        }
        /**
         * @description respond Description
         *
         * @param request (HTTPRequest): Write the parameter description
         * @return HTTPResponse: Write the return description
         */
        public HTTPResponse respond(HTTPRequest request) {
            HTTPResponse response = new HTTPResponse();
            response.setStatusCode(200);
            response.setBody(body);
            response.setHeader('Content-Type', 'application/json');
            return response;
        }
    }
}