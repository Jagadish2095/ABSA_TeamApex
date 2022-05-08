/*
 * For the component to display and upload website documents and details
 * Tinashe Shoko
*/
public class merchantOnboardingWebsiteDetailsCtrl {
    /**
* @author Tinashe Shoko
* Method that gets a list of all documents metadata
*
* @return documentTemplates
*/
    @AuraEnabled
    public static List<Document_Template__c> getDocumentMetadata() {
        List<Document_Template__c> documentTemplates = new DocumentTemplateSelector().getAllDocumentTemplates();
        return documentTemplates;
    }

    /**
* @description A method to append to and existing file or save a file to the Attachment object. Once the file is save or updated it is then sent to ECM.
* @param parentId parent object Id the docs are linked to.
* @param fileName name of the file.
* @param base64Data body of the file.
* @param contentType type of file being uploaded.
* @param fileId Id of existing file that has already been saved to Attachment object.
* @param done indidcator to continu to ECM
* @param documentType the type of document beind uploaded.
* @return fileId Id of file updated or saved.
*
* @modified 2019-06-14 by Robert McLean.
* @Change description Added document type to parameters to be used with the completeUpload method.
**/
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId,
                               Boolean done, String documentType, Boolean signedManually, String relatedPartyId)
    {
        return DocumentController.saveChunk(parentId, fileName, base64Data, contentType, fileId,
                                            done, documentType, signedManually, relatedPartyId);
    }

    @AuraEnabled
    public static List<Opportunity> getWebsiteURL(Id oppId) {
        return new OpportunitiesSelector().selectByOpportunityId(oppId);
    }

    /*
     * Update the respective URL field
     */
    @AuraEnabled
    public static boolean updateURLs(id oppId, String objectApiName, Map<String,String> editedRecords, string urlField ) {
        Boolean rtnVal = false;
        if (objectApiName=='Opportunity') {
            String urlValue = editedRecords.get(urlField);
            if (urlValue == '' || urlValue == null)  return false;
            Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
            opp.put(urlField,urlValue);
            try {
                update opp;
                rtnVal = true;
            } catch(DMLException ex){
                System.debug(ex.getMessage());
                throw new AuraHandledException(ex.getMessage());
            } catch(Exception ex){
                //throw all other exception message
                System.debug('There was an error updating the URL on the Opportunity - ' + ex.getMessage());
                throw new AuraHandledException(ex.getMessage());
            }
        }
        return rtnVal;
    }
}