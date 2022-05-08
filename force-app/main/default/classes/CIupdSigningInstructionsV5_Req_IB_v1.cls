/*
 * Request Integration Bean for CIupdSigningInstructionsV5 Service
 * @author Prashant Jain
 * @created 2020-02-25
 */

public class CIupdSigningInstructionsV5_Req_IB_v1 extends Base_IB {

	public class InputTable {
		public String changeOption;
		public String csaRefNbr;
		public String titleNew;
		public String initialsNew;
		public String surnameNew;
		public String nameNew;
		public String idTypeNew;
		public String idNbrNew;
		public String dateIssuedNew;
		public String compulsorySignNew;
		public String idTypeOld;
		public String idNbrOld;
		public String physicalAdd1;
		public String physicalAdd2;
		public String physicalSuburb;
		public String physicalTown;
		public String physicalPostal;
		public String clientNationality;
		public String countryOfOrigin;
		public String countryResAddress;
		public String birthOpCountry;
		public String homeTelCode;
		public String homeTelephone;
		public String emailAddress;
		public String gender;
		public String birthDate;
		public String occupationStatus;
		public String occupationCode;
		public String designation;
	}

	public CIupdSigningInstructionsV5 CIupdSigningInstructionsV5;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class CIupdSigningInstructionsV5 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Cip202i cip202i;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}

	public class Cip202i {
		public String accountNumber;
		public String option;
		public String siteCode;
		public String siteType;
		public String tellerNumber;
		public String agencyCode;
		public String supervisorOverride;
		public String nbrRecord;
		public String chgSpecialCondition;
		public String nbrSignOperAccNew;
		public String specialConditionNew;
		public InputTable inputTable;
	}

    public static CIupdSigningInstructionsV5_Req_IB_v1 createDummyRequest() {
        CIupdSigningInstructionsV5_Req_IB_v1 requestBean = new CIupdSigningInstructionsV5_Req_IB_v1();
		requestBean.CIupdSigningInstructionsV5 = new CIupdSigningInstructionsV5_Req_IB_v1.CIupdSigningInstructionsV5();
		requestBean.CIupdSigningInstructionsV5.nbsapdpi = new CIupdSigningInstructionsV5_Req_IB_v1.Nbsapdpi();
		requestBean.CIupdSigningInstructionsV5.nbsmsgi = new CIupdSigningInstructionsV5_Req_IB_v1.Nbsmsgi();
		requestBean.CIupdSigningInstructionsV5.cip202i = new CIupdSigningInstructionsV5_Req_IB_v1.Cip202i();
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable = new CIupdSigningInstructionsV5_Req_IB_v1.InputTable();
		
		requestBean.CIupdSigningInstructionsV5.nbsapdpi.channel = 'ESP';
		requestBean.CIupdSigningInstructionsV5.nbsapdpi.application = 'ESP';
		requestBean.CIupdSigningInstructionsV5.nbsapdpi.trace = 'N';
		
		requestBean.CIupdSigningInstructionsV5.nbsmsgi.msgLanguage = 'E';
		requestBean.CIupdSigningInstructionsV5.nbsmsgi.msgTarget = 'STD';
		
		requestBean.CIupdSigningInstructionsV5.cip202i.accountNumber = '9051254302';
		requestBean.CIupdSigningInstructionsV5.cip202i.option = 'N';
		requestBean.CIupdSigningInstructionsV5.cip202i.siteCode = '8198';
		requestBean.CIupdSigningInstructionsV5.cip202i.siteType = '0';
		requestBean.CIupdSigningInstructionsV5.cip202i.tellerNumber = '993';
		requestBean.CIupdSigningInstructionsV5.cip202i.agencyCode = '0';
		requestBean.CIupdSigningInstructionsV5.cip202i.supervisorOverride = '111';
		requestBean.CIupdSigningInstructionsV5.cip202i.nbrRecord = '1';
		requestBean.CIupdSigningInstructionsV5.cip202i.chgSpecialCondition = '';
		requestBean.CIupdSigningInstructionsV5.cip202i.nbrSignOperAccNew = '0001';
		requestBean.CIupdSigningInstructionsV5.cip202i.specialConditionNew = '';
		
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.changeOption = 'N';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.csaRefNbr = '888';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.titleNew = '01';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.initialsNew = 'S';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.surnameNew = 'SAM';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.nameNew = 'FANIE';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.idTypeNew = '03';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.idNbrNew = 'HHJJJ080';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.dateIssuedNew = '19990919';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.compulsorySignNew = 'N';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.idTypeOld = '0';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.idNbrOld = '';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.physicalAdd1 = '100 WEST STREET';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.physicalAdd2 = '';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.physicalSuburb = 'JHB';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.physicalTown = 'JHB';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.physicalPostal = '2001';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.clientNationality = 'SOU01';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.countryOfOrigin = 'SO003';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.countryResAddress = 'SO003';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.birthOpCountry = 'SO003';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.homeTelCode = '011';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.homeTelephone = '5079259';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.emailAddress = '';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.gender = '1';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.birthDate = '19320101';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.occupationStatus = '01';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.occupationCode = '02';
		requestBean.CIupdSigningInstructionsV5.cip202i.inputTable.designation = '02';

        return requestBean;
    }
}