/*
 * Request Integration Bean for MpsCreatePoshMerchantv3 Service
 * @author Prashant Jain
 * @created 2020-05-08
 */

public class MpsCreatePoshMerchantv3_Req_IB_v1 extends Base_IB {

	public MPScreatePOSHMerchantV3 MPScreatePOSHMerchantV3;

	public class DeviceTable {
		public String termBranchId;
		public String deviceId;
		public String feeCode;
		public String dialTime;
	}

	public class Zbp006i {
		public String mrchAcctNbr;
		public String refNum;
		public String action;
		public String groupId;
		public String shortMrchName;
		public String config;
		public String mrchClass;
		public String floorLimit;
		public String supvCardInd;
		public String cvRetMode;
		public String monitorFlag;
		public String monitorDays;
		public String postilionInd;
		public String branchId;
		public List<DeviceTable> deviceTable;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class MPScreatePOSHMerchantV3 {
		public Nbsapdpi nbsapdpi;
		public Zbp006i zbp006i;
	}

	public override void setRequiredFields(){

        requiredFieldsSet = new Set<String>();
		requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.mrchAcctNbr');
        requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.refNum');
        requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.action');
        requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.groupId');
        requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.shortMrchName');
        requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.config');
        requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.mrchClass');
        requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.floorLimit');
        requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.supvCardInd');
        requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.cvRetMode');
        requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.monitorFlag');
        requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.monitorDays');
        requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.postilionInd');
        requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.deviceTable.deviceId');
        requiredFieldsSet.add('MPScreatePOSHMerchantV3.zbp006i.deviceTable.feeCode');
	}

    public static MpsCreatePoshMerchantv3_Req_IB_v1 createDummyRequest() {
        MpsCreatePoshMerchantv3_Req_IB_v1 requestBean = new MpsCreatePoshMerchantv3_Req_IB_v1();
		requestBean.MpsCreatePoshMerchantv3 = new MpsCreatePoshMerchantv3_Req_IB_v1.MpsCreatePoshMerchantv3();
		requestBean.MpsCreatePoshMerchantv3.nbsapdpi = new MpsCreatePoshMerchantv3_Req_IB_v1.Nbsapdpi();
		requestBean.MpsCreatePoshMerchantv3.zbp006i = new MpsCreatePoshMerchantv3_Req_IB_v1.Zbp006i();
		requestBean.MpsCreatePoshMerchantv3.zbp006i.deviceTable = new List<MpsCreatePoshMerchantv3_Req_IB_v1.DeviceTable>();

		requestBean.MpsCreatePoshMerchantv3.nbsapdpi.channel = 'BPM';
		requestBean.MpsCreatePoshMerchantv3.nbsapdpi.application = 'BPM';
		requestBean.MpsCreatePoshMerchantv3.nbsapdpi.trace = 'N';

		requestBean.MpsCreatePoshMerchantv3.zbp006i.mrchAcctNbr = '1037746';
		requestBean.MpsCreatePoshMerchantv3.zbp006i.refNum = 'GN20202010378';
		requestBean.MpsCreatePoshMerchantv3.zbp006i.action = 'C';
		requestBean.MpsCreatePoshMerchantv3.zbp006i.groupId = 'A00';
		requestBean.MpsCreatePoshMerchantv3.zbp006i.shortMrchName = 'TEST1';
		requestBean.MpsCreatePoshMerchantv3.zbp006i.config = '09';
		requestBean.MpsCreatePoshMerchantv3.zbp006i.mrchClass = '01';
		requestBean.MpsCreatePoshMerchantv3.zbp006i.floorLimit = '0001';
		requestBean.MpsCreatePoshMerchantv3.zbp006i.supvCardInd = 'N';
		requestBean.MpsCreatePoshMerchantv3.zbp006i.cvRetMode = '0';
		requestBean.MpsCreatePoshMerchantv3.zbp006i.monitorFlag = 'Y';
		requestBean.MpsCreatePoshMerchantv3.zbp006i.monitorDays = '10';
		requestBean.MpsCreatePoshMerchantv3.zbp006i.postilionInd = 'Y';
		requestBean.MpsCreatePoshMerchantv3.zbp006i.branchId = '2000';

		MpsCreatePoshMerchantv3_Req_IB_v1.DeviceTable newDeviceTable = new MpsCreatePoshMerchantv3_Req_IB_v1.DeviceTable();
		newDeviceTable.termBranchId = '';
		newDeviceTable.deviceId = '01001234';
		newDeviceTable.feeCode = 'C29';
		newDeviceTable.dialTime = '2000';
		requestBean.MpsCreatePoshMerchantv3.zbp006i.deviceTable.add(newDeviceTable);

        return requestBean;
    }
}