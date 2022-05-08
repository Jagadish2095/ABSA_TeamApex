/*
* Request Integration Bean for Tracker Service for Absa Instant Life
* @author Satya Boyenepalli
* @created 2021-07-28
*/

/**
* @description Tracker Request
*/
public with sharing class Tracker_Req_IB_v1 extends Base_IB {
    /**
* @description PartyId
*/
    public String PartyId;
    /**
* @description UserName
*/
    public String UserName;
    /**
* @description Password
*/
    public String Password;
    /**
* @description CampaignId
*/
    public String CampaignId;
    /**
* @description createDummyRequest
  @return Tracker_Req_IB_v1
*/
    public static Tracker_Req_IB_v1 createDummyRequest() {
        Tracker_Req_IB_v1 requestBean = new Tracker_Req_IB_v1();
        requestBean.CampaignId='8474-ABRB602';
        requestBean.Password='FredSmith1';
        requestBean.PartyId='133963';
        requestBean.UserName='leo@intellimin.com';
        return requestBean;
    }
}