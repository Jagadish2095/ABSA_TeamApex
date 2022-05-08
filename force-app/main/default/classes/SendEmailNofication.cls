/**
* Description: Send email notfication to retail branch manager when leads are transferred in and out
* Test Class Name: SendEmailNofication
* @Author:  Sipho Mbulawa
* @Created Date:  2020-07-17
* CHANGE LOG:

**/

public class SendEmailNofication {
    
    public static void sendEmailToManager(List<Lead> leadsList, Map<Id, sObject> oldRecords){
        
        Set<Id> serviGroupIds = new Set<Id>();
        Map<Id, Integer> serviceGroupLeadMap = new Map<Id, Integer>();
        List<Messaging.SingleEmailMessage> emailsOutList = new List<Messaging.SingleEmailMessage>();
        
        for(Lead oldLead: (List<Lead>) oldRecords.values()){
            //System.debug('*************Old Lead*************' + leadRecords.size());
            Integer num  = 0;
            if(!serviceGroupLeadMap.containsKey(oldLead.sd_Service_Group_Id__c)){
                
                serviceGroupLeadMap.put(oldLead.sd_Service_Group_Id__c,num+1);
            }
            else{
                Integer i = serviceGroupLeadMap.get(oldLead.sd_Service_Group_Id__c);
                i = i + 1;
                serviceGroupLeadMap.put(oldLead.sd_Service_Group_Id__c, i);
            }
            
            serviGroupIds.add(oldLead.sd_Service_Group_Id__c);
        }
        
        List<Service_Group__c> serviceGroups = new ServiceGroupsSelector().selectById(serviGroupIds);
        List<String> toAddress = new List<String>();
        
        //Sending Email to the previous manager
        if(!serviceGroups.isEmpty()){      
            
            for(Service_Group__c serviceGroup: serviceGroups){    
                
                toAddress.add(serviceGroup.Manager__c);
                Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();               
                emailOut.setSubject('Confirmation: Leads Bulk Transfer-Out from your Branch');
                emailOut.setToAddresses(toAddress);
                emailOut.setPlainTextBody('Good Day ' + '\n' +
                                          '\n' +
                                          'This is a confirmation that ' + serviceGroupLeadMap.get(serviceGroup.Id) + ' leads have been bulk transferred out of your branch ' + serviceGroup.Name + ' to branch ' + leadsList.get(0).sd_Service_Group__c + '\n' +
                                          '\n' +
                                          'Regards' + '\n' +
                                          'Salesforce');
                emailsOutList.add(emailOut);
            }
                                   
        }
        
        //Sending Email to the new manager
        if(!leadsList.isEmpty()){
                toAddress.add(leadsList.get(0).Manager__c);
                Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage();                
                emailOut.setSubject('Confirmation: Leads Bulk Transfer-In to your Branch');
                emailOut.setToAddresses(toAddress);
                emailOut.setPlainTextBody('Good Day ' + '\n' + 
                                          '\n' +
                                          'This is a confirmation that ' + leadsList.size() + ' leads have been bulk transferred into your branch ' + leadsList.get(0).sd_Service_Group__c + '. Please check the Unallocated list view and lead history to see the transferred leads information. '+ '\n' +
                                          '\n' +
                                          'Regards' + '\n' +
                                          'Salesforce');
                emailsOutList.add(emailOut);
            }
                    
            try{
                Messaging.sendEmail(emailsOutList);
            }catch(Exception ex){
                throw ex;
            }            
        }
}