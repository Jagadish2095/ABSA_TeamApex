/**
 * @author Minal Rama (BlueSky)
 * @date 2020/10/21
 * @description Test class for CallScriptController
 */
@IsTest
public class CallScriptControllerTest {

    @TestSetup
    static void setScriptData(){

        Campaign campaign = new Campaign();
        campaign.Name = 'Test Campaign';
        insert campaign;

        Campaign ffCampaignOnline = new Campaign();
        ffCampaignOnline.Name = 'DD Flexi Funeral - Online';
        insert ffCampaignOnline;

        Financial_Product__c finProduct = new Financial_Product__c();
        finProduct.Name = 'Flexi Funeral';
        finProduct.Product__c = 'Flexi Funeral';
        finProduct.Product_Type__c = 'Retail Banking';
        finProduct.Business_Unit__c = 'Retail Banking';
        insert finProduct;

        Financial_Product__c finProduct2 = new Financial_Product__c();
        finProduct2.Name = 'Road Cover';
        finProduct2.Product__c = 'Road Cover';
        finProduct2.Product_Type__c = 'Retail Banking';
        finProduct2.Business_Unit__c = 'Retail Banking';
        insert finProduct2;

        Call_Script__c script = new Call_Script__c();
        script.Script__c = 'Test';
        script.Step__c = 1;
        script.Financial_Product__c = finProduct2.Id;
        script.Campaign__c = campaign.Id;

        insert script;

        Call_Script__c script2 = new Call_Script__c();
        script2.Step__c = 3;
        script2.Financial_Product__c = finProduct.Id;

        insert script2;

        Call_Script__c script3 = new Call_Script__c();
        script3.Script__c = 'Test';
        script3.Step__c = 4;
        script3.Financial_Product__c = finProduct2.Id;
        script3.Campaign__c = campaign.Id;

        insert script3;

        Call_Script__c script4 = new Call_Script__c();
        script4.Script__c = 'Test';
        script4.Step__c = 5;
        script4.Financial_Product__c = finProduct.Id;
        script4.Campaign__c = campaign.Id;

        insert script4;

        Call_Script__c script5 = new Call_Script__c();
        script5.Script__c = 'Test';
        script5.Step__c = 6;
        script5.Financial_Product__c = finProduct.Id;
        script5.Campaign__c = ffCampaignOnline.Id;

        insert script5;

    }

    /**
     *  @description This method tests getting the script for a product and step
     */
    @IsTest
    static void getScriptTest(){
        Id campaignId = [SELECT Id FROM Campaign LIMIT 1].Id;
        Call_Script__c callScript = CallScriptController.getScript(5,'Flexi Funeral', campaignId);
        System.assert(callScript != null, 'Call script is null');
        System.assert(String.isNotBlank(callScript.Script__c));

        callScript = CallScriptController.getScript(1,'Road Cover', null);
        System.assert(callScript != null, 'Call script is null');
        System.assert(String.isNotBlank(callScript.Script__c));

        callScript = CallScriptController.getScript(1,'Test', null);
        System.assert(callScript == null, 'Call script is not null');
    }

    /**
     * @description This method tests getting the script for a product and step
     */
    @IsTest
    static void getScriptsTest(){
        Id campaignId = [SELECT Id FROM Campaign LIMIT 1].Id;
        List<Call_Script__c> callScripts = CallScriptController.getScripts('1,4','Road Cover',campaignId);
        System.assert(!callScripts.isEmpty(), 'Call script is empty');
        System.assert(String.isNotBlank(callScripts[0].Script__c));

        callScripts = CallScriptController.getScripts('5','Flexi Funeral',campaignId);
        System.assert(!callScripts.isEmpty(), 'Call script is empty');
        System.assert(String.isNotBlank(callScripts[0].Script__c));

        callScripts = CallScriptController.getScripts('5','Test',campaignId);
        System.assert(callScripts == null, 'Call script is not empty');
    }

    /**
     * @description This method tests getting the script for default online for flexi cross sell
     */
    @IsTest
    static void getScriptsTestOnline(){
        List<Call_Script__c> callScripts = CallScriptController.getScripts('6','Flexi Funeral',null);
        System.assert(callScripts != null, 'Call script is not empty');

        Call_Script__c callScript = CallScriptController.getScript(6,'Flexi Funeral', null);
        System.assert(callScript != null, 'Call script is null');
        System.assert(String.isNotBlank(callScript.Script__c));
    }
    
    /**
     * 
     * @description This method tests the getPicklistValuesMap Method
     */
    @IsTest

    static void getPicklistValuesMapTest(){
        Map<string,string> picklistValueMap = new Map<string,string>();
        picklistValueMap = CallScriptController.getPicklistValuesMap('Case', 'Status');
         System.assert(picklistValueMap.Keyset().size() >0);
    }

}