/*****************************************************************
Name          : KWTopCategoriesTreeMap
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
public with sharing class KWTopCategoriesTreeMap 
{
	// *****************************************************
 	// *** TreeMap Object
	// *****************************************************
 	private tree mytree;
    private class tree
    {
        public string name;
        public list<treeNode> children;
        public tree(string n)
        {
        	name = n;
        	children = new list<treeNode>();	
        }
    }     
	private class treeNode 
	{
  		private string name;
  		private integer size;
  		private decimal amount;
  		private string color;
  		private list<treeNode> children = new list<treeNode>();
  
		private treeNode(integer s, string text, string c) {
    		name = text;
    		size = s;
    		color = c;
		}
		private treeNode(decimal a, string text, string c) {
    		name = text;
    		amount = a;
    		color = c;
		}
	}

	// *****************************************************
	// *** TreeMap Controller Constructor/Properties/Actions
	// *****************************************************
	private string chartJsonNoChildren;
	private string chartJsonWithChildren;
	
	public string chartJson { get {return (includeLateNightFreeZone ? chartJsonWithChildren : chartJsonNoChildren); } }
	public string chartHeader { get {return (!includeLateNightFreeZone ? mytree.name : mytree.name + '(included Late Night Free Zone)');} }
	
	public boolean includeLateNightFreeZone {get; set;}
	public boolean showAddCategories{ get; set; }
	public string browserName{ get; set; }
	
	public KWTopCategoriesTreeMap()
	{	
    	browserName = getBrowserName();
    	showAddCategories = false; 
    	includeLateNightFreeZone = false;
    	
    	// Get Data and init the TreeMap Json
    	//getData();
    	initialize();
	}

	public PageReference btnAction()
	{
    	showAddCategories = !showAddCategories;  
    	return null; 
	}	

	public PageReference chkBoxAction()
	{
		includeLateNightFreeZone = !includeLateNightFreeZone; //boolean.valueOf(Apexpages.currentPage().getParameters().get('selectedVal'));
		return null;
	}
	
	private void initialize()
	{
/*
		String json = '{'+
		'"categories":'+
		'[{"numOfCalls":803,"name":"Video-1","categories":[{"numOfCalls":350,"name":"Domestic"},{"numOfCalls":453,"name":"International"}]}'+
		',{"numOfCalls":112,"name":"Games-5","categories":[{"numOfCalls":50,"name":"Domestic"},{"numOfCalls":62,"name":"International"}]}'+
		',{"numOfCalls":55, "name":"Email-6","categories":[{"numOfCalls":50,"name":"Domestic"},{"numOfCalls":5,"name":"International"}]}'+
		',{"numOfCalls":501,"name":"Browsing-2","categories":[{"numOfCalls":450,"name":"Domestic"},{"numOfCalls":51,"name":"International"}]}'+
		',{"numOfCalls":251,"name":"File Downloads-3","categories":[{"numOfCalls":100,"name":"Domestic"},{"numOfCalls":151,"name":"International"}]}'+
		',{"numOfCalls":201,"name":"Program Activity-4","categories":[{"numOfCalls":50,"name":"Domestic"},{"numOfCalls":151,"name":"International"}]}'+
		',{"numOfCalls":21, "name":"Chat-7","categories":[{"numOfCalls":16,"name":"Domestic"},{"numOfCalls":5,"name":"International"}]}'+		
		']}';

		String json=		
		'{"invoiceList":[{"totalPrice":5.5,"date":"2011-10-04T16:58:54.858Z","lineItems":[{"UnitPrice":1.0,"Quantity":5.0,"ProductName":"Pencil"},{"UnitPrice":0.5,"Quantity":1.0,"ProductName":"Eraser"}],"invoiceNumber":1}'+
		               ',{"totalPrice":11.5,"date":"2011-10-04T16:58:54.858Z","lineItems":[{"UnitPrice":6.0,"Quantity":1.0,"ProductName":"Notebook"},{"UnitPrice":2.5,"Quantity":1.0,"ProductName":"Ruler"},{"UnitPrice":1.5,"Quantity":2.0,"ProductName":"Pen"}],"invoiceNumber":2}]}'+
		'';
};*/	
		// Get data
		String testJson = '{"name" : "TOP USAGE CATEGORIES",'+
		'"children":'+
		'[{"size":803,"name":"Video","children":[{"size":350,"name":"Pay Zone"},{"size":453,"name":"Free Zone"}], "color" : "red"}'+
		',{"size":112,"name":"Games","children":[{"size":50,"name":"Pay Zone"},{"size":62,"name":"Free Zone"}], "color" : "grey"}'+
		',{"size":55, "name":"Email","children":[{"size":50,"name":"Pay Zone"},{"size":5,"name":"Free Zone"}], "color" : "purple"}'+
		',{"size":501,"name":"Browsing","children":[{"size":450,"name":"Pay Zone"},{"size":51,"name":"Free Zone"}], "color" : "green"}'+
		',{"size":251,"name":"File Downloads","children":[{"size":100,"name":"Pay Zone"},{"size":151,"name":"Free Zone"}], "color" : "blue"}'+
		',{"size":201,"name":"Program Activity","children":[{"size":50,"name":"Pay Zone"},{"size":151,"name":"Free Zone"}], "color" : "yellow"}'+
		',{"size":21, "name":"Chat","children":[{"size":16,"name":"Pay Zone"},{"size":5,"name":"Free Zone"}], "color" : "pink"}'+		
		',{"size":13, "name":"some category0","children":[{"size":10,"name":"Pay Zone"},{"size":3,"name":"Free Zone"}], "color" : "brown"}'+		
		',{"size":2, "name":"some category1","children":[{"size":1,"name":"Pay Zone"},{"size":1,"name":"Free Zone"}], "color" : "orange"}'+		
		',{"size":0, "name":"some category2","children":[{"size":0,"name":"Pay Zone"},{"size":0,"name":"Free Zone"}], "color" : "white"}'+		
		',{"size":1, "name":"some category3","children":[{"size":1,"name":"Pay Zone"},{"size":0,"name":"Free Zone"}], "color" : "black"}'+		
		']}';
		mytree = (tree)System.JSON.deserialize(testJson, tree.class);
		
    	// Create JSON string - With Children; display Name only if not 'free zone'
    	decimal totalValue = 0;
		for (treeNode parentNode : mytree.children)
		{
			totalValue += parentNode.size;
			
			treeNode topNode = parentNode.children[0];
			for (treeNode childNode : parentNode.children)
			{
				if (childNode.name != 'Free Zone')
					topNode = childNode;
				if (childNode.color == null) childNode.color = '';
				childNode.name = '';
			}
			topNode.name = parentNode.name;
			topNode.color = parentNode.color;
		}
		chartJsonWithChildren = JSON.serializePretty(mytree);
		
    	// Create JSON string With No Children; append percentage
		tree noChTree = new tree('Top Categories');
		decimal remainingPercent = 100;
		integer size = 0;
		for (treeNode t : mytree.children)
		{
			size++;
			decimal percentUsed = (decimal.valueof(t.size)*100/totalValue).setScale(1,System.RoundingMode.UP); //.round();			
			if (size == mytree.children.size())
				percentUsed = remainingPercent;
			else
				remainingPercent = remainingPercent - percentUsed;
			
			noChTree.children.add(new treeNode(t.size, t.name + ' ' + string.ValueOf(percentUsed) + '%', t.color));
		}
		chartJsonNoChildren = JSON.serializePretty(noChTree);
	}	
	
	private static string getBrowserName()
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
}