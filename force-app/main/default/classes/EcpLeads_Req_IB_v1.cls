/**
 * @author Rajesh Nandigam
 * @since 2021-07-20
 * @description Ecp Leads Request Wrapper
 **/
public class EcpLeads_Req_IB_v1 extends Base_IB{
    public String emailAddress;
    public String campaign;
    public String backupContactNumber;
    public String campaignType;
    public String fromNumber;
    public String firstName;
    public String nextTry;
    public String lastName;
    public String replyTime;
    public String originalMsg;
    public String replyMessage;
    public String packageId;
    public String senderReference;
    
   /**
 * @since 2021-07-20
 * @description Ecp Leads Request Wrapper
 * @return EcpLeads
 **/
    public static EcpLeads_Req_IB_v1 createDummyRequest(){
        EcpLeads_Req_IB_v1 EcpLeads = new EcpLeads_Req_IB_v1();
        EcpLeads.senderReference = 'Absa';
        EcpLeads.replyMessage = '';
        EcpLeads.replyTime = '2021-03-09T17:07:28Z';
        EcpLeads.nextTry = '2021-05-01T09:00:00Z';
        EcpLeads.fromNumber = '0820000000';
        EcpLeads.backupContactNumber = '0110000000';
        EcpLeads.emailAddress = 'jitterbit23@email.com';
        EcpLeads.campaign = 'Free Text';
        EcpLeads.campaignType = 'Free Text';
        EcpLeads.firstName =  'Test';
        EcpLeads.lastName = 'Test';
        EcpLeads.originalMsg = 'Something the customer may have seen before';
        EcpLeads.packageId = 'sim-sme';
        
       
        return EcpLeads;
    } 
    
}