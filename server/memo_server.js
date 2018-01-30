
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
window.onload=function() {
  document.getElementById("target").addEventListener("click", getDummyText);
}
