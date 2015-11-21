/*****************************************************************
Name          : KWTopCategoriesBarChart
Created By    : Marina Basovich
Company Name  : ViaSat
Project       :  
Created Date  : March, 2015
Modified Date : 
Description   : Controller for VF Page
The CDN location for D3 is listed at https://cdnjs.com/libraries/d3/ 
                              and is https://cdnjs.cloudflare.com/ajax/libs/d3/3.4.11/d3.min.js.
For Handling Large JSON String Values on Visualforce Page:
http://salesforce.stackexchange.com/questions/45477/handling-large-json-string-values-on-visualforce-page                              
******************************************************************
*/
public with sharing class KWTopCategoriesBarChart 
{
 	//private list<list<bar>> myBarChart;
 	private barChart myBarChart;		
	private class barChart 
	{
  		private string name; 	//"My Usage By Day"
        private string xLabel;	// "Usage",
        private string yLabel;	// "Days",
  		private list<list<bar>> layers;
  		
		private barChart(string n, string xl, string yl) {
    		name = n;
    		xLabel = xl;
    		yLabel = yl;
		}		
	}	
 	/*
 	private barChartLayer[] myBarChart;		
	private class barChartLayer 
	{
		private list<bar> bars = new list<bar>();
  		private string name; //"My Usage By Day"
  		private string color;
        "xLabel" : "Usage",
        "yLabel" : "Days",
        "layers" : 
  		
		private barChartLayer(list<bar> b, string n, string c) {
    		bars = b;
    		name = n;
    		color = c;
		}		
	}*/	
	private class bar
	{ 
  		private string xValue;
  		private integer y;   
		public bar(string xv,integer yv) {
    		xValue = xv;
    		y = yv;
		}
	}		

	public string chartJson { get; set;}
	public string chartHeader { get {return 'Data Per day'; } }

	public string browserName{ get; set; }
	
	public static string getBrowserName()
	{	
    	string browserName = ''; // default Salesforce view
    	string userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');

		// for a BlackBerry standard and embedded browser. In Salesforce the Apex code distinguished between the regular and embedded browsers   	
    	if (userAgent.contains('iPhone'))
    		browserName = 'iPhone-Safari';
    	else if (userAgent.contains('BlackBerry'))
    		browserName = 'BlackBerry';
    	else if (userAgent.contains('Salesforce'))
    		browserName = 'Salesforce';
    	return browserName;
	}

	public KWTopCategoriesBarChart()
	{	
    	browserName = getBrowserName();
    	
    	//getData();

    	//init the TreeMap Json
    	initialize();
	}

	public PageReference btnAction()
	{
    	return null; 
	}	

	private void initialize()
	{
		myBarChart = new barChart('My Usage By Day','Usage','Days');
/*
		myBarChart = initLayers();
		myBarChart[0].bars = new list<bar>();
		myBarChart[0].bars.add(new bar('2014-02-19',177));
		myBarChart[0].bars.add(new bar('2014-02-20',135));
		myBarChart[0].bars.add(new bar('2014-02-21',176));
		myBarChart[0].bars.add(new bar('2014-02-22',87));
		myBarChart[0].bars.add(new bar('2014-02-23', 4));

		myBarChart[1].bars = new list<bar>();
		myBarChart[1].bars.add(new bar('2014-02-19',40));
		myBarChart[1].bars.add(new bar('2014-02-20',38));
		myBarChart[1].bars.add(new bar('2014-02-21',53));
		myBarChart[1].bars.add(new bar('2014-02-22',18));
		myBarChart[1].bars.add(new bar('2014-02-23', 2));
        
		myBarChart[2].bars = new list<bar>();
		myBarChart[2].bars.add(new bar('2014-02-19',4));
		myBarChart[2].bars.add(new bar('2014-02-20',9));
		myBarChart[2].bars.add(new bar('2014-02-21',15));
		myBarChart[2].bars.add(new bar('2014-02-22',5));
		myBarChart[2].bars.add(new bar('2014-02-23', 2));
*/
		myBarChart.layers = new List<List<bar>>{ 
		new list<bar>{new bar('2014-02-19',177),
			new bar('2014-02-20',135),
			new bar('2014-02-21',176),
			new bar('2014-02-22',87),
			new bar('2014-02-23', 4)},
		new list<bar>{new bar('2014-02-19',40),
			new bar('2014-02-20',38),
			new bar('2014-02-21',53),
			new bar('2014-02-22',18),
			new bar('2014-02-23', 2)},       
		new list<bar>{new bar('2014-02-19',4),
			new bar('2014-02-20',9),
			new bar('2014-02-21',15),
			new bar('2014-02-22',5),
			new bar('2014-02-23', 2)}
		};

    	chartJson = JSON.serializePretty(myBarChart); 
	}	
/*	
	private barChartLayer[] initLayers()
	{
		// Make color = '' if want to use the default color on the component 	
		barChartLayer[] layers = new barChartLayer[]{ 
		 new barChartLayer(new list<bar>(), 'Layer 1.1','red')
		,new barChartLayer(new list<bar>(), 'Layer 1.2','green')
		,new barChartLayer(new list<bar>(), 'Layer 1.3','pink')
		};
		return layers;
	}*/
}