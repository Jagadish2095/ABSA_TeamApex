/**
* Apex Integration Request Bean class for WQlistRelationshipsV1
* @author  Anka Ganta : Absa
* @since   2020-07-20
*
**/
public class WQgetCASADetailsByRefNoV7_Resp_IB_v1 extends Base_IB{
    public WQgetCASADetailsByRefNoV7Response WQgetCASADetailsByRefNoV7Response;
    public Integer statusCode;

	public class WQgetCASADetailsByRefNoV7Response {
		public String approvedSts;
		public String clientTypeGrp;
		public String cntryOfRes;
		public String countryOfBirth;
		//public String dateTime;
		public Integer dob;
		public String documentSts;
		public String firstName;
		public String idRegNo;
		public Integer idType;
		public String msg;
		public Integer msgNo;
		public String nationality;
		public Integer noParticipants;
		public String pepSts;
		public Integer primaryClient;
		public List<RelatedParties> relatedParties;
		public String riskRequired;
		public String sbu;
		public String status;
		public String surnameComp;
	}

	public class RelatedParties {
		public String rApprovedSts;
		public String rClientTypeGrp;
		public String rCntryOfRes;
		public String rCountryOfBirth;
		public Integer rDob;
		public String rFirstName;
		public String rIdRegNo;
		public Integer rIdType;
		public String rNationality;
		public String rPepSts;
		public Integer rRefNo;
		public Integer rRelationship;
		public String rStatus;
		public String rSurnameComp;
	}
    
    public static WQgetCASADetailsByRefNoV7_Resp_IB_v1 createDummyResponse(){
         WQgetCASADetailsByRefNoV7_Resp_IB_v1 respBean = new WQgetCASADetailsByRefNoV7_Resp_IB_v1();
        WQgetCASADetailsByRefNoV7_Resp_IB_v1.WQgetCASADetailsByRefNoV7Response WQgetCASADetailsByRefNoV7ResponseBean = new WQgetCASADetailsByRefNoV7_Resp_IB_v1.WQgetCASADetailsByRefNoV7Response();
         WQgetCASADetailsByRefNoV7_Resp_IB_v1.RelatedParties RelatedPartiesBean= new WQgetCASADetailsByRefNoV7_Resp_IB_v1.RelatedParties();
        List<WQgetCASADetailsByRefNoV7_Resp_IB_v1.RelatedParties> RelatedPartiesBeanList= new List<WQgetCASADetailsByRefNoV7_Resp_IB_v1.RelatedParties>();
        RelatedPartiesBean.rApprovedSts = '';
        RelatedPartiesBean.rClientTypeGrp = 'I';
        RelatedPartiesBean.rCntryOfRes = 'SO003';
        RelatedPartiesBean.rCountryOfBirth = 'SO003';
        RelatedPartiesBean.rDob = 19911222;
        RelatedPartiesBean.rFirstName = 'LEDIKE EPHRAIM';
        RelatedPartiesBean.rIdRegNo = '9112225706088';
        RelatedPartiesBean.rIdType = 1;
        RelatedPartiesBean.rNationality = 'SOU01';
        RelatedPartiesBean.rPepSts = '';
        RelatedPartiesBean.rRefNo = 121116974;
        RelatedPartiesBean.rRelationship = 111222;
         RelatedPartiesBean.rStatus = 'C';
        RelatedPartiesBean.rSurnameComp = 'MAHLARE';
        RelatedPartiesBeanList.add(RelatedPartiesBean);
        WQgetCASADetailsByRefNoV7ResponseBean.approvedSts = '';
        WQgetCASADetailsByRefNoV7ResponseBean.clientTypeGrp = 'N';
        WQgetCASADetailsByRefNoV7ResponseBean.cntryOfRes = 'SO003';
        WQgetCASADetailsByRefNoV7ResponseBean.countryOfBirth = '';
        //WQgetCASADetailsByRefNoV7ResponseBean.approvedSts = '';
        WQgetCASADetailsByRefNoV7ResponseBean.dob = 0;
        WQgetCASADetailsByRefNoV7ResponseBean.documentSts = 'C';
        WQgetCASADetailsByRefNoV7ResponseBean.firstName = '';
        WQgetCASADetailsByRefNoV7ResponseBean.idRegNo = '200801284907';
        WQgetCASADetailsByRefNoV7ResponseBean.idType = 5;
        WQgetCASADetailsByRefNoV7ResponseBean.msg = '';
        WQgetCASADetailsByRefNoV7ResponseBean.msgNo = 0;
         WQgetCASADetailsByRefNoV7ResponseBean.nationality = 'SOU01';
        WQgetCASADetailsByRefNoV7ResponseBean.noParticipants = 2;
        WQgetCASADetailsByRefNoV7ResponseBean.pepSts = '';
        WQgetCASADetailsByRefNoV7ResponseBean.relatedParties = RelatedPartiesBeanList;
        WQgetCASADetailsByRefNoV7ResponseBean.riskRequired = 'Y';
        WQgetCASADetailsByRefNoV7ResponseBean.sbu = 'H';
        WQgetCASADetailsByRefNoV7ResponseBean.status = 'C';
        WQgetCASADetailsByRefNoV7ResponseBean.surnameComp = 'MAINSAIL TRADING 136 (PTY) LTD';
        respBean.WQgetCASADetailsByRefNoV7Response = WQgetCASADetailsByRefNoV7ResponseBean;
        return respBean;
    }
    
    
}