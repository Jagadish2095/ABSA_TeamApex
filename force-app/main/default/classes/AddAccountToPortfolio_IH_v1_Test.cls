@isTest
public class AddAccountToPortfolio_IH_v1_Test {
    
    @isTest static void portfolioAccountPositive() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AddAccountToPortfolio_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        Test.startTest();
        
        AddAccountToPortfolio_Resp_IB_v1 responseBean = AddAccountToPortfolio_IH_v1.AddAccountToPortfolio('PSEKHPP001','0000000065330526','20181115','8994','09999996','Loan','1798280','','','','','','1');
        System.debug('AddAccountToPortfolio responseBean get: '+responseBean);
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void portfolioAccountNegative() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AddAccountToPortfolio_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        Test.startTest();
        
        AddAccountToPortfolio_Resp_IB_v1 responseBean = AddAccountToPortfolio_IH_v1.AddAccountToPortfolio('PSEKHPP001','0000000065330526','20181115','8994','09999996','Loan','1798280','','','','','','1');
        System.debug('AddAccountToPortfolio responseBean get: '+responseBean);
        
        Test.stopTest();
    }
    
    @isTest static void portfolioAccountInfoException() 
    {        
        // No mock callout class 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ADD_ACCOUNT_TO_PORTFOLIO});
        
        Test.startTest();
        AddAccountToPortfolio_Resp_IB_v1 responseBean = AddAccountToPortfolio_IH_v1.AddAccountToPortfolio('PSEKHPP001','0000000065330526','20181115','8994','09999996','Loan','One','','','','','','1');
        System.debug('AddAccountToPortfolio responseBean get: '+responseBean);
        
        Test.stopTest();
    } 
    
    
    
}