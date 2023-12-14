<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.sql.*,java.util.*"%>

<html>
<body>
<p style="font-size:60px">CALeNDAR</p>
<%

Class.forName("com.mysql.jdbc.Driver");
    
Connection connection = DriverManager.getConnection("jdbc:mysql://mysql3000.mochahost.com/himwepro_a","himwepro_a","yyyty");


Statement statement = connection.createStatement();



String month = "", year = "", dy = "";

String _mn = "", _yr = "";

if(request.getParameter("month") != null) {
    month = request.getParameter("month");
    year = request.getParameter("year");
}

if(request.getParameter("dy") != null) {
    dy = request.getParameter("dy");
    _mn = request.getParameter("month");
    _yr = request.getParameter("year");
        if(request.getParameter("cri") != null) {
            if(request.getParameter("content"+request.getParameter("cri")) != null) {
                String content = request.getParameter("content"+request.getParameter("cri"));
                String sqlsql = "update calendar set content = '"+content+"' where mn = "+_mn+" and yr = "+ _yr + " and dy = " + dy + ";";
                statement.executeUpdate(sqlsql);
            }
        } else if(request.getParameter("newEntry") != null) {
            String newEntry = request.getParameter("newEntry");
            String sqlsql = "insert into calendar select '"+newEntry+"', "+_mn+", "+ _yr + ", " + dy + ";";
            statement.executeUpdate(sqlsql);
        }
    %>
    <div id="editFrm" style="width:500px;height:500px;border:1px solid black">
      <p><b>Plan for <%=_mn%>/<%=dy%>/<%=_yr%></b></p>
      <form method="post" action="" id="frm">
        <input type="text" name="newEntry" style="width:300px">
        <input type="hidden" name="month" value="<%=_mn%>">
        <input type="hidden" name="year" value="<%=_yr%>">
        <input type="hidden" name="dy" value="<%=dy%>">
        <input type="submit" value="+">
      <%
      //statement.executeUpdate("delete from calendar;");
      //statement.executeUpdate("create table calendar (content text, mn int, yr int, dy int);");
      String sqlStr = "select content from calendar where mn = " + _mn + " and yr = " + _yr + " and dy = " + dy + ";";
      ResultSet resultSet = statement.executeQuery(sqlStr);
      int val = 0;
      if(resultSet.next()) {
          do {
          %>
              <input type="text" name="content<%=val%>" value="<%=resultSet.getString("content")%>"> <input type="button" onclick="sub(<%=val%>)" value="Update.">
              
          
              <br><br>
          <%
              val++;
          } while(resultSet.next());
          %>
          <input name="cri" type="hidden" id="cri">
      <script>
        function sub(val) {
            document.getElementById("cri").value = val;
            document.getElementById("frm").submit();
        }
      </script>
          <%
      }
      %>
      </form>
    </div>
    <%
}

%>

<form method="post" action="">
Edit: 
<select name="dy">
<%
java.time.LocalDate today = java.time.LocalDate.now();	//23-Feb-022
    
String day = ""+today.getDayOfMonth();	//23

if(month.equals("")) {
    month = ""+today.getMonthValue(); 	//2
    year = ""+today.getYear();
}

for(int i=1; i<=31; i++) {
%>
  <option value="<%=i%>"><%=month%> <%=i%> <%=year%></option>
<%
}
%>
</select>

<input type="hidden" name="month" value="<%=month%>">

<input type="hidden" name="year" value="<%=year%>">

<input type="submit" value="Update.">

</form>

<br>

<br>

<form method="post" action="">
User Interface: 
<select name="month">
  <option value="1">January</option>
  <option value="2">February</option>
  <option value="3">March</option>
  <option value="4">April</option>
  <option value="5">May</option>
  <option value="6">June</option>
  <option value="7">July</option>
  <option value="8">August</option>
  <option value="9">September</option>
  <option value="10">October</option>
  <option value="11">November</option>
  <option value="12">December</option>
</select>

<select name="year">
  <option value="2018">2018</option>
  <option value="2019">2019</option>
  <option value="2020">2020</option>
  <option value="2021">2021</option>
  <option value="2022">2022</option>
  <option value="2023">2023</option>
  <option value="2024">2024</option>
  <option value="2025">2025</option>
  <option value="2026">2026</option>
  <option value="2027">2027</option>
</select>

<input type="submit" value="Set.">

</form>

<br>

<canvas width="1400" height="840" id="cvs"></canvas>

<script>

var marginLeft = 4;

var startDatPos = 0, startDatPosY = 80;
var widthBlock = 130, heightBlock = 90;

var cvs = document.getElementById("cvs");
var ctx = cvs.getContext("2d");

var dt;
var year;
var month;

var elem = cvs,
    elemLeft = elem.offsetLeft + elem.clientLeft,
    elemTop = elem.offsetTop + elem.clientTop,
    context = ctx,
    elements = [];

// Add event listener for `click` events.
elem.addEventListener('click', function(event) {
    var x = event.pageX - elemLeft,
        y = event.pageY - elemTop;

    // Collision detection between clicked offset and element.
    elements.forEach(function(element) {
        if (y > 50 && y < 70 
            && x > 480 && x < 500) {
            setYear();
        }
        if (y > 50 && y < 70 
            && x > 400 && x < 420) {
            year--;
            setYear();
        }
        if (y > 50 && y < 70 
            && x > 420 && x < 440) {
            year++;
            setYear();
        }
        if (y > 50 && y < 70 
            && x > 525 && x < 545) {
            if(month>1)
            month--;
            setMonth(-1);
        }
        if (y > 50 && y < 70 
            && x > 545 && x < 575) {
            if(month<12)
            month++;
            setMonth(-1);
        }
        if (y > 80 && y < 100 
            && x > 40 && x < 130) {
            month = 1;
            setMonth(-1);
        }
        if (y > 80 && y < 100 
            && x > 340 && x < 440) {
            month = 2;
            setMonth(-1);
        }
        if (y > 80 && y < 100 
            && x > 680 && x < 760) {
            month = 3;
            setMonth(-1);
        }
        if (y > 80 && y < 100 
            && x > 1020 && x < 1100) {
            month = 4;
            setMonth(-1);
        }
        if (y > 320 && y < 360 
            && x > 40 && x < 130) {
            month = 5;
            setMonth(-1);
        }
        if (y > 320 && y < 360 
            && x > 340 && x < 440) {
            month = 6;
            setMonth(-1);
        }
        if (y > 320 && y < 360 
            && x > 680 && x < 760) {
            month = 7;
            setMonth(-1);
        }
        if (y > 320 && y < 360 
            && x > 1020 && x < 1100) {
            month = 8;
            setMonth(-1);
        }

        if (y > 600 && y < 640 
            && x > 40 && x < 130) {
            month = 9;
            setMonth(-1);
        }
        if (y > 600 && y < 640 
            && x > 340 && x < 440) {
            month = 10;
            setMonth(-1);
        }
        if (y > 600 && y < 640 
            && x > 680 && x < 760) {
            month = 11;
            setMonth(-1);
        }
        if (y > 600 && y < 640 
            && x > 1020 && x < 1100) {
            month = 12;
            setMonth(-1);
        }
    });

}, false);

// Add element.
elements.push({
    colour: '#05EFFF',
    width: 150,
    height: 100,
    top: 20,
    left: 15
});

var start = 0;

function setMonth(vr) {

    const mn = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    
    ctx.fillStyle = "black";
    ctx.fillRect(0, 0, 1400, 1000);
    ctx.fillStyle = "white";
    ctx.font = "20px Arial";

    if(vr == 1) {
        dt = new Date();
        year = dt.getFullYear();
        month = dt.getMonth() + 1;
        
    }

    <%
    if(!month.equals("")) {
        %>
        if(vr != -1 && start != 0) {
            start = 1;
            month = <%="\""+month+"\""%>;
            year = <%="\""+year+"\""%>;
        } else if(start == 0) {
            //alert("Year: " + year);
        }
        <%
    }
    %>

    var str = "< > Year: " + year;
    str = str + " < > Month: " + mn[month-1] + " (" + month + ")";
    
    ctx.fillText(str, 400, 64);
    
    var y = year, m = month;
    var d = new Date();
    var day = d.getDate();
    var my = d.getMonth()+1;
    var yer = d.getYear()+1900;
    var firstDay = new Date(y, m-1, 1);
    const numDays = (yy, mm) => new Date(yy, mm, 0).getDate();

    var r = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    var a;
    var b;
    for(var i=0; i<r.length; i++) {
      if((firstDay+"").indexOf(r[i]) != -1) {
        a = i;
        b = 7;
      }
    }
    
    var content = "";
    startDatPosY = 80;
    var ab;
    var cc=1;    
    for(var j=0; j<6; j++) {
        if(j==0) {
            ab = a;
        } else {
            ab = 0;
        }
        for(var i=ab; i<b; i++) {
            if(cc<=numDays(y, m)){
                ctx.fillStyle = "yellow";
                if(cc==day && my==m && yer==y) {
                    ctx.fillStyle = "green";
                }
                ctx.fillRect(marginLeft+(i)*(widthBlock+10),startDatPosY,widthBlock,heightBlock);
                ctx.fillStyle = "blue";
                ctx.fillText(cc,marginLeft+(i)*(widthBlock+10)+50,startDatPosY+80);
                cc++;
            }
        }
        startDatPosY = startDatPosY + 100;
    }
    
}

function setYear() {

    const mn = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    
    ctx.fillStyle = "black";
    ctx.fillRect(0, 0, 1400, 1000);
    ctx.fillStyle = "white";
    ctx.font = "20px Arial";

    year = year;
    month = 1;

    var str = "< > Year: " + year;
    str = str;
    
    ctx.fillText(str, 400, 64);
    
    var y = year, m = month;
    var d = new Date();
    var day = d.getDate();
    var my = d.getMonth()+1;
    var yer = d.getYear()+1900;
    var firstDay = new Date(y, m-1, 1);
    const numDays = (yy, mm) => new Date(yy, mm, 0).getDate();

    var r = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    var a;
    var b;
    for(var i=0; i<r.length; i++) {
      if((firstDay+"").indexOf(r[i]) != -1) {
        a = i;
        b = 7;
      }
    }
    
    //JANUARY
    startDatPosY = 120;
    var ab;
    var cc=1;    
    str = "" + "January";
    str = str;
    ctx.font = "20px Arial";
    ctx.fillStyle = "white";
    ctx.fillText(str, 40, 100);
    for(var j=0; j<6; j++) {
        if(j==0) {
            ab = a;
        } else {
            ab = 0;
        }
        for(var i=ab; i<b; i++) {
            if(cc<=numDays(y, m)){
                ctx.fillStyle = "yellow";
                ctx.fillRect(marginLeft+(i)*(30+10),startDatPosY,30,30);
                ctx.fillStyle = "red";
                ctx.fillText(cc, marginLeft+(i)*(30+10),startDatPosY+10);
                cc++;
            }
        }
        startDatPosY = startDatPosY + 35;
    }
    

    //FEBRUARY
    m = 2;
    firstDay = new Date(y, m-1, 1);
    for(var i=0; i<r.length; i++) {
      if((firstDay+"").indexOf(r[i]) != -1) {
        a = i;
        b = 7;
      }
    }
    startDatPosY = 120;
    cc=1;    
    str = "" + "February";
    str = str;
    ctx.font = "20px Arial";
    ctx.fillStyle = "white";
    ctx.fillText(str, 340, 100);
    for(var j=0; j<6; j++) {
        if(j==0) {
            ab = a;
        } else {
            ab = 0;
        }
        for(var i=ab; i<b; i++) {
            if(cc<=numDays(y, m)){
                ctx.fillStyle = "yellow";
                ctx.fillRect(340+(i)*(30+10),startDatPosY,30,30);
                ctx.fillStyle = "red";
                ctx.fillText(cc, 350+(i)*(30+10),startDatPosY+10);
                cc++;
            }
        }
        startDatPosY = startDatPosY + 35;
    }
    
    //MARCH
    m = 3;
    firstDay = new Date(y, m-1, 1);
    for(var i=0; i<r.length; i++) {
      if((firstDay+"").indexOf(r[i]) != -1) {
        a = i;
        b = 7;
      }
    }
    startDatPosY = 120;
    cc=1;    
    str = "" + "March";
    str = str;
    ctx.font = "20px Arial";
    ctx.fillStyle = "white";
    ctx.fillText(str, 680, 100);
    for(var j=0; j<6; j++) {
        if(j==0) {
            ab = a;
        } else {
            ab = 0;
        }
        for(var i=ab; i<b; i++) {
            if(cc<=numDays(y, m)){
                ctx.fillStyle = "yellow";
                ctx.fillRect(680+(i)*(30+10),startDatPosY,30,30);
                ctx.fillStyle = "red";
                ctx.fillText(cc, 680+(i)*(30+10),startDatPosY+10);
                cc++;
            }
        }
        startDatPosY = startDatPosY + 35;
    }

    //APRIL
    m = 4;
    firstDay = new Date(y, m-1, 1);
    for(var i=0; i<r.length; i++) {
      if((firstDay+"").indexOf(r[i]) != -1) {
        a = i;
        b = 7;
      }
    }
    startDatPosY = 120;
    cc=1;    
    str = "" + "April";
    str = str;
    ctx.font = "20px Arial";
    ctx.fillStyle = "white";
    ctx.fillText(str, 1020, 100);
    for(var j=0; j<6; j++) {
        if(j==0) {
            ab = a;
        } else {
            ab = 0;
        }
        for(var i=ab; i<b; i++) {
            if(cc<=numDays(y, m)){
                ctx.fillStyle = "yellow";
                ctx.fillRect(1020+(i)*(30+10),startDatPosY,30,30);
                ctx.fillStyle = "red";
                ctx.fillText(cc, 1020+(i)*(30+10),startDatPosY+10);
                cc++;
            }
        }
        startDatPosY = startDatPosY + 35;
    }
    
    //MAY
    m = 5;
    firstDay = new Date(y, m-1, 1);
    for(var i=0; i<r.length; i++) {
      if((firstDay+"").indexOf(r[i]) != -1) {
        a = i;
        b = 7;
      }
    }
    startDatPosY = 380;
    cc=1;    
    str = "" + "May";
    str = str;
    ctx.font = "20px Arial";
    ctx.fillStyle = "white";
    ctx.fillText(str, 40, 360);
    for(var j=0; j<6; j++) {
        if(j==0) {
            ab = a;
        } else {
            ab = 0;
        }
        for(var i=ab; i<b; i++) {
            if(cc<=numDays(y, m)){
                ctx.fillStyle = "yellow";
                ctx.fillRect(marginLeft+(i)*(30+10),startDatPosY,30,30);
                ctx.fillStyle = "red";
                ctx.fillText(cc, marginLeft+(i)*(30+10),startDatPosY+10);
                cc++;
            }
        }
        startDatPosY = startDatPosY + 35;
    }
    

    //JUNE
    m = 6;
    firstDay = new Date(y, m-1, 1);
    for(var i=0; i<r.length; i++) {
      if((firstDay+"").indexOf(r[i]) != -1) {
        a = i;
        b = 7;
      }
    }
    startDatPosY = 380;
    cc=1;    
    str = "" + "June";
    str = str;
    ctx.font = "20px Arial";
    ctx.fillStyle = "white";
    ctx.fillText(str, 340, 360);
    for(var j=0; j<6; j++) {
        if(j==0) {
            ab = a;
        } else {
            ab = 0;
        }
        for(var i=ab; i<b; i++) {
            if(cc<=numDays(y, m)){
                ctx.fillStyle = "yellow";
                ctx.fillRect(340+(i)*(30+10),startDatPosY,30,30);
                ctx.fillStyle = "red";
                ctx.fillText(cc, 340+(i)*(30+10),startDatPosY+10);
                cc++;
            }
        }
        startDatPosY = startDatPosY + 35;
    }
    
    //JULY
    m = 7;
    firstDay = new Date(y, m-1, 1);
    for(var i=0; i<r.length; i++) {
      if((firstDay+"").indexOf(r[i]) != -1) {
        a = i;
        b = 7;
      }
    }
    startDatPosY = 380;
    cc=1;    
    str = "" + "July";
    str = str;
    ctx.font = "20px Arial";
    ctx.fillStyle = "white";
    ctx.fillText(str, 680, 360);
    for(var j=0; j<6; j++) {
        if(j==0) {
            ab = a;
        } else {
            ab = 0;
        }
        for(var i=ab; i<b; i++) {
            if(cc<=numDays(y, m)){
                ctx.fillStyle = "yellow";
                ctx.fillRect(680+(i)*(30+10),startDatPosY,30,30);
                ctx.fillStyle = "red";
                ctx.fillText(cc, 680+(i)*(30+10),startDatPosY+10);
                cc++;
            }
        }
        startDatPosY = startDatPosY + 35;
    }

    //AUGUST
    m = 8;
    firstDay = new Date(y, m-1, 1);
    for(var i=0; i<r.length; i++) {
      if((firstDay+"").indexOf(r[i]) != -1) {
        a = i;
        b = 7;
      }
    }
    startDatPosY = 380;
    cc=1;    
    str = "" + "August";
    str = str;
    ctx.font = "20px Arial";
    ctx.fillStyle = "white";
    ctx.fillText(str, 1020, 360);
    for(var j=0; j<6; j++) {
        if(j==0) {
            ab = a;
        } else {
            ab = 0;
        }
        for(var i=ab; i<b; i++) {
            if(cc<=numDays(y, m)){
                ctx.fillStyle = "yellow";
                ctx.fillRect(1020+(i)*(30+10),startDatPosY,30,30);
                ctx.fillStyle = "red";
                ctx.fillText(cc, 1020+(i)*(30+10),startDatPosY+10);
                cc++;
            }
        }
        startDatPosY = startDatPosY + 35;
    }

    //SEPTEMBER
    m = 9;
    firstDay = new Date(y, m-1, 1);
    for(var i=0; i<r.length; i++) {
      if((firstDay+"").indexOf(r[i]) != -1) {
        a = i;
        b = 7;
      }
    }
    startDatPosY = 640;
    cc=1;    
    str = "" + "September";
    str = str;
    ctx.font = "20px Arial";
    ctx.fillStyle = "white";
    ctx.fillText(str, 40, 620);
    for(var j=0; j<6; j++) {
        if(j==0) {
            ab = a;
        } else {
            ab = 0;
        }
        for(var i=ab; i<b; i++) {
            if(cc<=numDays(y, m)){
                ctx.fillStyle = "yellow";
                ctx.fillRect(marginLeft+(i)*(30+10),startDatPosY,30,30);
                ctx.fillStyle = "red";
                ctx.fillText(cc, marginLeft+(i)*(30+10),startDatPosY+10);
                cc++;
            }
        }
        startDatPosY = startDatPosY + 35;
    }
    

    //OCTOBER
    m = 10;
    firstDay = new Date(y, m-1, 1);
    for(var i=0; i<r.length; i++) {
      if((firstDay+"").indexOf(r[i]) != -1) {
        a = i;
        b = 7;
      }
    }
    startDatPosY = 640;
    cc=1;    
    str = "" + "October";
    str = str;
    ctx.font = "20px Arial";
    ctx.fillStyle = "white";
    ctx.fillText(str, 340, 620);
    for(var j=0; j<6; j++) {
        if(j==0) {
            ab = a;
        } else {
            ab = 0;
        }
        for(var i=ab; i<b; i++) {
            if(cc<=numDays(y, m)){
                ctx.fillStyle = "yellow";
                ctx.fillRect(340+(i)*(30+10),startDatPosY,30,30);
                ctx.fillStyle = "red";
                ctx.fillText(cc, 340+(i)*(30+10),startDatPosY+10);
                cc++;
            }
        }
        startDatPosY = startDatPosY + 35;
    }
    
    //NOVEMBER
    m = 11;
    firstDay = new Date(y, m-1, 1);
    for(var i=0; i<r.length; i++) {
      if((firstDay+"").indexOf(r[i]) != -1) {
        a = i;
        b = 7;
      }
    }
    startDatPosY = 640;
    cc=1;    
    str = "" + "November";
    str = str;
    ctx.font = "20px Arial";
    ctx.fillStyle = "white";
    ctx.fillText(str, 680, 620);
    for(var j=0; j<6; j++) {
        if(j==0) {
            ab = a;
        } else {
            ab = 0;
        }
        for(var i=ab; i<b; i++) {
            if(cc<=numDays(y, m)){
                ctx.fillStyle = "yellow";
                ctx.fillRect(680+(i)*(30+10),startDatPosY,30,30);
                ctx.fillStyle = "red";
                ctx.fillText(cc, 680+(i)*(30+10),startDatPosY+10);
                cc++;
            }
        }
        startDatPosY = startDatPosY + 35;
    }

    //DECEMBER
    m = 12;
    firstDay = new Date(y, m-1, 1);
    for(var i=0; i<r.length; i++) {
      if((firstDay+"").indexOf(r[i]) != -1) {
        a = i;
        b = 7;
      }
    }
    startDatPosY = 640;
    cc=1;    
    str = "" + "December";
    str = str;
    ctx.font = "20px Arial";
    ctx.fillStyle = "white";
    ctx.fillText(str, 1020, 620);
    for(var j=0; j<6; j++) {
        if(j==0) {
            ab = a;
        } else {
            ab = 0;
        }
        for(var i=ab; i<b; i++) {
            if(cc<=numDays(y, m)){
                ctx.fillStyle = "yellow";
                ctx.fillRect(1020+(i)*(30+10),startDatPosY,30,30);
                ctx.fillStyle = "red";
                ctx.fillText(cc, 1020+(i)*(30+10),startDatPosY+10);
                cc++;
            }
        }
        startDatPosY = startDatPosY + 35;
    }
    
}


setMonth(1);

<%

statement.close();

connection.close();

%>

</script>

</body>
</html>