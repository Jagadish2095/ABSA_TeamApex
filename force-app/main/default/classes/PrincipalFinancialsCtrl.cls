/**
 * Controller class for PrincipalFinancials aura component
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date September 2020
 */
public class PrincipalFinancialsCtrl {
	/** 
	 * get list of related parties for an account
     *
     * @param oppId opportunity Id
     * 
     * @return List<Map<String, Object>>
    */
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getRelatedParties(Id opportunityId) {
        AccountsSelector accountSelector = new AccountsSelector();
        Account account = accountSelector.selectByOpportunityId(opportunityId);
        
        if(String.valueOf(account.Client_Type__c).equalsIgnoreCase('SOLE TRADER') || String.valueOf(account.Client_Type__c).equalsIgnoreCase('STAFF') || String.valueOf(account.Client_Type__c).equalsIgnoreCase('INDIVIDUAL')){
            ContactsSelector contactsSelector = new ContactsSelector();
            
            if(account.ID_Number__pc != null){
                List<Contact> contacts = contactsSelector.selectByIdNumber(account.ID_Number__pc);
               
           
                for(Contact contact : contacts){
                    system.debug('Inside' + contact.Account.CIF__c +' accountCIF'+ account.CIF__c );
                    if(contact.Account.CIF__c != null && contact.Account.CIF__c == account.CIF__c){
                        
                        return new List<Contact>{contact};
                    }
                }
            }
        } else {
            List<Application_Principal__c> appPrincipals = new ApplicationPrincipalsSelector().selectApplicationPrincipalByOpportunityId(new Set<Id>{opportunityId});
            
            Set<Id> appPrincipalsIds = new Set<Id>();
            String mainPrincipalName = '';
            
            for(Application_Principal__c appPrincipal : appPrincipals){
                appPrincipalsIds.add(appPrincipal.AccConRelId__c);
                
                if(appPrincipal.Main__c){
                    mainPrincipalName = appPrincipal.Principal_Shareholder_Name__c;
                }
            }
            
            if(appPrincipalsIds != null && appPrincipalsIds.size() > 0){
                AccountContactRelationSelector accountContactsSelector = new AccountContactRelationSelector();
                List<AccountContactRelation> accountContacts = accountContactsSelector.selectById(appPrincipalsIds);
                Set<Id> contactIds = new Set<Id>();
                
                for(AccountContactRelation accountContact : accountContacts){
                    contactIds.add(accountContact.ContactId);
                }
                
            	ContactsSelector contactsSelector = new ContactsSelector();
                List<Contact> contacts = contactsSelector.selectByListContactIds(contactIds);
                
                if(contacts != null && contacts.size() > 0){
                    Contact mainContact = new Contact();
                    List<Contact> nonMainContactList = new List<Contact>();
                    List<Contact> orderedContactList = new List<Contact>();
                    
                    for(Contact contact : contacts){
                        if(contact.Name == mainPrincipalName){
                            orderedContactList.add(contact);
                        } else{
                            nonMainContactList.add(contact);
                        }
                    }
                    
                    orderedContactList.addAll(nonMainContactList);
                    
                    return orderedContactList;
                }
            }
        }
                
        return null;
    }
}