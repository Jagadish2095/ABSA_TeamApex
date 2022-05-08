/**
 * Apex Enterprise Design Patters
 * Test Class for the Selector layer for Asset objects
 *
 * @author  Himanshu Nimje (Mphatek)
 * @since   26/03/2019
 */
@IsTest
private class AssetsSelectorTest {

    static testMethod void testGetSObjectType() {

        System.assert(new AssetsSelector().getSObjectType() != null);

    }

    static testMethod void testGetSObjectFieldList() {

        System.assert(new AssetsSelector().getSObjectFieldList() != null);

    }

    static testMethod void testselectAssetByName() {

        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        List<Asset> asset = new AssetsSelector().selectAssetByName(testDataFactory.testAsset.Name);

        System.assert(new AssetsSelector().selectAssetByName(asset.get(0).Id) != null);

    }

    static testMethod void testselectAssetByAccId() {

        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        List<Asset> asset = new AssetsSelector().selectAssetByAccId(testDataFactory.testAccount.Id);

        System.assert(new AssetsSelector().selectAssetByAccId(asset.get(0).Id) != null);

    }
    
     static testMethod void testselectAssetByNaturalKey() {

        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        List<Asset> asset = new AssetsSelector().selectAssetByAccId(testDataFactory.testAccount.Id);

        System.assert(new AssetsSelector().selectAssetByAccId(asset.get(0).Id) != null);

    }
    
     static testMethod void testselectAssetNumber() {

        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        List<Asset> asset = new AssetsSelector().selectAssetNumber(testDataFactory.testAsset.SerialNumber);

        System.assert(new AssetsSelector().selectAssetNumber(asset.get(0).Id) != null);

    }
    
      static testMethod void testselectAssetsByAccId() {

        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        List<Asset> asset = new AssetsSelector().selectAssetsByAccId(testDataFactory.testAccount.Id,'Will');


    }
    
    
      static testMethod void testselectAssetsByOpportunityId() {

        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        List<Asset> asset = new AssetsSelector().selectAssetsByOpportunityId(testDataFactory.testOpportunity.Id,'Will');



    }
    
    
    static testMethod void testselectByAccountIdAndAssetType() {

        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        
        List<Asset> asset = new AssetsSelector().selectByAccountIdAndAssetType(testDataFactory.testAccount.Id,'Will');

    }
    
}