<%@ Page Language="C#" MasterPageFile="~/Templates/Dlg.master" AutoEventWireup="true" CodeFile="YardResvCheck.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Content" runat="Server">
    <form id="Form1" runat="server">
        <div class="formtitle"><%=m_Title %></div>
        <div class="formtable">
            <input id="dwLabID" name="dwLabID" type="hidden" />
            <input id="dwSecurityLevel" name="dwSecurityLevel" type="hidden" />
            <input id="dwActivityLevel" name="dwActivityLevel" type="hidden" value="10" />
            <input id="resvDate" name="resvDate" type="hidden" value="<%=szPreDate %>" />
            <input id="resvDates" name="resvDates" type="hidden" value="<%=szPreDate %>" />
            <input id="resvBegin" name="resvBegin" type="hidden" value="<%=szResvBegin %>" />
            <input id="resvEnd" name="resvEnd" type="hidden" value="<%=szResvEnd %>" />
            <input id="YardActivitySN" name="YardActivitySN" type="hidden"/>
            <input type="hidden" name="dwCheckID" id="dwCheckID" />
            <input type="hidden" name="szCheckURl" id="szCheckURl" />
            <input type="hidden" name="ID" id="ID" />
            <table class="DlgListTbl">
               
                <tr>
                      <td rowspan="2">申请人信息</td>
                    <th>申请人姓名：</th>
                    <td>
                        <div id="szTrueName"></div>
                    </td>
                    <th>申请人所在部门：</th>
                    <td>
                        <div id="szUserDeptName"></div>
                    </td>
                </tr>
                <tr>
                  
                    <th>手机：</th>
                    <td>
                        <div id="szHandPhone"></div>
                    </td>
                    <th>邮件：</th>
                    <td>
                        <div id="szEmail"></div>
                    </td>
                </tr>
                <tr>
                      <td rowspan="5">用途/性质</td>
                     <th>活动名称：</th>
                    <td colspan="3">
                        <div id="szResvName"></div>
                    </td>
                   
 </tr>
                <tr>
                     <th>组织方：</th>
                    <td colspan="3">
                        <div><%=szOrganiger %></div>
                    </td>
                </tr>
                 <tr>
                      <th>活动类型：</th>
                    <td colspan="3">
                       <%=szYardKind %>
                    </td>
                </tr>
                <tr>
                    <th>是否具有营利性：</th>
                    <td colspan="3">
                        <label><input name="resvPro1" class="prop_profit" type="radio" value="1">&nbsp;营利性&nbsp;</label>
                            <label><input name="resvPro1" type="radio" checked="checked" value="2">&nbsp;非营利性&nbsp;</label>
                    </td>
                    </tr>
                <tr>
                    <th>是否公开活动：</th>
                    <td colspan="3">
                 <label><input name="resvPro2" class="prop_profit" type="radio" value="1" />&nbsp;活动不公开&nbsp;</label>
                            <label><input name="resvPro2" type="radio" checked="checked" value="2" />&nbsp;活动公开&nbsp;</label>
                        </td>
                        </tr>
                <tr>
                    <td rowspan="2">主讲人情况</td>
                     <th>主讲人姓名：</th>
                    <td colspan="3">
                        <div id="szPresenter"></div>
                    </td>
                    </tr>
                <tr>
                    <th> 背景介绍：</th>
                    <td colspan="3">
                         <div id="szIntroInfo"></div>
                    </td>
                    
                    </tr>
                <tr>
                    <td rowspan="2">出席者情况</td>
                      <th>参与条件：</th>
                    <td colspan="3">
                         <div id="szDesiredUser"></div>
                    </td>
                    </tr>
                <tr>
                    <th> 出席人数：</th>
                    <td colspan="3">
                        <!--<input type="text" id="dwMinAttendance" name="dwMinAttendance" style="width:40px;" />到  --><input type="text" id="dwMaxAttendance" name="dwMaxAttendance" style="width:40px;" />
                    </td>
                </tr>
                <tr>
                    <th colspan="2">申请资源：</th>
                    <td colspan="3">
                        <%if (szDevList == "")
                          {%>
                        <div id="szDevName"><%=szResvDevName %></div>
                        <%}
                          else
                          { %>
                          <select id="devID" name="devID">
                            <%=szDevList %>
                        </select>
                        <a id="aSelectDev">分配资源</a>
                        <%}
                         
                        %>
                      
                    </td>
                  
                </tr>
               
                  <tr>
                    <th colspan="2" style="width:120px">申请时间：</th>
                    <td colspan="3">
                        <div title="<%=szResvTimeAll %>" id="szCycRule">
                            
                        </div>
                     <!--   <div id="dwApplyUseTime" title=""><%=szResvTime %></div>-->
                    </td>

                </tr>
                 <tr>
                    <th colspan="2" style="width:120px">备注信息：</th>
                    <td colspan="3">
                        <%=szMemoYardResv %>
                    </td>

                </tr>
                <tr>
                    <th colspan="2">部门审核意见：</th>
                    <td>
                        <div id="szPreCheckDetail"><%=szPreCheckDetail %></div>
                    </td>
                    <th style="width:120px">审核意见：</th>
                    <td>
                        <input type="text" style="width: 150px" name="szCheckDetail" id="szCheckDetail" /></td>
                </tr>
                <!--
                <tr>
                    <td colspan="4" style="text-align: center">
                        <%//if (szFileName != "")
                    { %>
                        <a style="color: blue" target="_blank" href="<%=szFileName %>">点击下载申请报告</a>
                        <%} %>
                    </td>
                </tr>
                -->
                <tr>
                    <td colspan="5" style="text-align: center">
                        <button type="submit" id="OK">审核通过</button>
                        <button type="button" id="Cancel">审核不通过</button></td>
                </tr>
            </table>
            <div id="divNoOK">
                <table>
                    <tr>
                        <td>审核意见：
                        <input type="text" name="szCheckInfo" id="szCheckInfo" title="审核不通过必须输入原因" />

                            <input type="button" id="btnNOOK" value="确定不通过" style="width: 90px" />
                            <input type="button" id="btnClose" value="关闭" style="width: 80px" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
       <div id="divSelectDev">
        <table>
             <tr>
                                <td style="width:60px;text-align:right">校区：</td>
                                <td style="text-align:left"><select style="width:100px"  id="szCamp" name="szCamp"><%=szCamp %></select></td>
                                <td style="width:60px;text-align:right">楼宇：</td>
                                <td style="text-align:left"><select style="width:100px" id="building" name="building"><%=szBuilding %></select></td>
                              <td style="width:60px;text-align:right">类型：</td>
                                <td style="text-align:left"><select style="width:100px"  id="szKinds" name="szKinds"><%=szKinds %></select></td>
                                <td style="width:60px;text-align:right">名称：</td>
                                <td style="text-align:left"><input  style="width:100px" type="text" name="szSelectDevName" id="szSelectDevName"/></td>
                                <td><input style="width:100px" type="button" id="btnSearch" value="查询" /></td>
                            </tr>
                            <tr>
                                <table id="table" class="gridtable" style="width:650px">
                                  
                                        <th>名称</th>
                                        <th>楼宇</th>
                                        <th>校区</th>
                                    <th>类型</th>
                                    <th>容量</th>  
                                       <th>操作</th>  
                                    <tbody id="theadTable">
                              
                                          </tbody>
                                    
                                </table>
                            </tr>
        </table>
       </div>
    </form>
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
      table.gridtable {
	font-family: verdana,arial,sans-serif;
	font-size:11px;
	color:#333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
}
table.gridtable th {
	border-width: 1px;
	padding: 8px;
    text-align:center;
	border-style: solid;
	border-color: #666666;
	background-color: #dedede;
}
table.gridtable td {
	border-width: 1px;
    text-align:center;
	padding: 8px;
	border-style: solid;
	border-color: #666666;
	background-color: #ffffff;
}
    </style>
    <script language="javascript" type="text/javascript">
        $(function () {
            var vcheckis=<%=szIsCheck%>;
          
            if(vcheckis==false)
                {
                //$("input:radio").attr("disabled", true);
            }
            $("#divSelectDev").dialog({
                autoOpen: false,
                height: 400,
                width: 750,
                modal: true,
                show: {
                    effect: "blind",
                    duration: 1000
                },
                hide: {
                    effect: "blind",
                    duration: 1000
                }
            });
            var vDevIDOld = 0;
            setTimeout(function () {
                vDevIDOld = $("#devID").val();
            }, 100);
            $("#aSelectDev").click(function () {
                $("#divSelectDev").dialog("open");
            });
           

            $("#szCamp").change(function () {
                var campidV = $("#szCamp").val();
                $.get(
           "../../data/searchBuilding.aspx",
           { campid: campidV },
           function (data) {

               var vCamp = eval(data);
               $('#building').empty();
               for (var i = 0; i < vCamp.length; i++) {
                   $('#building').append($("<option value='" + vCamp[i].id + "'>" + vCamp[i].label + "</option>"));
               }
           }
         );
            });

            $("#btnSearch").button().click(function () {
                var vApplyAgain = $("#applayAggin").val();
                var szCampID = $("#szCamp").val();
                var szbuilding = $("#building").val();
                var szszDevName = $("#szDevName").val();
                var szKinds = $("#szKinds").val();
                var szSelectDevName = $("#szSelectDevName").val();
                var resvDates = $("#resvDates").val();
                var resvBegin = $("#resvBegin").val();
                var resvEnd = $("#resvEnd").val();
                var YardActivitySN = $("#YardActivitySN").val();
                $.get(
                         "../../data/searchSiteDevResvState.aspx",
                         { szCamp: szCampID, beginTime: resvBegin, endTime: resvEnd, szBuilding: szbuilding, dates: resvDates, kinds: szKinds, devName: szSelectDevName, YardActivitySN: YardActivitySN },
                         function (data) {
                             var vCamp = eval(data);
                             $('#theadTable').empty();
                             for (var i = 0; i < vCamp.length; i++) {
                                 var v = vCamp[i];
                                 var tr = $("<tr></tr>");
                                 tr.append("<td>" + v.szDevName + "</td>");
                                 tr.append("<td>" + v.szBuildingName + "</td>");
                                 tr.append("<td>" + v.szCampName + "</td>");
                                 tr.append("<td>" + v.szKindName + "</td>");
                                 tr.append("<td>" + v.dwMaxUser + "</td>");
                                 tr.append("<td> <a class='selectDev' aName='" + v.szDevName + "' id=" + v.id + ">选择</a></td>");
                                 $('#theadTable').prepend(tr);

                             }
                         }
                       );
            });
            $('#theadTable').on("click",".selectDev",function () {
                var vthis = $(this);
                var vID=vthis.attr("id");
                var vName = vthis.attr("aName");
                $("#devID").empty();
                $("#devID").prepend("<option value='" + vID + "'>" + vName + "</option>");
                $("#divSelectDev").dialog("close");
            });
            $("#devID").change(function () {

                var vDevID = $(this).val();
                if (vDevID == vDevIDOld) {
                    return;
                }
                var vBeginTime = $("#resvBegin").val();
                var vEndTime = $("#resvEnd").val();
                var vresvDate = $("#resvDate").val();
                $.ajax({
                    type: "post",
                    url: "../../data/GetSingledevResvState.aspx?devid=" + vDevID + "&date=" + vresvDate + "&BeginTime=" + vBeginTime + "&EndTime" + vEndTime,
                    dataType: "json",
                    success: function (data) {
                        if (data != "" && data == "true") {
                            //alert('空闲');
                        }
                        else {
                            MessageBox("无可分配时间", "无可分配时间", 2);
                        }

                    }
                });
            });
        <%if (bSet)
          {%>
            $("#dwSN").attr("readonly", "readonly").addClass("disabled");
        <%}%>
            $("#dwOwnerDept").change(function () {
                $("#szDeptName").val($(this).find("option:selected").text());
            });
            $("#Cancel").click(function () {
                $("#divNoOK").show();
            });
            $("#divNoOK").hide();
            $("#OK").button();
            $("#btnClose").button().click(Dlg_Cancel);
            $("#btnNOOK").button();
            $("#btnNOOK").click(function () {
                var szCheckInfo = $("#szCheckInfo").val();
                
                if (szCheckInfo == "") {
                    return;
                }
                var id = $("#dwCheckID").val();
                var vCheckstate = $("#szCheckURl").val();
                var checkids = $("#ID").val();
                var vApplyAgain = "1";
                $.get(
                         "../../ajaxpage/YearResvCheck.aspx",
                         { szCheckInfo: szCheckInfo, id: checkids, vApplyAgain: vApplyAgain, checkstate: vCheckstate },
                         function (data) {
                             if (data == "success") {
                                 MessageBox("审核不通过", "提示", 3, function () { Dlg_OK() });
                             }
                             else {
                                 MessageBox("审核失败" + data, "提示", 3, function () { Dlg_OK() });
                             }

                         }
                       );

            });
            $("#Cancel").button();
            $("#szManName2").autocomplete({
                source: "../../data/searchAccount.aspx",
                select: function (event, ui) {
                    if (ui.item) {
                        if (ui.item.id && ui.item.id != "") {
                            $("#szManName").val(ui.item.label);
                            $("#szManName2").val(ui.item.label);
                            $("#dwManagerID").val(ui.item.id);
                        }
                    }
                    return false;
                },
                response: function (event, ui) {
                    if (ui.content.length == 0) {
                        $("#dwManagerID").val("");
                        $("#szManName").val("");
                        ui.content.push({ label: " 未找到配置项 " });
                    }
                }
            }).blur(function () {
                if ($("#dwManagerID").val() == "") {
                    $(this).val("");
                } else {
                    $(this).val($("#szManName").val());
                }
            });

            $("#szAttendantName2").autocomplete({
                source: "../../data/searchAccount.aspx",
                select: function (event, ui) {
                    if (ui.item) {
                        if (ui.item.id && ui.item.id != "") {
                            $("#szAttendantName").val(ui.item.label);
                            $("#szAttendantName2").val(ui.item.label);
                            $("#dwAttendantID").val(ui.item.id);
                        }
                    }
                    return false;
                },
                response: function (event, ui) {
                    if (ui.content.length == 0) {
                        $("#dwAttendantID").val("");
                        $("#szAttendantName").val("");
                        ui.content.push({ label: " 未找到配置项 " });
                    }
                }
            }).blur(function () {
                if ($("#dwAttendantID").val() == "") {
                    $(this).val("");
                } else {
                    $(this).val($("#szAttendantName").val());
                }
            });

            setTimeout(function () {
                if ($("#dwManagerID").val() == "") {
                    $("#szManName2").val("");
                } else {
                    $("#szManName2").val($("#szManName").val());
                }

                if ($("#dwAttendantID").val() == "") {
                    $("#szAttendantName2").val("");
                } else {
                    $("#szAttendantName2").val($("#szAttendantName").val());
                }
            }, 1);
        });
    </script>
</asp:Content>
