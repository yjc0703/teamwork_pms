<!DOCTYPE HTML>
<html lang="ko">
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE"/>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <title>PMS</title>

  <link rel=stylesheet href="platform.css" type="text/css">
  <link rel=stylesheet href="libs/dateField/jquery.dateField.css" type="text/css">

  <link rel=stylesheet href="gantt.css" type="text/css">
  <link rel=stylesheet href="print.css" type="text/css" media="print">

  <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js"></script>
  <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>

  <script src="libs/jquery.livequery.min.js"></script>
  <script src="libs/jquery.timers.js"></script>
  <script src="libs/platform.js"></script>
  <script src="libs/date.js"></script>
  <script src="libs/i18nJs_kr.js"></script>
  <script src="libs/dateField/jquery.dateField.js"></script>
  <script src="libs/JST/jquery.JST.js"></script>

  <script src="ganttUtilities.js"></script>
  <script src="ganttTask.js"></script>
  <script src="ganttDrawer.js"></script>
  <script src="ganttGridEditor.js"></script>
  <script src="ganttMaster.js"></script>

</head>
<body style="background-color: #fff;">


<!--<div id="ndo" style="position:absolute;right:5px;top:5px;width:378px;padding:5px;background-color: #FFF5E6; border:1px solid #F9A22F; font-size:12px" class="noprint">
  This Gantt can be used in a complete project management solution - imports your Gantt and more - <a href="http://twproject.com" target="_blank">Teamwork: give it a try</a>.
</div>-->
<div id="workSpace" style="padding:0px; overflow-y:auto; overflow-x:hidden;border:1px solid #e5e5e5;position:relative;margin:0 5px"></div>

<div id="taZone" style="display:none;" class="noprint">
  <textarea rows="8" cols="150" id="ta">
  </textarea>
  <!--<textarea rows="8" cols="150" id="ta">
    {"tasks":[
    {"id":-1,"name":"Gantt editor","code":"","level":0,"status":"STATUS_ACTIVE","start":1346623200000,"duration":16,"end":1348523999999,"startIsMilestone":true,"endIsMilestone":false,"assigs":[]},
    {"id":-2,"name":"coding","code":"","level":1,"status":"STATUS_ACTIVE","start":1346623200000,"duration":10,"end":1347659999999,"startIsMilestone":false,"endIsMilestone":false,"assigs":[],"description":"","progress":0},
    {"id":-3,"name":"gant part","code":"","level":2,"status":"STATUS_ACTIVE","start":1346623200000,"duration":2,"end":1346795999999,"startIsMilestone":false,"endIsMilestone":false,"assigs":[],"depends":""},
    {"id":-4,"name":"editor part","code":"","level":2,"status":"STATUS_SUSPENDED","start":1346796000000,"duration":4,"end":1347314399999,"startIsMilestone":false,"endIsMilestone":false,"assigs":[],"depends":"3"},
    {"id":-5,"name":"testing","code":"","level":1,"status":"STATUS_SUSPENDED","start":1347832800000,"duration":6,"end":1348523999999,"startIsMilestone":false,"endIsMilestone":false,"assigs":[],"depends":"2:5","description":"","progress":0},
    {"id":-6,"name":"test on safari","code":"","level":2,"status":"STATUS_SUSPENDED","start":1347832800000,"duration":2,"end":1348005599999,"startIsMilestone":false,"endIsMilestone":false,"assigs":[],"depends":""},
    {"id":-7,"name":"test on ie","code":"","level":2,"status":"STATUS_SUSPENDED","start":1348005600000,"duration":3,"end":1348264799999,"startIsMilestone":false,"endIsMilestone":false,"assigs":[],"depends":"6"},
    {"id":-8,"name":"test on chrome","code":"","level":2,"status":"STATUS_SUSPENDED","start":1348005600000,"duration":2,"end":1348178399999,"startIsMilestone":false,"endIsMilestone":false,"assigs":[],"depends":"6"}
    ],"selectedRow":0,"deletedTaskIds":[-8, -7],"canWrite":true,"canWriteOnParent":true }
  </textarea>-->
  <button onclick="loadGanttFromServer();">load</button>
</div>

<style>
  .resEdit {
    padding: 15px;
  }

  .resLine {
    width: 95%;
    padding: 3px;
    margin: 5px;
    border: 1px solid #d0d0d0;
  }

  body {
    overflow: hidden;
  }
</style>

<script type="text/javascript">

var ge;  //this is the hugly but very friendly global var for the gantt editor
$(function() {

  //load templates
  $("#ganttemplates").loadTemplates();

  // here starts gantt initialization
  ge = new GanttMaster();
  var workSpace = $("#workSpace");
  workSpace.css({width:$(window).width() - 20,height:$(window).height() - 100});
  ge.init(workSpace);

  //inject some buttons (for this demo only)

  /*$(".ganttButtonBar div").append("<button onclick='clearGantt();' class='button'>clear</button>")
          .append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
          .append("<button onclick='openResourceEditor();' class='button'>edit resources</button>")
          .append("<button onclick='getFile();' class='button'>export</button>");
  
  $(".ganttButtonBar div").addClass('buttons');*/
  $(".ganttButtonBar h1").html("<img src='twGanttSmall.png'>");

  //overwrite with localized ones
  loadI18n();

  //simulate a data load from a server.
  loadGanttFromServer();


  //fill default Teamwork roles if any
  if (!ge.roles || ge.roles.length == 0) {
    setRoles();
  }

  //fill default Resources roles if any
  if (!ge.resources || ge.resources.length == 0) {
    setResource();
  }


  /*/debug time scale
  $(".splitBox2").mousemove(function(e){
    var x=e.clientX-$(this).offset().left;
    var mill=Math.round(x/(ge.gantt.fx) + ge.gantt.startMillis)
    $("#ndo").html(x+" "+new Date(mill))
  });*/

  //clearGantt();

});


function loadGanttFromServer(callback) {

  //this is a simulation: load data from the local storage if you have already played with the demo or a textarea with starting demo data
  //loadFromLocalStorage();

  //this is the real implementation
  
  //var taskId = $("#taskSelector").val();
  var prof = new Profiler("loadServerSide");
  prof.reset();



  $.getJSON("./PmsData", null, function(response) {
    
    if (response.ok) {
      prof.stop();

      ge.loadProject(response.project);
      ge.checkpoint(); //empty the undo stack

      if (typeof(callback)=="function") {
        callback(response);
      }
    } else {
      jsonErrorHandling(response);
    }
  });

  
  
}


function saveGanttOnServer() {

  //this is a simulation: save data to the local storage or to the textarea
  //saveInLocalStorage();


  
  var prj = ge.saveProject();

  delete prj.resources;
  delete prj.roles;

  var prof = new Profiler("saveServerSide");
  prof.reset();
  
  if (ge.deletedTaskIds.length>0) {
    if (!confirm("TASK_THAT_WILL_BE_REMOVED\n"+ge.deletedTaskIds.length)) {
      return;
    }
  }

  $.ajax("./PmsData", {
    dataType:"json",
    data: {CM:"SVPROJECT", prj:JSON.stringify(prj)},	
    type:"POST",

    success: function(response) {
	console.log(response);
      if (response.ok) {
        prof.stop();
        if (response.project) {
          ge.loadProject(response.project); //must reload as "tmp_" ids are now the good ones
        } else {
          ge.reset();
        }
      } else {
        var errMsg="Errors saving project\n";
        if (response.message) {
          errMsg=errMsg+response.message+"\n";
        }

        if (response.errorMessages.length) {
          errMsg += response.errorMessages.join("\n");
        }

        alert(errMsg);
      }
    }

  });
  
}


//-------------------------------------------  Create some demo data ------------------------------------------------------
function setRoles() {
  ge.roles = [
    {
      id:"tmp_1",
      name:"Project Manager"
    },
    {
      id:"tmp_2",
      name:"Worker"
    },
    {
      id:"tmp_3",
      name:"Stakeholder/Customer"
    }
  ];
}

function setResource() {
  var res = [];
  for (var i = 1; i <= 10; i++) {
    res.push({id:"tmp_" + i,name:"Resource " + i});
  }
  ge.resources = res;
}


function clearGantt() {
  ge.reset();
}

function loadI18n() {
  GanttMaster.messages = {
    "CHANGE_OUT_OF_SCOPE":"NO_RIGHTS_FOR_UPDATE_PARENTS_OUT_OF_EDITOR_SCOPE",
    "START_IS_MILESTONE":"START_IS_MILESTONE",
    "END_IS_MILESTONE":"END_IS_MILESTONE",
    "TASK_HAS_CONSTRAINTS":"TASK_HAS_CONSTRAINTS",
    "GANTT_ERROR_DEPENDS_ON_OPEN_TASK":"GANTT_ERROR_DEPENDS_ON_OPEN_TASK",
    "GANTT_ERROR_DESCENDANT_OF_CLOSED_TASK":"GANTT_ERROR_DESCENDANT_OF_CLOSED_TASK",
    "TASK_HAS_EXTERNAL_DEPS":"TASK_HAS_EXTERNAL_DEPS",
    "GANTT_ERROR_LOADING_DATA_TASK_REMOVED":"GANTT_ERROR_LOADING_DATA_TASK_REMOVED",
    "ERROR_SETTING_DATES":"ERROR_SETTING_DATES",
    "CIRCULAR_REFERENCE":"CIRCULAR_REFERENCE",
    "CANNOT_DEPENDS_ON_ANCESTORS":"CANNOT_DEPENDS_ON_ANCESTORS",
    "CANNOT_DEPENDS_ON_DESCENDANTS":"CANNOT_DEPENDS_ON_DESCENDANTS",
    "INVALID_DATE_FORMAT":"INVALID_DATE_FORMAT",
    "TASK_MOVE_INCONSISTENT_LEVEL":"TASK_MOVE_INCONSISTENT_LEVEL",

    "GANTT_QUARTER_SHORT":"/4분기",
    "GANTT_SEMESTER_SHORT":"반기"
  };
}


//-------------------------------------------  Open a black popup for managing resources. This is only an axample of implementation (usually resources come from server) ------------------------------------------------------
function openResourceEditor() {
  var editor = $("<div>");
  editor.append("<h2>Resource editor</h2>");
  editor.addClass("resEdit");

  for (var i in ge.resources) {
    var res = ge.resources[i];
    var inp = $("<input type='text'>").attr("pos", i).addClass("resLine").val(res.name);
    editor.append(inp).append("<br>");
  }

  var sv = $("<div>save</div>").css("float", "right").addClass("button").click(function() {
    $(this).closest(".resEdit").find("input").each(function() {
      var el = $(this);
      var pos = el.attr("pos");
      ge.resources[pos].name = el.val();
    });
    ge.editor.redraw();
    closeBlackPopup();
  });
  editor.append(sv);

  var ndo = createBlackPage(800, 500).append(editor);
}

//-------------------------------------------  Get project file as JSON (used for migrate project from gantt to Teamwork) ------------------------------------------------------
function getFile() {
  $("#gimBaPrj").val(JSON.stringify(ge.saveProject()));
  $("#gimmeBack").submit();
  $("#gimBaPrj").val("");

  /*  var uriContent = "data:text/html;charset=utf-8," + encodeURIComponent(JSON.stringify(prj));
   console.debug(uriContent);
   neww=window.open(uriContent,"dl");*/
}


//-------------------------------------------  LOCAL STORAGE MANAGEMENT (for this demo only) ------------------------------------------------------
Storage.prototype.setObject = function(key, value) {
  this.setItem(key, JSON.stringify(value));
};


Storage.prototype.getObject = function(key) {
  return this.getItem(key) && JSON.parse(this.getItem(key));
};


function loadFromLocalStorage() {
  var ret;
  if (localStorage) {
    if (localStorage.getObject("teamworkGantDemo")) {
      ret = localStorage.getObject("teamworkGantDemo");
    }
  } else {
    $("#taZone").show();
  }
  if (!ret || !ret.tasks || ret.tasks.length == 0){
    ret = JSON.parse($("#ta").val());


    //actualiza data
    var offset=new Date().getTime()-ret.tasks[0].start;
    for (var i=0;i<ret.tasks.length;i++)
      ret.tasks[i].start=ret.tasks[i].start+offset;


  }
  ge.loadProject(ret);
  ge.checkpoint(); //empty the undo stack
}


function saveInLocalStorage() {
  var prj = ge.saveProject();
  if (localStorage) {
    localStorage.setObject("teamworkGantDemo", prj);
  } else {
    $("#ta").val(JSON.stringify(prj));
  }
}


</script>


<div id="gantEditorTemplates" style="display:none;">
  <div class="__template__" type="GANTBUTTONS"><!--
  <div class="ganttButtonBar noprint">
    <h1 style="float:left">task tree/gantt</h1>
    <div class="buttons">
    <span class="ganttButtonSeparator"></span>
    <button onclick="$('#workSpace').trigger('addAboveCurrentTask.gantt');" class="button textual" title="insert above"><span class="teamworkIcon">l</span></button>
    <button onclick="$('#workSpace').trigger('addBelowCurrentTask.gantt');" class="button textual" title="insert below"><span class="teamworkIcon">X</span></button>
    <span class="ganttButtonSeparator"></span>
    <button onclick="$('#workSpace').trigger('indentCurrentTask.gantt');" class="button textual" title="indent task"><span class="teamworkIcon">.</span></button>
    <button onclick="$('#workSpace').trigger('outdentCurrentTask.gantt');" class="button textual" title="unindent task"><span class="teamworkIcon">:</span></button>
    <span class="ganttButtonSeparator"></span>
    <button onclick="$('#workSpace').trigger('moveUpCurrentTask.gantt');" class="button textual" title="move up"><span class="teamworkIcon">k</span></button>
    <button onclick="$('#workSpace').trigger('moveDownCurrentTask.gantt');" class="button textual" title="move down"><span class="teamworkIcon">j</span></button>
    <span class="ganttButtonSeparator"></span>
    <button onclick="$('#workSpace').trigger('deleteCurrentTask.gantt');" class="button textual" title="delete"><span class="teamworkIcon">&cent;</span></button>
    <span class="ganttButtonSeparator"></span>
    <span style="visibility:hidden;" class="ganttButtonSeparator"></span>
    <span style="visibility:hidden;" class="ganttButtonSeparator"></span>
    <span class="ganttButtonSeparator"></span>
    <button onclick="$('#workSpace').trigger('zoomMinus.gantt');" class="button textual" title="zoom out"><span class="teamworkIcon">)</span></button>
    <button onclick="$('#workSpace').trigger('zoomPlus.gantt');" class="button textual" title="zoom in"><span class="teamworkIcon">(</span></button>
    <span class="ganttButtonSeparator"></span>
    
      &nbsp; &nbsp; &nbsp; &nbsp;
      <button onclick="saveGanttOnServer();" class="button first big" title="save">save</button>
    </div></div>
  --></div>

  <div class="__template__" type="TASKSEDITHEAD"><!--
  <table class="gdfTable" cellspacing="0" cellpadding="0">
    <thead>
    <tr style="height:40px">
      <th class="gdfColHeader" style="width:60px;"></th>
      <th class="gdfColHeader" style="width:50px;">상태</th>
      <th class="gdfColHeader gdfResizable" style="width:20px;"></th>
      <th class="gdfColHeader gdfResizable">이름</th>
	  <th class="gdfColHeader gdfResizable" style="width:80px;">기간(일)</th>
      <th class="gdfColHeader gdfResizable" style="width:100px;">시작</th>
      <th class="gdfColHeader gdfResizable" style="width:100px;">종료</th>
      <th class="gdfColHeader gdfResizable" style="width:100px;">담당자</th>
	  <th class="gdfColHeader gdfResizable" style="width:80px;">진행률</th>
	  <th class="gdfColHeader gdfResizable" style="width:100px;">선행작업</th>
    </tr>
    </thead>
  </table>
  --></div>

  <div class="__template__" type="TASKROW"><!--
  <tr taskId="(#=obj.id#)" class="taskEditRow" level="(#=level#)">
    <th class="gdfCell edit" align="right" style="cursor:pointer;"><span class="taskRowIndex">(#=obj.getRow()+1#)</span> <span class="teamworkIcon" style="font-size:12px;" >e</span></th>
    <td class="gdfCell" align="center"><div class="taskStatus cvcColorSquare" status="(#=obj.status#)"></div></td>
    <td class="gdfCell"><span>-</span></td>
    <td class="gdfCell indentCell" style="padding-left:(#=obj.level*20#)px;"><input type="text" name="name" value="(#=obj.name#)" style="(#=obj.level>0?'border-left:2px dotted orange':''#)"></td>
	<td class="gdfCell"><input type="text" name="duration" value="(#=obj.duration#)" style="text-align:center;"></td>
    <td class="gdfCell"><input type="text" name="start"  value="" class="date" style="text-align:center;"></td>
    <td class="gdfCell"><input type="text" name="end" value="" class="date" style="text-align:center;"></td>        
    <td class="gdfCell"><input type="text" name="code" value="(#=obj.code?obj.code:''#)" style="text-align:center;"></td>
	<td class="gdfCell"><input type="text" name="progress" value="(#=obj.progress#)" style="text-align:right;width:70%">%</td>
	<td class="gdfCell"><input type="text" name="depends" value="(#=obj.depends#)" (#=obj.hasExternalDep?"readonly":""#)></td>
  </tr>
  --></div>

  <div class="__template__" type="TASKEMPTYROW"><!--
  <tr class="taskEditRow emptyRow" >
    <th class="gdfCell" align="right"></th>
    <td class="gdfCell" align="center"></td>
    <td class="gdfCell"></td>
    <td class="gdfCell"></td>
    <td class="gdfCell"></td>
    <td class="gdfCell"></td>
    <td class="gdfCell"></td>
    <td class="gdfCell"></td>
    <td class="gdfCell"></td>
	<td class="gdfCell"></td>
  </tr>
  --></div>

  <div class="__template__" type="TASKBAR"><!--
  <div class="taskBox" taskId="(#=obj.id#)" >
    <div class="layout (#=obj.hasExternalDep?'extDep':''#)">
      <div class="taskStatus" status="(#=obj.status#)"></div>
      <div class="taskProgress" style="width:(#=obj.progress>100?100:obj.progress#)%; background-color:(#=obj.progress>100?'red':'rgb(153,255,51);'#);"></div>
      <div class="milestone (#=obj.startIsMilestone?'active':''#)" ></div>

      <div class="taskLabel"></div>
      <div class="milestone end (#=obj.endIsMilestone?'active':''#)" ></div>
    </div>
  </div>
  --></div>


  <div class="__template__" type="CHANGE_STATUS"><!--
    <div class="taskStatusBox">
      <div class="taskStatus cvcColorSquare" status="STATUS_ACTIVE" title="진행중"></div>
      <div class="taskStatus cvcColorSquare" status="STATUS_DONE" title="완료"></div>
      <div class="taskStatus cvcColorSquare" status="STATUS_FAILED" title="실패"></div>
      <div class="taskStatus cvcColorSquare" status="STATUS_SUSPENDED" title="대기중"></div>
      <div class="taskStatus cvcColorSquare" status="STATUS_UNDEFINED" title="미지정"></div>
    </div>
  --></div>


  <div class="__template__" type="TASK_EDITOR"><!--
  <div class="ganttTaskEditor">
  <table width="100%">
    <tr>
      <td>
        <table cellpadding="5">
          <tr>
            <td><label for="code">담당자</label><br><input type="text" name="code" id="code" value="" class="formElements"></td>
           </tr><tr>
            <td><label for="name">이름</label><br><input type="text" name="name" id="name" value=""  size="35" class="formElements"></td>
          </tr>
          <tr></tr>
            <td>
              <label for="description">설명</label><br>
              <textarea rows="5" cols="30" id="description" name="description" class="formElements"></textarea>
            </td>
          </tr>
        </table>
      </td>
      <td valign="top">
        <table cellpadding="5">
          <tr>
          <td colspan="2"><label for="status">상태</label><br><div id="status" class="taskStatus" status=""></div></td>
          <tr>
          <td colspan="2"><label for="progress">진행률</label><br><input type="text" name="progress" id="progress" value="" size="3" class="formElements"></td>
          </tr>
          <tr>
          <td><label for="start">시작</label><br><input type="text" name="start" id="start"  value="" class="date" size="10" class="formElements"><input type="checkbox" id="startIsMilestone"> </td>
          <td rowspan="2" class="graph" style="padding-left:50px"><label for="duration">dur.</label><br><input type="text" name="duration" id="duration" value=""  size="5" class="formElements"></td>
        </tr><tr>
          <td><label for="end">종료</label><br><input type="text" name="end" id="end" value="" class="date"  size="10" class="formElements"><input type="checkbox" id="endIsMilestone"></td>
        </table>
      </td>
    </tr>
    </table>
  <div style="text-align: right; padding-top: 20px"><button id="saveButton" class="button big">save</button></div>
  </div>
  --></div>


  <div class="__template__" type="ASSIGNMENT_ROW"><!--
  <tr taskId="(#=obj.task.id#)" assigId="(#=obj.assig.id#)" class="assigEditRow" >
    <td ><select name="resourceId"  class="formElements" (#=obj.assig.id.indexOf("tmp_")==0?"":"disabled"#) ></select></td>
    <td ><select type="select" name="roleId"  class="formElements"></select></td>
    <td ><input type="text" name="effort" value="(#=getMillisInHoursMinutes(obj.assig.effort)#)" size="5" class="formElements"></td>
    <td align="center"><span class="teamworkIcon delAssig" style="cursor: pointer">d</span></td>
  </tr>
  --></div>

</div>
<script type="text/javascript">
  $.JST.loadDecorator("ASSIGNMENT_ROW", function(assigTr, taskAssig) {

    var resEl = assigTr.find("[name=resourceId]");
    for (var i in taskAssig.task.master.resources) {
      var res = taskAssig.task.master.resources[i];
      var opt = $("<option>");
      opt.val(res.id).html(res.name);
      if (taskAssig.assig.resourceId == res.id)
        opt.attr("selected", "true");
      resEl.append(opt);
    }


    var roleEl = assigTr.find("[name=roleId]");
    for (var i in taskAssig.task.master.roles) {
      var role = taskAssig.task.master.roles[i];
      var optr = $("<option>");
      optr.val(role.id).html(role.name);
      if (taskAssig.assig.roleId == role.id)
        optr.attr("selected", "true");
      roleEl.append(optr);
    }

    if (taskAssig.task.master.canWrite) {
      assigTr.find(".delAssig").click(function() {
        var tr = $(this).closest("[assigId]").fadeOut(200, function() {
          $(this).remove();
        });
      });
    }


  });
</script>



</body>
</html>