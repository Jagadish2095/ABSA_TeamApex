/**
* Integration Handler for Switches
* @author Edgar Blount
* @created 2020-09-25
*/
public class Switches_IH_v1 {
    
    public static final String SwitchesPOST = 'Switches POST';
    public static final String SwitchesGET = 'Switches GET';
    public static final String SwitchesPUT = 'Switches PUT';
    
    public static Switches_Resp_IB_v1 createSwitch(Switches_Req_IB_v1 requestBean){
        Switches_Resp_IB_v1 responseBean = (Switches_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, SwitchesPOST, Switches_Resp_IB_v1.class);
        return responseBean;
    }

    public static Switches_Resp_IB_v1 switchTrigger(String switchId, String switchTrigger)    
    {
        Switches_Resp_IB_v1 responseBean = (Switches_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(null,'/'+ switchId +'/trigger?triggerName=' + switchTrigger, SwitchesGET, Switches_Resp_IB_v1.class);
        return responseBean;
    }

    public static Switches_Resp_IB_v1 getSwitch(String switchId)    
    {
        Switches_Resp_IB_v1 responseBean = (Switches_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(null,'/'+ switchId, SwitchesGET, Switches_Resp_IB_v1.class);
        return responseBean;
    }

    public static String getSwitchLetter(String switchId)
    {
        Sys_Utilities_Integration_StringBody_IB responseBean = (Sys_Utilities_Integration_StringBody_IB) Sys_Utilities_Integration.integrationServiceCall(null,'/' + switchId + '/letter', SwitchesGET, Sys_Utilities_Integration_StringBody_IB.class);
        return responseBean.body; 
    }

    public static String LinkCustomerSwitch(String switchId, String customerLink)
    {
   
        Sys_Utilities_Integration_StringBody_IB requestbean = new Sys_Utilities_Integration_StringBody_IB();
        requestbean.body =  customerLink;
        Sys_Utilities_Integration_StringBody_IB responseBean = (Sys_Utilities_Integration_StringBody_IB) Sys_Utilities_Integration.integrationServiceCall(requestbean, '/' + switchId + '/customer', SwitchesPUT, Sys_Utilities_Integration_StringBody_IB.class);
        return responseBean.body; 
    }

    public static String LinkInstitutionSwitch(String switchId, String institutionLink)
    {
        Sys_Utilities_Integration_StringBody_IB requestbean = new Sys_Utilities_Integration_StringBody_IB();
        requestbean.body =  institutionLink;
        Sys_Utilities_Integration_StringBody_IB responseBean = (Sys_Utilities_Integration_StringBody_IB) Sys_Utilities_Integration.integrationServiceCall(requestbean, '/' + switchId + '/institution', SwitchesPUT, Sys_Utilities_Integration_StringBody_IB.class);
        return responseBean.body; 
    }    
}