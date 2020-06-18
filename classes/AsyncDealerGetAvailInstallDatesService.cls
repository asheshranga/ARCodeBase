//Generated by wsdl2apex

public class AsyncDealerGetAvailInstallDatesService {
    public class getAvailableInstallDatesResponseFuture extends System.WebServiceCalloutFuture {
        public DealerGetAvailInstallDatesService.scheduleDate[] getValue() {
            DealerGetAvailInstallDatesService.getAvailableInstallDatesResponse response = (DealerGetAvailInstallDatesService.getAvailableInstallDatesResponse)System.WebServiceCallout.endInvoke(this);
            return response.scheduleDate;
        }
    }
    public class scheduleCustomerInstallResponseFuture extends System.WebServiceCalloutFuture {
        public void getValue() {
            System.WebServiceCallout.endInvoke(this);
        }
    }
    public class AsyncDirectFulfillmentImplPort {
        public String endpoint_x = 'https://webservices.test.wildblue.net:443/PublicWebServices/services/DirectFulfillment';
        public Map<String,String> inputHttpHeaders_x;
        public String clientCertName_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://services.webservice.wildblue.com/', 'DealerGetAvailInstallDatesService'};
        public AsyncDealerGetAvailInstallDatesService.getAvailableInstallDatesResponseFuture beginGetAvailableInstallDates(System.Continuation continuation,DateTime fromDate,DateTime toDate,DealerGetAvailInstallDatesService.addressBean serviceAddress,String salesChannel) {
            DealerGetAvailInstallDatesService.getAvailableInstallDates request_x = new DealerGetAvailInstallDatesService.getAvailableInstallDates();
            request_x.fromDate = fromDate;
            request_x.toDate = toDate;
            request_x.serviceAddress = serviceAddress;
            request_x.salesChannel = salesChannel;
            return (AsyncDealerGetAvailInstallDatesService.getAvailableInstallDatesResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncDealerGetAvailInstallDatesService.getAvailableInstallDatesResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://services.webservice.wildblue.com/',
              'getAvailableInstallDates',
              'http://services.webservice.wildblue.com/',
              'getAvailableInstallDatesResponse',
              'DealerGetAvailInstallDatesService.getAvailableInstallDatesResponse'}
            );
        }
        public AsyncDealerGetAvailInstallDatesService.scheduleCustomerInstallResponseFuture beginScheduleCustomerInstall(System.Continuation continuation,String partnerSystemId,String partnerAccountRef,String partnerOrderRef,DealerGetAvailInstallDatesService.scheduleDate scheduleDate,String notes) {
            DealerGetAvailInstallDatesService.scheduleCustomerInstall request_x = new DealerGetAvailInstallDatesService.scheduleCustomerInstall();
            request_x.partnerSystemId = partnerSystemId;
            request_x.partnerAccountRef = partnerAccountRef;
            request_x.partnerOrderRef = partnerOrderRef;
            request_x.scheduleDate = scheduleDate;
            request_x.notes = notes;
            return (AsyncDealerGetAvailInstallDatesService.scheduleCustomerInstallResponseFuture) System.WebServiceCallout.beginInvoke(
              this,
              request_x,
              AsyncDealerGetAvailInstallDatesService.scheduleCustomerInstallResponseFuture.class,
              continuation,
              new String[]{endpoint_x,
              '',
              'http://services.webservice.wildblue.com/',
              'scheduleCustomerInstall',
              'http://services.webservice.wildblue.com/',
              'scheduleCustomerInstallResponse',
              'DealerGetAvailInstallDatesService.scheduleCustomerInstallResponse'}
            );
        }
    }
}