#ProxyServiceAdapter
This class is used to mock up data access methods during testing

	module.exports = class ProxyServiceAdapter

		constructor: () ->

##getAssoc
This method queries a web service to get associate replicated website
data.  The query is matched against the "WebSite_File" parameter coming
back from the service.

		@getAssoc: (query) ->
			if query == "satori"
				data =
					Pinno: "1161918"
					WebSite_File:"satori"
					Name_Line:"User's Name"
					Address_Line1:"User's address"
					Address_Line2:{}
					Address_Line3: {}
					Address_Line4: {}
					Fax: {}
					e_mail: "no-reply@tempuri.com"
					Phone: {}
					LP_Website_Associate: "123456"
					CreateDate: "2013-02-12T11:14:17.027-06:00"
				return data