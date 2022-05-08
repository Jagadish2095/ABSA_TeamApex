/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-12-08
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
public class CIupdJointPByClientCodeV7_IU_v1 {

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-11-29 
    * @param acc 
    * @param jointsCIF 
    * @param nbrOfRecords 
    * @param translations 
    * @param responseBeanJointsParticipants 
    * @return CIupdJointPByClientCodeV7_IB_Req_v1 
    **/
    public static CIupdJointPByClientCodeV7_IB_Req_v1 mapJointsRequestFields(Account acc , String jointsCIF , integer nbrOfRecords, Map<String,String> translations , GetJointParticipant_Resp_IB_v1 responseBeanJointsParticipants){
        
        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
        
        List<Integration_Translation__c> occupationCodelist = getUpdateCIF_IU_v1.getintegrationTranslation(acc.Occupation_Category__pc,'Occupation Category');
        List<Integration_Translation__c> occupationStatusCodelist = getUpdateCIF_IU_v1.getintegrationTranslation(acc.Occupation_Status__pc,'Occupation Status');
        List<Integration_Translation__c> incomeCodelist = getUpdateCIF_IU_v1.getintegrationTranslation(acc.Income_Source__pc,'Source of Income');
        
        CIupdJointPByClientCodeV7_IB_Req_v1 requestBean = new CIupdJointPByClientCodeV7_IB_Req_v1();
        requestBean.CIupdJointParticipantsByClientCodeV7 = new CIupdJointPByClientCodeV7_IB_Req_v1.CIupdJointParticipantsByClientCodeV7();
        requestBean.CIupdJointParticipantsByClientCodeV7.nbsapdpi = new CIupdJointPByClientCodeV7_IB_Req_v1.Nbsapdpi();
        requestBean.CIupdJointParticipantsByClientCodeV7.nbsapdpi.channel = 'Salesforce';
        requestBean.CIupdJointParticipantsByClientCodeV7.nbsapdpi.application = 'Salesforce';
        requestBean.CIupdJointParticipantsByClientCodeV7.nbsapdpi.trace = 'Y';
        
        requestBean.CIupdJointParticipantsByClientCodeV7.nbsmsgi = new CIupdJointPByClientCodeV7_IB_Req_v1.Nbsmsgi();
        requestBean.CIupdJointParticipantsByClientCodeV7.nbsmsgi.msgLanguage = 'E';
        requestBean.CIupdJointParticipantsByClientCodeV7.nbsmsgi.msgTarget = 'STD';
        requestBean.CIupdJointParticipantsByClientCodeV7.nbsmsgi.finalMsgId = new CIupdJointPByClientCodeV7_IB_Req_v1.FinalMsgId();
        requestBean.CIupdJointParticipantsByClientCodeV7.nbsmsgi.finalMsgId.finalMsgClass = '';
        requestBean.CIupdJointParticipantsByClientCodeV7.nbsmsgi.finalMsgId.finalMsgCode = '';
        
        requestBean.CIupdJointParticipantsByClientCodeV7.cib033i = new CIupdJointPByClientCodeV7_IB_Req_v1.Cib033i();
        requestBean.CIupdJointParticipantsByClientCodeV7.cib033i.clientCode = jointsCIF;
        requestBean.CIupdJointParticipantsByClientCodeV7.cib033i.teller = !String.isBlank(currentUser.Teller_Operator_Code__c) ? Integer.valueOf(currentUser.Teller_Operator_Code__c) : 0;
        requestBean.CIupdJointParticipantsByClientCodeV7.cib033i.branch = !String.isBlank(currentUser.SiteCode__c) ? Integer.valueOf(currentUser.SiteCode__c) : 0;
        requestBean.CIupdJointParticipantsByClientCodeV7.cib033i.nbrOfRecords = nbrOfRecords;
        
        requestBean.CIupdJointParticipantsByClientCodeV7.cib033i.jntEntry = new List<CIupdJointPByClientCodeV7_IB_Req_v1.JntEntry>();
        
        CIupdJointPByClientCodeV7_IB_Req_v1.JntEntry jntList = new CIupdJointPByClientCodeV7_IB_Req_v1.JntEntry();
        if(responseBeanJointsParticipants != null){
            if(responseBeanJointsParticipants.jntEntry != null && responseBeanJointsParticipants.jntEntry.size() > 0){
                for(GetJointParticipant_Resp_IB_v1.cls_JntEntry jntListObj : responseBeanJointsParticipants.jntEntry){
                    if(jntListObj.idNumber == acc.ID_Number__pc){
                        jntList.actionCode = 'M';
             			jntList.idDocType = 1;
             			jntList.idDocNbr = Long.valueOf(acc.ID_Number__pc);
             			jntList.initials = acc.Initials__pc;
             			jntList.titleCode = translations.get(acc.PersonTitle+''+'CIF'+''+'Title'+''+'Outbound') != null ? Integer.valueOf(translations.get(acc.PersonTitle+''+'CIF'+''+'Title'+''+'Outbound')) : 0;
             			jntList.surname = acc.LastName;
             			jntList.addressLine1 = String.valueOf(acc.ShippingStreet);
             			jntList.addressLine2 = '';
             			jntList.suburbRsa = acc.ShippingState;
             			jntList.town = acc.ShippingCity;
             			jntList.postalCode = Integer.valueOf(acc.ShippingPostalCode);
             			jntList.firstNames = acc.FirstName;
             			jntList.homeTelephoneCode = Integer.valueOf(jntListObj.homeTelCode);
             			jntList.homeTelephoneNbr = jntListObj.homeTelephone != '' ? Integer.valueOf(jntListObj.homeTelephone) : 0;
             			jntList.workTelephoneCode = jntListObj.workTelCode != '' ? Integer.valueOf(jntListObj.workTelCode) : 0;
             			jntList.workTelephoneNbr = jntListObj.workTelephone != '' ? Integer.valueOf(jntListObj.workTelephone) : 0;
             			jntList.cellphoneNbr = jntListObj.cellphone != '' ? Integer.valueOf(jntListObj.cellphone) : 0;
             			jntList.practiceNumber = jntListObj.practiceNumber != '' ? jntListObj.practiceNumber : '';
             			jntList.birthDate = jntListObj.birthDate != '' ? Integer.valueOf(jntListObj.birthDate.replace('-','')) : 0;
             			jntList.sourceOfIncome = translations.get(acc.Income_Source__pc+''+'CIF'+''+'Source of Income'+''+'Outbound') != null ? Integer.valueOf(translations.get(acc.Income_Source__pc+''+'CIF'+''+'Source of Income'+''+'Outbound')) : 0;
             			jntList.dateClientFicaIden = 0;
             			jntList.dateClientFicaIden = Integer.valueOf(jntListObj.dateIdentified);
             			jntList.dateClientFicaVeri = Integer.valueOf(jntListObj.dateVerified);
             			jntList.employeeIdentified = jntListObj.employeeIdentified;
             			jntList.employeeVerified = jntListObj.employeeVerified;
             			jntList.taxNumber = jntListObj.taxNumber != '' ? Integer.valueOf(jntListObj.taxNumber) : 0;
             			jntList.clientNationality = translations.get(acc.Nationality__pc+''+'eCasa'+''+'Nationality'+''+'Outbound');
             			jntList.countryOfOrigin = translations.get(acc.Country_of_Origin__pc+''+'CIF'+''+'Country'+''+'Outbound') != null ? translations.get(acc.Country_of_Origin__pc+''+'CIF'+''+'Country'+''+'Outbound') : '';
             			jntList.tempPermitNumber = jntListObj.tempPermitNumber != '' ? jntListObj.tempPermitNumber : '';
             			jntList.permitExpiryDate = jntListObj.permitExpiryDate != '' ? Integer.valueOf(jntListObj.permitExpiryDate) : 0;
             			jntList.controllerOverideNbr = 0;
             			jntList.groupScheme = jntListObj.groupScheme != '' ? Integer.valueOf(jntListObj.groupScheme) : 0;
             			jntList.groupSchemeEmployee = jntListObj.groupSchemeEmp != '' ? jntListObj.groupSchemeEmp : '';
             			jntList.dateIssued = jntListObj.dateIssued != '' ? Integer.valueOf(jntListObj.dateIssued) : 0;
             			jntList.dateExempted = jntListObj.dateExempted != '' ? Integer.valueOf(jntListObj.dateExempted) : 0;
             			jntList.employeeExempted = jntListObj.empExempted != '' ? Integer.valueOf(jntListObj.empExempted) : 0;
             			jntList.exemptionStatus = jntListObj.statusOfExempt != '' && jntListObj.statusOfExempt != 'N' ? Integer.valueOf(jntListObj.statusOfExempt) : 0;
             			jntList.countryOfRes = jntListObj.countryOfRes != '' ? jntListObj.countryOfRes : '';
             			jntList.countryOfBirth = translations.get(acc.Nationality__pc+''+'eCasa'+''+'Nationality'+''+'Outbound');
             			jntList.occupationStatus = translations.get(acc.Occupation_Status__pc+''+'CIF'+''+'Occupation Status'+''+'Outbound') != null ? Integer.valueOf(translations.get(acc.Occupation_Status__pc+''+'CIF'+''+'Occupation Status'+''+'Outbound')) : 0;
             			jntList.occupationCode = translations.get(acc.Occupation_Category__pc+''+'CIF'+''+'Occupation Category'+''+'Outbound') != null ? Integer.valueOf(translations.get(acc.Occupation_Category__pc+''+'CIF'+''+'Occupation Category'+''+'Outbound')): 0;
             			jntList.saTaxRegis = jntListObj.saTaxRegis != '' ? jntListObj.saTaxRegis : '';
             			jntList.rsonSaTaxNotGiven = jntListObj.rsonSaTaxNotGiven != '' ? jntListObj.rsonSaTaxNotGiven : '';
             			jntList.foreignTaxRegis = jntListObj.rsonSaTaxNotGiven != '' ? jntListObj.rsonSaTaxNotGiven : '';
                    }
                }
            }
        }
              
             requestBean.CIupdJointParticipantsByClientCodeV7.cib033i.jntEntry.add(jntList);
             return requestBean;
    }

}