

//chartkick helpers: to force redraw on tab clicking.

//function get_chart_ids(tab_id) {
  //var tab_content = document.getElementById(tab_id);
//  var divs = $(tab_id + " div")
//  var chart_ids = [];
//  for (var i=0; i<divs.length; i++) {
//    if (divs[i].id.indexOf("chart") > -1) {
//      chart_ids.push(divs[i].id)
//    }
    //console.log(divs[i].id)
//  }
//  return chart_ids;
//}
/*
function force_redraw(tab_id_w_hash) {
  console.log("tab clicked.");
  if (typeof window.Chartkick.charts === 'undefined') {
    console.log("chartkick undefined");
  } else {
    //console.log(Chartkick.charts);
  }

  for (att in window.Chartkick) {
    console.log(att + "=> " + Chartkick[att]);
  }
  chart_ids = get_chart_ids(tab_id_w_hash);
  for (var i=0;i<chart_ids.length;i++) {
    chart_obj = window.Chartkick.charts[chart_ids[i]];
    chart_el = document.getElementById(chart_ids[i]);
    chart_type = chart_el.parentNode.getAttribute("data-chart-type")
    //for(var propertyName in chart) {
      // propertyName is what you want
      // you can get the value like this: myObject[propertyName]
     // console.log(propertyName + ": " + chart[propertyName]);
    //}
    console.log(chart_obj);
    console.log(chart_type);
    setTimeout(function(){chart_obj.redraw()}, 4000);
    //chart_obj.redraw();
  }
  //$( window ).resize();
  //window.dispatchEvent(new Event('resize'));
}
*/

// Function to handle HTML result from server
function handleHTML(html){
  var results_container = document.getElementById("results_container");
  results_container.innerHTML = html;
}

/*
function handle_html_with_id(html,id) {
  var results_container = document.getElementById(id);
  results_container.innerHTML = html;
}
*/

var QueryString = function () {
  // This function is anonymous, is executed immediately and 
  // the return value is assigned to QueryString!
  var query_string = {};
  var query = window.location.search.substring(1);
  var vars = query.split("&");
  for (var i=0;i<vars.length;i++) {
    var pair = vars[i].split("=");
      // If first entry with this name
    if (typeof query_string[pair[0]] === "undefined") {
      query_string[pair[0]] = pair[1];
      // If second entry with this name
    } else if (typeof query_string[pair[0]] === "string") {
      var arr = [ query_string[pair[0]], pair[1] ];
      query_string[pair[0]] = arr;
      // If third or later entry with this name
    } else {
      query_string[pair[0]].push(pair[1]);
    }
  } 
    return query_string;
} ();

// Setup AJAX request
function showResults(show_all_years){
	var search_text_box = document.getElementById("tps-search-bar");
  	var search_text = search_text_box.value;
    var all_years_param = "&show_all_years=" + show_all_years;

    var pathArray = window.location.pathname.split('/');
    var controller = pathArray[1]; //this is 0 indexed but the first entry is "". 
  	var myXHR = new XMLHttpRequest();
  	myXHR.open("GET", "/" + controller + "/show_all_results?search=" + encodeURIComponent(search_text)+all_years_param);
  	myXHR.onreadystatechange = function() {
    	if (this.readyState != 4) {
        	return;
    	}
    	if (this.status == 200) {
        	handleHTML(this.responseText);
        	return;
    	} else {
      	// Handle error
    	}
  	}
  	myXHR.send();
  	return false;
}

/*
// Setup AJAX request
function renderGraphs(tab_container_id){
    //var chart_ids = get_chart_ids("#" + tab_container_id);
    var pathArray = window.location.pathname.split('/');
    var controller = pathArray[1]; //this is 0 indexed but the first entry is "". 
    var myXHR = new XMLHttpRequest();
    myXHR.open("GET", "/" + controller + "/render_summary_graphs?tab=" + encodeURIComponent(tab_container_id));
    myXHR.onreadystatechange = function() {
      if (this.readyState != 4) {
          return;
      }
      if (this.status == 200) {
          handle_html_with_id(this.responseText,tab_container_id);
          return;
      } else {
        // Handle error
      }
    }
    myXHR.send();
    return false;
}
*/
function confirmDelete(controller_name, id){
  var r = confirm("Are you sure you want to permanently delete this entry?");
  if (r==true) {
    window.location = "/" + controller_name + "/delete/" + id;
  } 
}