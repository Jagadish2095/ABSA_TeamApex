/**
 * @description Integration Utility for Everyday Banking Charge Control Service
 * @author  Koketso Mpshane
 * @date    19/08/2021
 */
public class EBChargeControl_IU_V1 {
    /**
	 * @description mapRequestFields method
	 * @param chargeControlRecords
	 * @return EBChargeControl_Req_IB_V1
	 */
	public static EBChargeControl_Req_IB_V1 mapRequestFields(List<Charge_Control__c> chargeControlRecords) {
        Integer totalCharges = 0;
		EBChargeControl_Req_IB_V1 requestBean = new EBChargeControl_Req_IB_V1();
        requestBean.totalSize = String.valueOf(chargeControlRecords.size()).leftPad(7, '0');
        requestBean.done = true;
        requestBean.records = new List<EBChargeControl_Req_IB_V1.Records>();
        
        if(chargeControlRecords.size() > 0){
            for(Charge_Control__c charge: chargeControlRecords){
                EBChargeControl_Req_IB_V1.Records rec = new EBChargeControl_Req_IB_V1.Records();
                rec.Id = charge.Id;
                rec.ChargeID = '00000' + charge.Charge_ID__c;
                rec.ChargeMonth = charge.Charge_Month__c;
      			rec.ChargeAccountNumber = (charge.Charge_Account_Number__c).leftPad(16, '0');
      			rec.ChargeAmount = charge.Charge_Amount__c;
      			rec.ChargeProcessCode = charge.Charge_Process_Code__c;
      			rec.ChargeProcessDate = String.valueOf(charge.Charge_Process_Date__c);
                requestBean.records.add(rec);
                if(charge.Charge_Amount__c != null){
                    totalCharges += Integer.valueOf(charge.Charge_Amount__c);
                }
            }
        }
        requestBean.totalFees = String.valueOf(totalCharges).leftPad(11, '0');

		return requestBean;
	}

}