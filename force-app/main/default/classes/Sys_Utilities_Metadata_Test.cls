// @author Himani Joshi: 20200805

@isTest
public class Sys_Utilities_Metadata_Test {
    @isTest static void testGetMandatoryDocs() {
        Test.startTest();
        System.assertNotEquals(null, Sys_Utilities_Metadata.getMandatoryDocs('Sole Trader','Merchant','E-Commerce'));
        Test.stopTest();
    }

    @isTest static void testGetIntegrationSettingsMetadata(){
        Test.startTest();
        System.assertNotEquals(null, Sys_Utilities_Metadata.getIntegrationSettingsMetadata('CIB','Development'));
        Test.stopTest();
    }

    @isTest static void testGetFieldVisibilityMetadataByProductName(){
        Test.startTest();
        System.assertNotEquals(null, Sys_Utilities_Metadata.getFieldVisibilityMetadataByProductName('MerchantProductDetails','E-Commerce'));
        Test.stopTest();
    }

    @isTest static void testGetGeneralVirtualAdvisorRuleMetadata(){
        Test.startTest();
        System.assertNotEquals(null, Sys_Utilities_Metadata.getGeneralVirtualAdvisorRuleMetadata());
        Test.stopTest();
    }

    @isTest static void testGetFieldVisibilityMetadataByProductFamily(){
        Test.startTest();
        System.assertNotEquals(null, Sys_Utilities_Metadata.getFieldVisibilityMetadataByProductFamily('MerchantProductDetails','Merchant'));
        Test.stopTest();
    }

    @isTest static void testGetFieldVisibilityMetadataByProductNameAndFamily(){
        Test.startTest();
        System.assertNotEquals(null, Sys_Utilities_Metadata.getFieldVisibilityMetadataByProductNameAndFamily('MerchantProductDetails','E-Commerce','Merchant'));
        Test.stopTest();
    }
    @isTest static void testgetHighRiskMCC(){
        Test.startTest();
        System.assertNotEquals(null, Sys_Utilities_Metadata.getHighRiskMCC());
        Test.stopTest();
    }
}