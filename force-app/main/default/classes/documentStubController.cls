/**
 * ** Tinashe m Shoko
 *
 * @description generic generate Documents Component
 * split generatedocument class
 */
public with sharing class documentStubController {
    /**
     * @description generateDoc description
     *
     * @param oppId (Id): oppId
     * @param templatename (string): templatename
     * @return Map<String,String>: Return description
     */
    @AuraEnabled
    public static Map<String, String> generateDoc(Id oppId, string templatename) {
        if (templateName == 'ABSA 6157 EX - OD Facility Letter'){
            return GenerateCreditDocuments.generateFacilityLetter(oppId, templateName);
        }

        if (templateName == 'Credit Onboarding Quote') {
            return GenerateCreditDocuments.generateOverdraftQuoteAgreement(oppId, templateName);
        }

        return GenerateCreditDocuments.generateCreditDocs(oppId, templatename);
    }
}