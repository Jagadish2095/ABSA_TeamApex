/**
 * @description  Request Integration Bean for WQcancelRelatedPartyV2 Service
 * @author Happy Baloyi
 */
public without sharing class WQcancelRelatedPartyV2_Req_IB_v1 extends Base_IB{
  public WQCancelRelatedV7Request WQCancelRelatedV7Request;
/**
 * @description  WQCancelRelatedV7Request
 */    public class  WQCancelRelatedV7Request
  {
    public string PrimaryRef;
    public string RelatedRef;
    public string OriginatingSystem;
    public string InitialAB;
  }
/**
 * @description  getNewInstance
 * @return WQcancelRelatedPartyV2_Req_IB_v1
 */
public static WQcancelRelatedPartyV2_Req_IB_v1 getNewInstance()
{
  WQcancelRelatedPartyV2_Req_IB_v1 request = new WQcancelRelatedPartyV2_Req_IB_v1();
  request.WQCancelRelatedV7Request = new WQcancelRelatedPartyV2_Req_IB_v1.WQCancelRelatedV7Request();
  return request;
}
/**
 * @description  createDummyRequestV3
 * @return WQcancelRelatedPartyV2_Req_IB_v1
 */
public static WQcancelRelatedPartyV2_Req_IB_v1 createDummyRequestV3() { 
  WQcancelRelatedPartyV2_Req_IB_v1 request = getNewInstance();  
    request.WQCancelRelatedV7Request.InitialAB = 'WA';
  request.WQCancelRelatedV7Request.OriginatingSystem = 'BDO';
  request.WQCancelRelatedV7Request.PrimaryRef ='1212';
  request.WQCancelRelatedV7Request.RelatedRef ='2344';
  return request;
}
}