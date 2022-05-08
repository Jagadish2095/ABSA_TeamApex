/**
 * @description LeadShareHandler Class is created to create Lead share records in system mode
 * CLient Review & Client Maturity
 * */
global without sharing class LeadShareHandler {
	/**
	 * @description shareLeadWithCreator method
	 * @param leadRecord - Lead
	 *
	 * */
	public static void shareLeadWithCreator(Lead leadRecord) {
		LeadShare ldShr = new LeadShare();
		ldShr.LeadId = leadRecord.Id;
		ldShr.UserOrGroupId = userinfo.getuserid();
		ldShr.LeadAccessLevel = 'Read';
		ldShr.RowCause = 'Manual';
		Database.SaveResult sr = Database.insert(ldShr, false);
		//System.debug('LeadShare result : '+JSON.serialize(sr));
	}
}