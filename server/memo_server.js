
getDummyText = function() {
  var xmlHttp = new XMLHttpRequest();
  xmlHttp.open("GET","get_dummy_string",true);
  xmlHttp.onreadystatechange = function() {
  document.getElementById("output").innerHTML = xmlHttp.responseText;
  };
  xmlHttp.send("null");
}
window.onload=function() {
  document.getElementById("target").addEventListener("click", getDummyText);
}
