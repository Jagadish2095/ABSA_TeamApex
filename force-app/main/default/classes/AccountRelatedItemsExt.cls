/**
 * Class for retriving account related records
 * @author  Koketso Mpshane
 * @date    09/04/2020
 */

public class AccountRelatedItemsExt {
    @AuraEnabled
    public static Map<String, List<Case>> fetchClientCases(String accountId) {
        Map<String, List<Case>> casesListMap = new Map<String, List<Case>>();
        List<Case> openCases = new List<Case>();
        List<Case> closedCases = new List<Case>();

        List<Case> casesList = [
            SELECT Id, CaseNumber, Subject, Status, CreatedDate, ClosedDate, IsClosed, RecordType.Name
            FROM Case
            WHERE AccountId = :accountId AND Status != 'Unwanted' AND (RecordType.DeveloperName = :'Complaint' OR RecordType.DeveloperName = :'ATM')
            ORDER BY CreatedDate DESC
        ];

        if (casesList.size() > 0) {
            for (Case cse : casesList) {
                if (cse.IsClosed) {
                    closedCases.add(cse);
                } else {
                    openCases.add(cse);
                }
            }
        }

        casesListMap.put('Open', openCases);
        casesListMap.put('Closed', closedCases);

        system.debug(LoggingLevel.FINE, '***casesListMap***' + casesListMap);

        return casesListMap;
    }
}