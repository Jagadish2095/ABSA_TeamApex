/*
 * Integration Utility  Bean for bcmscreatecase
 * @author Sandile Mathe
 * @created 12-01-2021
 */
public class CAFCreateCase_IU_v1 {

    public static CAFCreateCase_Req_IB_v1 mapRequestFields(String xmlData) {
        //function to create a Date format for "Updated" field that matches the bcmscreatecase Service
        //any format other that this turn to cause a request to fail
        Datetime dt = datetime.now();
        String day = String.valueOf(dt.format('dd'));
        String month = String.valueOf(dt.format('MM'));
        String year = String.valueOf(dt.Year());
        String hour = String.valueOf(dt.format('hh'));
        String min = String.valueOf(dt.format('mm'));
        String sec = String.valueOf(dt.format('ss'));
        String millisecond = String.valueOf(dt.millisecond());
        String dateForm = year + '-' + month + '-' + day + 'T' + hour + ':' + min + ':' + sec + '.' + millisecond;

        Datetime createdDate = Datetime.now();
        String createdDateValue = String.valueOf(DateTime.newInstance(createdDate.year(), createdDate.month(), createdDate.day()));
        CAFCreateCase_Req_IB_v1 requestBean = new CAFCreateCase_Req_IB_v1();
        requestBean.CreateCase = new CAFCreateCase_Req_IB_v1.CreateCase();
        requestBean.CreateCase.TheCase = new CAFCreateCase_Req_IB_v1.TheCase();
        requestBean.CreateCase.TheCase.ReferenceNumber = 'Salesforce';
        requestBean.CreateCase.TheCase.DefinitionId = 'FE968521-6B2E-4AC4-8673-F54F26C94507'; // This is a default Id that being used for all the environments
        requestBean.CreateCase.TheCase.DefinitionVersion = '1';
        requestBean.CreateCase.TheCase.Data = String.valueOf(xmlData);
        requestBean.CreateCase.TheCase.Status = 'Open';
        requestBean.CreateCase.TheCase.Created = String.valueOf(createdDateValue).replace('00:00:00', '');
        requestBean.CreateCase.TheCase.Updated = dateForm; //different Format causing an issue on bcmscreatecase Service
        requestBean.CreateCase.TheCase.DisplayName = '';
        requestBean.CreateCase.TheCase.FreeTextTag = '';
        requestBean.CreateCase.savedBy = 'Salesforce';

        return requestBean;
    }
}