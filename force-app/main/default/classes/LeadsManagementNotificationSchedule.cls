/**
 * @description Schedulable class for sending new leads email to management
 * @author  Kabelo Aphane
 * @date    15/03/2021
 */
global class LeadsManagementNotificationSchedule implements Schedulable {
	/**
	 * @description method to prepare an email
	 * @param sc Schedulable Context
	 */
	global void execute(SchedulableContext sc) {
		List<String> recordTypes = new List<String>{ 'Retail_Sales_Lead', 'Retail_Service_Lead' };

		Integer countIBCampaign = [
			SELECT COUNT()
			FROM Lead
			WHERE RecordType.DeveloperName IN :recordTypes AND LeadSource = 'IB Campaign' AND CreatedDate = Today
		];
		Integer countTop100 = [
			SELECT COUNT()
			FROM Lead
			WHERE RecordType.DeveloperName IN :recordTypes AND LeadSource = 'Top100' AND CreatedDate = Today
		];
		Integer countCampaignEvent = [
			SELECT COUNT()
			FROM Lead
			WHERE RecordType.DeveloperName IN :recordTypes AND LeadSource = 'Campaign/Event' AND CreatedDate = Today
		];

		Integer leadsCount = countIBCampaign + countTop100 + countCampaignEvent;

		String emailBody =
			'Good day, <br/><br/>This is a confirmation that ' +
			leadsCount +
			' lead(s) have been successfully loaded and distributed to the branches:<br/><br/>';
		emailBody += countIBCampaign + ' for the IB Campaign';
		emailBody += '<br/><br/> ' + countTop100 + ' for the Top100 Campaign';
		emailBody += '<br/><br/> ' + countCampaignEvent + ' for the Campaign/Event';

		sendEmailToManagement(emailBody);
	}

	/**
	 * @description method to send an email
	 * @param emailBody
	 * @return List<Messaging.SendEmailResult>
	 */
	public static List<Messaging.SendEmailResult> sendEmailToManagement(String emailBody) {
		List<Messaging.SendEmailResult> results;
		List<string> recipientEmails = new List<string>();
		String lblEmailAddresses = Label.Lead_Management_Emails;
		List<String> emailRecipients = lblEmailAddresses.split(';');
		if (emailRecipients.size() > 0) {
			for (String emails : emailRecipients) {
				recipientEmails.add(emails);
			}
		}

		if (recipientEmails.size() > 0) {
			List<Messaging.SingleEmailMessage> singleMessageList = new List<Messaging.SingleEmailMessage>();
			Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
			msg.setToAddresses(recipientEmails);
			msg.setSubject('New Campaign Leads Loaded to Branch Network');
			msg.setHtmlBody(emailBody);
			msg.setSaveAsActivity(false);
			singleMessageList.add(msg);

			//Send the email
			results = Messaging.sendEmail(singleMessageList);
		}
		return results;
	}
}