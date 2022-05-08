/**
* Integration Request Bean for Switching Institutions
* @author André Pietersen
* @created 2020-09-25
*/
public class SwitchingInstitutions_Req_IB_v1 extends Base_IB 
{
    public String name {get;set;}
    public String debitOrderAutomatedEmail {get;set;}
    public String salaryAutomatedEmail {get;set;}
    public String contactEmail {get;set;}
    public String contactPerson {get;set;}
    public Integer debitOrderAcknowledgeHoursSLA {get;set;}
    public Integer salaryAcknowledgeHoursSLA {get;set;}
    public String route {get;set;}
    public String contactDepartment {get;set;}
    public String batchFileType {get;set;}
    public String batchFormatterType {get;set;}
    public String batchIntegrationType {get;set;}
    public String connectionPrefix {get;set;}
    public String template {get;set;}

    public static SwitchingInstitutions_Req_IB_v1 createDummyRequest() 
    {
        SwitchingInstitutions_Req_IB_v1 requestBean = new SwitchingInstitutions_Req_IB_v1();

        requestBean.name = 'Cloudy Pears';
        requestBean.contactEmail = 'some@email.com';
        requestBean.contactPerson = 'Some Person';
        requestBean.contactDepartment = 'Some Department';
        requestBean.salaryAutomatedEmail = 'some@email.com';
        requestBean.route = 'NON_PARTICIPATING';
        requestBean.debitOrderAutomatedEmail = '';
        requestBean.debitOrderAcknowledgeHoursSLA = 0;
        requestBean.salaryAcknowledgeHoursSLA = 0;
        requestBean.batchFileType = '';
        requestBean.batchFormatterType = '';
        requestBean.batchIntegrationType = '';
        requestBean.connectionPrefix = '';
        requestBean.template = '';

        return requestBean;
    }
}