/**
 * @description       : AccountsMetadata_Req_IB_v1
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-05-27
 * @last modified by  : André Pietersen (IQ Business)
 * Ver   Date         Author                               Modification
 * 1.0   2021-05-27   André Pietersen (IQ Business)   Initial Version
**/
public class AccountsMetadata_Req_IB_v1 extends Base_IB {
    public string applicationDateTime;
    public string applicationNumber;
    public Channel channel;
    public string crpCode;
    public string cifcode;
    public string accountnumber;
    public HoldDetails holddetails;

    /**
    * @description Channel class
    **/
    public class Channel {
        public ChannelDetails channelDetails;
    }

    /**
    * @description ChannelDetails class
    **/
    public class ChannelDetails {
        public string branchcode;
        public string branchsitetype;
        public string sitetypeagency;
        public string agencycode;
        public string tellernumber;
        public string supervisorcode;
        public string channelname;
    }

    /**
    * @description HoldDetails class
    **/
    public class HoldDetails {
        public string FRAUD;
        public string RBA;
        public string CASA;
    }

    /**
    * @description
    * @author André Pietersen (IQ Business) | 2021-05-27
    * @return AccountsMetadata_Req_IB_v1
    **/
    public static AccountsMetadata_Req_IB_v1 createDummyRequest() {
        AccountsMetadata_Req_IB_v1 requestBean = new AccountsMetadata_Req_IB_v1();
        requestBean.channel = new AccountsMetadata_Req_IB_v1.Channel();
        requestBean.channel.channelDetails = new AccountsMetadata_Req_IB_v1.ChannelDetails();
        requestBean.holddetails = new AccountsMetadata_Req_IB_v1.HoldDetails();

        requestBean.applicationDateTime = '2012-01-31 23:59:59';
        requestBean.applicationNumber = '1234';

        requestBean.channel.channelDetails.branchcode = '8198;';
        requestBean.channel.channelDetails.branchsitetype = '034';
        requestBean.channel.channelDetails.sitetypeagency = '34';
        requestBean.channel.channelDetails.agencycode = '8198';
        requestBean.channel.channelDetails.tellernumber = '123456';
        requestBean.channel.channelDetails.supervisorcode = '91568';
        requestBean.channel.channelDetails.channelname = 'F';

        requestBean.crpCode = 'ABC';
        requestBean.cifcode = '1234567890';
        requestBean.accountnumber = '12345';

        requestBean.holddetails.FRAUD = 'SUSPECT';
        requestBean.holddetails.RBA = 'M';
        requestBean.holddetails.CASA = 'PROCEED';

        return requestBean;
    }
}