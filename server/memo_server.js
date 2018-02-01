
getDummyText = function() {
  var xmlHttp = new XMLHttpRequest();
  var text;
  xmlHttp.open("GET","get_dummy_string",true);
  xmlHttp.onreadystatechange =function() {
    text = xmlHttp.responseText;
    document.getElementById("output").innerHTML = xmlHttp.responseText;
    var obj = JSON.parse(text);
    document.getElementById("new_item").innerHTML = "I'm sorry " + obj.name + " " + obj.status + "\n";
  };
  xmlHttp.send("null");
}
addItem = function() {
  var xmlHttp = new XMLHttpRequest();
  var text;
  xmlHttp.open("GET","get_dummy_string",true);
  xmlHttp.onreadystatechange =function() {
    text = xmlHttp.responseText;
    document.getElementById("output").innerHTML = xmlHttp.responseText;
    var obj = JSON.parse(text);
    document.getElementById("new_item").innerHTML = "I'm sorry " + obj.name + " " + obj.status + "\n";
  };
  xmlHttp.send("null");
}
submitGuess = function() {
  var xmlHttp = new XMLHttpRequest();
  var text;
  xmlHttp.open("GET","get_dummy_string",true); //We're gonna be posting here
  xmlHttp.onreadystatechange =function() {
    text = xmlHttp.responseText;
    document.getElementById("output").innerHTML = xmlHttp.responseText;
    var obj = JSON.parse(text);
    document.getElementById("new_item").innerHTML = "I'm sorry " + obj.name + " " + obj.status + "\n";
  };
  xmlHttp.send("null");
}
submitAssessment = function() {
  var xmlHttp = new XMLHttpRequest();
  var text;
  xmlHttp.open("GET","get_dummy_string",true); //It's also a post
  xmlHttp.onreadystatechange =function() {
    text = xmlHttp.responseText;
    document.getElementById("output").innerHTML = xmlHttp.responseText;
    var obj = JSON.parse(text);
    document.getElementById("new_item").innerHTML = "I'm sorry " + obj.name + " " + obj.status + "\n";
  };
  xmlHttp.send("null");
}
window.onload=function() {
    document.getElementById("target").addEventListener("click", getDummyText);
    document.getElementById("new_item_submit").addEventListener("click", addItem);
    document.getElementById("submit_guess").addEventListener("click", submitGuess);
    document.getElementById("submit_self_assessment").addEventListener("click", submitAssessment);
	
}
