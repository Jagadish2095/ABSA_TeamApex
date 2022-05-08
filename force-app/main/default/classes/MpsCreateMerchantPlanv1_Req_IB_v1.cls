/*
 * Request Integration Bean for MpsCreateMerchantPlanv1 Service
 * @author Prashant Jain
 * @created 2020-05-08
 */

public class MpsCreateMerchantPlanv1_Req_IB_v1 extends Base_IB {

	public class Zbp005i {
		public String mrchAcctNbr;
		public String refNum;
		public String action;
		public List<PlanTable> planTable;
	}

	public MPScreateMerchantPlanV1 MPScreateMerchantPlanV1;

	public class PlanTable {
		public String plnType;
		public String allowDiscCr;
		public String amexMrchNbrNum;
		public String onusPct;
		public String notOnusPct;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class MPScreateMerchantPlanV1 {
		public Nbsapdpi nbsapdpi;
		public Zbp005i zbp005i;
	}

	public override void setRequiredFields(){
        requiredFieldsSet = new Set<String>();
		requiredFieldsSet.add('MPScreateMerchantPlanV1.zbp005i.mrchAcctNbr');
		requiredFieldsSet.add('MPScreateMerchantPlanV1.zbp005i.refNum');
		requiredFieldsSet.add('MPScreateMerchantPlanV1.zbp005i.action');
        requiredFieldsSet.add('MPScreateMerchantPlanV1.zbp005i.planTable.plnType');
        requiredFieldsSet.add('MPScreateMerchantPlanV1.zbp005i.planTable.onusPct');
        requiredFieldsSet.add('MPScreateMerchantPlanV1.zbp005i.planTable.notOnusPct');
	}

    public static MPScreateMerchantPlanV1_Req_IB_v1 createDummyRequest() {
        MPScreateMerchantPlanV1_Req_IB_v1 requestBean = new MPScreateMerchantPlanV1_Req_IB_v1();
		requestBean.MPScreateMerchantPlanV1 = new MPScreateMerchantPlanV1_Req_IB_v1.MPScreateMerchantPlanV1();
		requestBean.MPScreateMerchantPlanV1.nbsapdpi = new MPScreateMerchantPlanV1_Req_IB_v1.Nbsapdpi();
		requestBean.MPScreateMerchantPlanV1.zbp005i = new MPScreateMerchantPlanV1_Req_IB_v1.Zbp005i();
		requestBean.MPScreateMerchantPlanV1.zbp005i.planTable = new List<MPScreateMerchantPlanV1_Req_IB_v1.PlanTable>();

		requestBean.MPScreateMerchantPlanV1.nbsapdpi.channel = 'BPM';
		requestBean.MPScreateMerchantPlanV1.nbsapdpi.application = 'BPM';
		requestBean.MPScreateMerchantPlanV1.nbsapdpi.trace = 'N';

		requestBean.MPScreateMerchantPlanV1.zbp005i.mrchAcctNbr = '1037902';
		requestBean.MPScreateMerchantPlanV1.zbp005i.refNum = 'GN20202010378';
		requestBean.MPScreateMerchantPlanV1.zbp005i.action = 'C';

		MPScreateMerchantPlanV1_Req_IB_v1.PlanTable newPlanTable = new MPScreateMerchantPlanV1_Req_IB_v1.PlanTable();
		newPlanTable.plnType = 'CP1';
        newPlanTable.allowDiscCr = 'N';
        newPlanTable.amexMrchNbrNum = '';
        newPlanTable.onusPct = '0';
        newPlanTable.notOnusPct = '0';
		requestBean.MPScreateMerchantPlanV1.zbp005i.planTable.add(newPlanTable);

		newPlanTable = new MPScreateMerchantPlanV1_Req_IB_v1.PlanTable();
		newPlanTable.plnType = 'CP2';
        newPlanTable.allowDiscCr = 'N';
        newPlanTable.amexMrchNbrNum = '';
        newPlanTable.onusPct = '0';
        newPlanTable.notOnusPct = '0';
		requestBean.MPScreateMerchantPlanV1.zbp005i.planTable.add(newPlanTable);

        return requestBean;
    }
}