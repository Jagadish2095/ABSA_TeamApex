/**
* Generic class that is used by process builder to send emails and store them on the specified whatId
* @author  Kyle Alexander
* @created 2018-07-06
*/

global class EmailAdaptor {

    /**
     * Method invoked by a process which looks up the contact email and calls the email handler with the required parameters
     *
     * @param requests invokable variables provided by process builder
     */
    @InvocableMethod
    public static void sendEmail(List<SendEmailRequest> requests) {
        Set<Id> contactIds = new Set<Id>();
        for(SendEmailRequest emailRequest : requests){
            contactIds.add(emailRequest.whoId);
        }
        Map<Id, Contact> contacts = new Map<Id, Contact>([select Id, Email from Contact where Id in :contactIds]);


        for(SendEmailRequest req : requests){
            try{
                EmailHandler.SendEmail(req.whatId, req.whoId, contacts.get(req.whoId).Email, req.templateName);
            }
            catch (Exception e){
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
                throw new DmlException(e.getMessage() + ' ' + e.getLineNumber());
            }
        }
    }

    global class SendEmailRequest {
        @InvocableVariable
        global ID whatId;

        @InvocableVariable
        global ID whoId;

        @InvocableVariable
        global String templateName;
    }
}