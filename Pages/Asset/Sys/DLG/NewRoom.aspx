<%@ Page Language="C#" MasterPageFile="~/Templates/Dlg.master" AutoEventWireup="true" CodeFile="NewRoom.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Content" runat="Server">
    <form id="Form1" runat="server">
        <div class="formtitle"><%=m_Title %></div> 
        <input type="hidden" id="dwRoomID" name="dwRoomID" />
        <input type="hidden" id="dwLabID" name="dwLabID" />
        <input id="dwDeptID" name="dwDeptID" type="hidden" />
        <input type="hidden" id="dwManGroupID" name="dwManGroupID" />
        <input type="hidden" id="dwCampusID" name="dwCampusID" />
        <div class="formtable">
            <table>
                 <tr>
                    <th>编号：</th>
                    <td>
                        <input type="text" id="szRoomNo" name="szRoomNo" /></td>               
                    <th>名称：</th>
                    <td>
                        <input id="szRoomName" name="szRoomName" class="validate[required]" /></td>
                </tr>
                 <tr>
                  <th>类型:</th>
                  <td><select id="szLabKindCode" name="szLabKindCode"><%=m_szLabKind %></select></td>
                    <th>来源:</th>
                  <td><select id="szLabFromCode" name="szLabFromCode"><%=m_szLabFromCode%></select></td>
              </tr> 
                 <tr>                  
                    <th>面积：</th>
                    <td>
                        <input type="text" id="dwRoomSize" name="dwRoomSize" class="validate[validate[custom[integer]]" /></td>
                     <th>位置：</th>
                    <td>
                        <input type="text" id="szFloorNo" name="szFloorNo" /></td>
                    </tr> 
              
                      <tr>
               
                     <th>所属学科：</th>
                    <td><select id="szAcademicSubjectCode" name="szAcademicSubjectCode"><%=m_dwDecam %></select></td>
                      <th>建设水平：</th>
                    <td>
                       <select id="szLabLevelCode" name="szLabLevelCode"><%=m_szLabLevelCode%></select></td>
                </tr>           
                <tr>                   
                    <th>责任单位：</th>
                    <td>
                        <input type="text" id="szDeptName" name="szDeptName" /></td>
                     <th>建成时间：</th>
                    <td>
                        <input type="text" id="dwCreateDate" name="dwCreateDate" /></td>
                   
                </tr>
                <tr>
                  <th>开放规则：</th>
                    <td>
                        <select id="dwOpenRuleSN" name="dwOpenRuleSN">
                            <%=m_szOpenRule %>
                        </select></td> 
                     <th>缩写：</th>
                    <td colspan="1">
                     <input type="text" id="szMemo" name="szMemo" />
                        
                    </td>
                </tr>     
                 <tr>
                     <td></td>
                    <td colspan="3"><label><input id="chkNewDev" name="chkNewDev" class="enum" type="checkbox" value="1" />统一预约</label></td>
                </tr>                                
                <tr>
                    <td colspan="4" class="btnRow">
                        <button type="submit" id="OK">确定</button>
                        <button type="button" id="Cancel">取消</button></td>
                </tr>
            </table>
        </div>
    </form>
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
        
    </style>
    <script language="javascript" type="text/javascript">
        $(function () {
            $("#dwCreateDate").datepicker({
                changeMonth: true,
                changeYear: true
            });
            AutoDept($("#szDeptName"), 2, $("#dwDeptID"), false);
        <%if (bSet)
          {%>
        $("#dwSN").attr("readonly", "readonly").addClass("disabled");
        <%}%>
        $("#dwOwnerDept").change(function () {
            $("#szDeptName").val($(this).find("option:selected").text());
        });
        $("#OK").button();
        $("#Cancel").button().click(Dlg_Cancel);
        $("#szManName2").autocomplete({
            source: "searchAccount.aspx",
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
            source: "searchAccount.aspx",
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
