<%@ Page Language="C#" MasterPageFile="~/Templates/Dlg.master" AutoEventWireup="true" CodeFile="SetRoom.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Content" runat="Server">
    <form id="Form1" runat="server">
        <div class="formtitle"><%=m_Title %></div>
        <input type="hidden" id="dwRoomID" name="dwRoomID" />
        <div class="formtable">
            <table>
                <tr>
                    <td>编号：</td>
                    <td>
                        <select id="szRoomNo" name="szRoomNo">
                            <%=m_szDoorCtrl %>
                          <option value="F101">F101</option>
                             <option value="F102">F102</option>
                             <option value="F103">F103</option>
                        </select></td>
                </tr>
                <tr>
                    <td>名称：</td>
                    <td>
                        <input id="szRoomName" name="szRoomName" class="validate[required]" /></td>
                </tr>
                <tr>
                    <td>所在楼层：</td>
                    <td>
                        <input id="dwFloor" name="dwFloor" /></td>
                </tr>
                <tr>
                    <td>大楼编号：</td>
                    <td>
                        <input id="szBuildingNo" name="szBuildingNo" /></td>
                </tr>
                <tr>
                    <td>大楼名称：</td>
                    <td>
                        <input id="szBuildingName" name="szBuildingName" /></td>
                </tr>
                <tr>
                    <td>所属<%=ConfigConst.GCLabName %>：</td>
                    <td>
                        <select id="dwLabID" name="dwLabID">
                            <%=m_szLab %>
                        </select></td>
                </tr>
                <tr>
                    <td>控制方式：</td>
                    <td>
                        <%=m_szRoomMode %>
                       </td>
                </tr>
                <tr>
                    <th>开放规则：</th>
                    <td>
                        <select id="dwOpenRuleSN" name="dwOpenRuleSN">
                            <%=m_szOpenRule %>
                        </select></td>
                </tr>
                <tr>
                    <th>备注：</th>
                    <td>
                        <input id="szMemo" name="szMemo" /></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
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
