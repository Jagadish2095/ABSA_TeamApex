@isTest
/*
* Test Class for Get Analyst Comments
* @ author Danie Booysen
* @ created 2019-07-12
*/
public class GetClientDetailsByIdCIF_IH_v1_Test {
    
    //Positive
    @isTest static void testGetClientDetailsByIdCIFPositive(){
        
        //Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetClientDetailsByIdCIFMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {GetClientDetailsByIdCIF_IH_v1.GET_CLIENT_DETAILS_BY_ID_SERVICE});
        
        Test.startTest();
        GetClientDetailsByIdCIF_Resp_IB_v1 responseBean = GetClientDetailsByIdCIF_IH_v1.getClientDetails('', '', '');
        Test.stopTest();
        
        System.debug('responseBean :' + responseBean);
        System.assertEquals(200, responseBean.statusCode);
    }
    
    //Negative
    @isTest static void testGetClientDetailsByIdCIFNegative(){
        
        //Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetClientDetailsByIdCIFMock_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {GetClientDetailsByIdCIF_IH_v1.GET_CLIENT_DETAILS_BY_ID_SERVICE});
        
        Test.startTest();
        GetClientDetailsByIdCIF_Resp_IB_v1 responseBean = GetClientDetailsByIdCIF_IH_v1.getClientDetails('', '', '');
        Test.stopTest();
        
        System.debug('responseBean :' + responseBean);
        System.assertEquals(500, responseBean.statusCode);
    }
    
    //No Integration Settings
    @isTest static void testGetClientDetailsByIdCIFNoIntegrationSettings(){
        
        //Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetClientDetailsByIdCIFMock_ApiRest(StringConstants.POSITIVE_STRING));
        
        Test.startTest();
        GetClientDetailsByIdCIF_Resp_IB_v1 responseBean = GetClientDetailsByIdCIF_IH_v1.getClientDetails('', '', '');
        Test.stopTest();
        
        System.debug('responseBean :' + responseBean);
        System.assertEquals(500, responseBean.statusCode);
    }
    
    //No Mock
    @isTest static void testGetClientDetailsByIdCIFNoMock(){
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {GetClientDetailsByIdCIF_IH_v1.GET_CLIENT_DETAILS_BY_ID_SERVICE});
        
        Test.startTest();
        GetClientDetailsByIdCIF_Resp_IB_v1 responseBean = GetClientDetailsByIdCIF_IH_v1.getClientDetails('', '', '');
        Test.stopTest();
        
        System.debug('responseBean :' + responseBean);
        System.assertEquals(500, responseBean.statusCode);
    }
    
    //Null Parameters
    @isTest static void testGetClientDetailsByIdCIFNullParameters(){
        
        //Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetClientDetailsByIdCIFMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {GetClientDetailsByIdCIF_IH_v1.GET_CLIENT_DETAILS_BY_ID_SERVICE});
        
        Test.startTest();
        GetClientDetailsByIdCIF_Resp_IB_v1 responseBean = GetClientDetailsByIdCIF_IH_v1.getClientDetails(null, null, null);
        Test.stopTest();
        
        System.debug('responseBean :' + responseBean);
        System.assertEquals(500, responseBean.statusCode);
    }
    
       @isTest static void GetCIFcodebyID(){
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {GetClientDetailsByIdCIF_IH_v1.GET_CLIENT_DETAILS_BY_ID_SERVICE});
        
        Test.startTest();
        GetClientDetailsByIdCIF_Resp_IB_v1 responseBean = GetClientDetailsByIdCIF_IH_v1.GetCIFCodebyId('', '', '','','');
        Test.stopTest();
        
        System.debug('responseBean :' + responseBean);
        System.assertEquals(500, responseBean.statusCode);
    }

    /*
	* Mock class for Get Client Details By Id CIF
	* @ author Danie Booysen
	* @ created 2019-07-12
	*/
    public class GetClientDetailsByIdCIFMock_ApiRest implements HttpCalloutMock{
        
        Private String typeTest;
        
        //@param typeTest: positive or negative response
        public GetClientDetailsByIdCIFMock_ApiRest (final String typeTest){
            this.typeTest = typeTest;
        }
        
        //Implement this interface method
        public HttpResponse respond(HttpRequest request) { 
            
            HttpResponse response = new HttpResponse();
            response.setBody('{"nbrEntsRetrieved": "2","lastSearchPos": "018606289398089MUSKM+ 001","tblEntry": [{"cifKey": "MUSKM  001","cifInitials": "M","cifSurname": "MUSK",'+
                             '"cifTitleCode": "1","cifClntType": "101","cifClntGroup": "I","cifNbrOfAccts": "1","cifBirthDate": "19860628","cifAddrLine1": "109 KATHERINE STREET",'+
                             '"cifAddrLine2": "","cifPostlSuburb": "","cifPostlTown": "SANDTON","cifPostlCodeRsa": "2196","cifCorpCode": "A"}]}');
            
            if(typeTest == StringConstants.POSITIVE_STRING){
                
                response.setStatusCode(200);
                
            }else if(typeTest == StringConstants.NEGATIVE_STRING){
                
                response.setStatusCode(500);
            }
            return response;
        }
    }
}