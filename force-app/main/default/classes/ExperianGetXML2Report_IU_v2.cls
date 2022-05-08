/*
 * Integration Utility class for ExperianGetXML2Report Service version 2
 * @author Danie Booysen
 * @created 2020-09-30
 */

public class ExperianGetXML2Report_IU_v2 {

    /* Creates a request bean
     * @return: ExperianGetXML2Report_Req_IB_v2 bean object
     */
    public static ExperianGetXML2Report_Req_IB_v2 mapRequestFields(List<Contact> directorsListP) {
        ExperianGetXML2Report_Req_IB_v2 requestBean = new ExperianGetXML2Report_Req_IB_v2();
        ExperianGetXML2Report_Req_IB_v2.GetXML2Report getXML2ReportObj;
        List<ExperianGetXML2Report_Req_IB_v2.GetXML2Report> GetXML2ReportList = new List<ExperianGetXML2Report_Req_IB_v2.GetXML2Report>();

        for(Contact con : directorsListP){
            getXML2ReportObj = new ExperianGetXML2Report_Req_IB_v2.GetXML2Report();

            getXML2ReportObj.RequestType = 'XML2';

            if (Sys_Utilities_General.getEnvironment() == StringConstants.PRODUCTION_STRING) {
                getXML2ReportObj.Environment_Name = 'PRODUCTION';
            } else {
                getXML2ReportObj.Environment_Name = 'TEST';
            }

            getXML2ReportObj.GroupName = System.Label.Experian_GroupName;
            getXML2ReportObj.User_Name = System.Label.Experian_User_Name;
            getXML2ReportObj.User_Password = System.Label.Experian_User_Password;
            getXML2ReportObj.Subscriber_Name = System.Label.Experian_Subscriber_Name;
            getXML2ReportObj.Subscriber_ID = System.Label.Experian_Subscriber_ID;
            getXML2ReportObj.Subscriber_Password = System.Label.Experian_Subscriber_Password;
            getXML2ReportObj.Subscriber_Group_ID = System.Label.Experian_Subscriber_Group_ID;

            getXML2ReportObj.Surname = con.Lastname != null ? con.Lastname : null;
            getXML2ReportObj.First_Name_1 = con.Firstname != null ? con.Firstname : null;
            getXML2ReportObj.National_ID = con.ID_Number__c != null ? con.ID_Number__c : null;
            getXML2ReportObj.Birthday = con.Birthdate != null ? String.valueOf(con.Birthdate).replace('-','') : null;

            if(con.ID_Type__c != null){
                if(con.ID_Type__c == 'SA Identity Document'){
                    getXML2ReportObj.RSAid = 'YES';
                }else{
                    getXML2ReportObj.RSAid = 'NO';
                }
            }
            GetXML2ReportList.add(getXML2ReportObj);
        }
        requestBean.GetXML2Report = GetXML2ReportList;
        return requestBean;
    }
}