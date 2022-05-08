public class MandateValidation {
    
    @AuraEnabled
    public static Map<String, String> getMandate(String accNr) {
        Map<String, String> mandateMap = new Map<String, String>();
        Map<CIgetSigningInstructionsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetSigningInstructionsV4_IH_v1.CIgetSigningInstructionsV4(
            accNr,
            '8198',
            '5'
        );
        if (responseMap != null) {
            CIgetSigningInstructionsV4_Resp_IB_v1 responseBean = (new List<CIgetSigningInstructionsV4_Resp_IB_v1>(responseMap.keySet()))[0];
            List<Sys_Log_Integration__c> sysLog = new List<Sys_Log_Integration__c>(responseMap.values()[0]);
            if (sysLog != null) {
                insert sysLog;
            }
            CIgetSigningInstructionsV4_Resp_IB_v1.Cip082do respData = responseBean?.CIgetSigningInstructionsV4Response?.cip082do;
            if (respData != null) {
                List<CIgetSigningInstructionsV4_Resp_IB_v1.OutputTable> outputTableList = respData.outputTable;
                if (outputTableList != null && outputTableList.size() > 0) {
                    CIgetSigningInstructionsV4_Resp_IB_v1.OutputTable outputTable = outputTableList.get(0);
                    mandateMap.put('Designation', outputTable.designation);
                    mandateMap.put('Special Conditions', respData.specialConditions);
                    mandateMap.put('Date Issued', outputTable.dateIssued);
                    mandateMap.put('Initials', outputTable.initials);
                    mandateMap.put('Surname', outputTable.surname);
                    mandateMap.put('Name', outputTable.name);
                    mandateMap.put('ID Number', outputTable.idNbr);
                    mandateMap.put('Compulsory', outputTable.compulsorySign);
                    mandateMap.put('CIF', respData.clientCode);
                    mandateMap.put('Number of Signatories Required', respData.nbrSignReqOperAcc);
                }
            }
        }
        return mandateMap;
    }
}