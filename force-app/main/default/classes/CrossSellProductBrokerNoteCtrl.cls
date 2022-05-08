/*
Lightning Component Controller For CrossSellProductBrokerNote
*
* @author  Divya Podilla : Absa
* @version v1.0
* @since   2020-12-1
* 
*/
public class CrossSellProductBrokerNoteCtrl {
    
    @AuraEnabled
    public static List<Cross_Sell_Products_Virtual_Advisor__mdt> queryAllProducts()
    {
        
        List<Cross_Sell_Products_Virtual_Advisor__mdt> allProducts = [SELECT MasterLabel,DeveloperName, Email__c FROM Cross_Sell_Products_Virtual_Advisor__mdt ]; 
        
        return allProducts;
        
    }
    @AuraEnabled
    public static List<Cross_Sell_Products_Virtual_Advisor__mdt> sendEmailToTeam(String caseid,String selProducts)
    {
        List<Cross_Sell_Products_Virtual_Advisor__mdt> allProducts = new List<Cross_Sell_Products_Virtual_Advisor__mdt>();
        List<String> lstproducts = selProducts.split(',');            
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        allProducts = [SELECT MasterLabel,DeveloperName, Email__c FROM Cross_Sell_Products_Virtual_Advisor__mdt where MasterLabel = 'Short term']; 
        
        case caserec = [select id,First_Name__c,owner.name,Last_Name__c,Customer_ID__c,Mobile__c,Email__c,Physical_Address_Formula__c,Postal_Address_Formula__c ,contactid,AccountId,Account.PersonContactId,Cross_Sell_Products_Broker_Note__c from case where id = :caseid];
        list<EmailTemplate> em = new list<EmailTemplate>();
        em = [SELECT Id,Subject,Body,HtmlValue From EmailTemplate where Name ='Cross Sell Products - Broker Note' limit 1];

        OrgWideEmailAddress owd =[Select Id, Address From OrgWideEmailAddress where Address =: system.label.EmailAddLabel];
      
        List<Org_Wide_Lookup_Value__mdt> mdt = new OrgWideLookupValuesSelector().selectByLabel('Email Template Default TargetObjectId');
        String defaulttargetObjectId = null;
        if (mdt.size()>0 ) {
        defaulttargetObjectId = mdt[0].Value__c;
        }
        
        for(Cross_Sell_Products_Virtual_Advisor__mdt cs : allProducts){

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(owd.Id);
            String toadress = cs.Email__c;
            system.debug('cs.Email__c--->'+cs.Email__c);
            List<String> sendTo = new List<String>();
            sendTo.add(toadress);
            mail.setToAddresses(sendTo);
            mail.setWhatId(caserec.id);
            mail.setTreatTargetObjectAsRecipient(false);
            mail.setSaveAsActivity(true);
            mail.setTemplateId(em.get(0).id);
            if(string.isBlank(caserec.Account.PersonContactId) )
                mail.setTargetObjectId(defaulttargetObjectId);  
            else{
                mail.setTargetObjectId(caserec.Account.PersonContactId);}
            mails.add(mail);
           }
        system.debug('Size--->'+mails.size());
        Messaging.sendEmail(mails);
        caserec.Cross_Sell_Products_Broker_Note__c = selProducts.replace(',',';');
        update caserec;
        return allProducts;
        
    }
}