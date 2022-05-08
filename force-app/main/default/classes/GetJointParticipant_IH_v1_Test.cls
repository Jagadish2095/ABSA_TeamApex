@isTest
public class GetJointParticipant_IH_v1_Test
{           
    @isTest static void getJointParticipantPositive() 
    {        
        GetJointParticipant_Req_IB_v1 dummyBean = new GetJointParticipant_Req_IB_v1();
        dummyBean.createDummyRequest();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT});
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetJointParticipantMock_ApiRest(StringConstants.POSITIVE_STRING));
        
        Test.startTest();
              
		GetJointParticipant_Resp_IB_v1 responseBean = GetJointParticipant_IH_v1.getJointParticipant('RAMANS+001');       
        System.debug('Joint Participant responseBean positive: '+ responseBean);
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void getJointParticipantNegative() 
    {               
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetJointParticipantMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT});
        
        Test.startTest();  
        
        GetJointParticipant_Resp_IB_v1 responseBean = GetJointParticipant_IH_v1.getJointParticipant('FOURIDP141');
        System.debug('Joint Participant responseBean negative: '+ responseBean);
        Test.stopTest();
    }
    
    @isTest static void getJointParticipantException() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetJointParticipantMock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT});
        
        Test.startTest();
        
        GetJointParticipant_Resp_IB_v1 responseBean = GetJointParticipant_IH_v1.getJointParticipant('');  
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }
    
    @isTest static void getJointParticipantNoIntegrationSettings() 
    {        
        GetJointParticipant_Req_IB_v1 dummyBean = new GetJointParticipant_Req_IB_v1();
        dummyBean.createDummyRequest();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetJointParticipantMock_ApiRest(StringConstants.POSITIVE_STRING));
        
        Test.startTest();
              
		GetJointParticipant_Resp_IB_v1 responseBean = GetJointParticipant_IH_v1.getJointParticipant('RAMANS+001');       
        System.debug('Joint Participant responseBean positive: '+ responseBean);
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}