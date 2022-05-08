/**
* Class that must be run for sandbox creation and refresh
* 
* @author  Robert McLean
* @since   2020-03-25
*/
global class SandBoxPreperation implements SandboxPostCopy {

    global void runApexClass(SandboxContext context) {
        //System.debug('Org ID: ' + context.organizationId());
        //System.debug('Sandbox ID: ' + context.sandboxId());
        //System.debug('Sandbox Name: ' + context.sandboxName());
        
        /*      
        * Check if static contact exists if not create
        */
        Set<String> emailSet = new Set<String>() ;
        emailSet.add('emailtemplate@absa.africa');
        List<Contact> listContacts =  new ContactsSelector().selectByEmail( emailSet, 1);
        if (listContacts.isEmpty()) {
            Contact defaultContact = new Contact();
            defaultContact.FirstName = 'Email Template';
            defaultContact.LastName = 'Contactid';
            defaultContact.Email = 'emailtemplate@absa.africa';
            insert defaultContact;
        }
    }
}