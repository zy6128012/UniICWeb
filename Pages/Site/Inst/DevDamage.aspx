<%@ Page Language="C#" MasterPageFile="~/Templates/Sub.master" AutoEventWireup="true" CodeFile="DevDamage.aspx.cs" Inherits="Sub_Room" %>

<%@ Register Src="~/Modules/PageCtrl.ascx" TagPrefix="uc1" TagName="PageCtrl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Content" runat="Server">
    <form id="formAdvOpts" runat="server">
        <h2><%=ConfigConst.GCDevName %>报修记录</h2>
      <input type="hidden" name="dwDevID" id="dwDevID" />
        <div class="toolbar">
            <div class="tb_info"></div>
             
            <div id="btnDevKind" class="FixBtn"><a>报修<%=ConfigConst.GCDevName %></a></div>
            <div class="tb_btn">               
            </div>
        </div>  

         <div  class="tb_infoInLine"  style="margin:5px 0px">
            <table style="width:99%">
               <tr>
                   <th>开始日期</th>
                   <td>
                    <input type="text" name="dwStartDate" id="dwStartDate" runat="server" />   
                   </td>
                   <th>开始日期</th>
                   <td><input type="text" name="dwEndDate" id="dwEndDate" runat="server"  /></td>
                    <th>设备编号</th>
                   <td><input type="text" name="dwDevSN" id="dwDevSN" /></td>
                    <th>状态:</th>
                    <td><select name="dwStatus" id="dwStatus">
                        <%=szStatus %>
                        </select></td>
                  <th><input type="submit" id="btn" value="查询" /></th>
               </tr>
           </table>
               </div>
        <div class="content">
            <table class="ListTbl">
                <thead>
                    <tr>
                        <th name="szAssertSN"><%=ConfigConst.GCDevName %>编号</th>
                        <th name="szDevName"><%=ConfigConst.GCDevName %>名称</th>
                        <th><%=ConfigConst.GCDevName %>所在<%=ConfigConst.GCDeptName %></th>
                        <th name="dwDamageDate">损坏时间</th>
                         <th>损坏描述</th>
                        <th name="dwStatus">状态</th>
                        <th>维修说明</th>
                        <th name="dwRepareDate">修复时间</th>
                        <th name="szRepareCom">维修单位</th>
                        <th>维修单位电话</th>
                        <th name="dwRepareCost">维修费用</th>    
                        <th name="szManName">报修人员</th>     
                        <th width="25px">操作</th>
                    </tr>
                </thead>
                <tbody id="ListTbl">
                    <%=m_szOut %>
                </tbody>
            </table>
            <uc1:PageCtrl runat="server" ID="PageCtrl" />
        </div>
        <script type="text/javascript">
           
            $(function () {
                $(".ListTbl").UniTable({ ShowCheck: false, HeaderIndex: true });
                $("#btn").button();
                $("#<%=dwStartDate.ClientID%>,#<%=dwEndDate.ClientID%>").datepicker();
                $(".OPTD").html('<div class="OPTDBtn">\
                            <a  class="setDevkindBtn" href="#" title="修复设置"><img src="../../../themes/iconpage/edit.png"/></a>\</div>');
                $(".OPTDBtn").UIAPanel({
                    theme: "none.png", borderWidth: 0, minWidth: "25", maxWidth: "175", minHeight: "25", maxHeight: "25", speed: 50
                });
                $("#dwDevSN").autocomplete({
                    source: "../data/searchdevice.aspx?Type=assertsn",
                    minLength: 0,
                    select: function (event, ui) {
                        if (ui.item) {
                            if (ui.item.id && ui.item.id != "") {
                                $("#dwDevSN").val(ui.item.szAssertSN);
                                $("#dwDevID").val(ui.item.id);
                            }
                        }
                        return false;
                    },
                    response: function (event, ui) {
                        if (ui.content.length == 0) {
                            ui.content.push({ label: " 未找到配置项 " });
                        }
                    }
                }).blur(function () {
                    if ($(this).val() == "") {
                        $("#dwDevID").val("");
                    } else {

                    }
                }).click(function () {
                    $("#dwDevSN").autocomplete("search", "");
                });
                $("#btnDevKind").click(function () {
                    $.lhdialog({
                        title: '<%=ConfigConst.GCDevName%>报修',
                        width: '660px',
                        height: '450px',
                        lock: true,
                        data: Dlg_Callback,
                        content: 'url:Dlg/NewDevDemage.aspx?op=new'
                    });
                });
                $(".InfoDevKindBtn").click(function () {                    
                    var dwDevKind = $(this).parents("tr").children().first().children().first().val();
                    $.lhdialog({
                        title: '介绍',
                        width: '760px',
                        height: '650px',
                        lock: true,
                        data: Dlg_Callback,
                        content: 'url:../../ueditor/default.aspx?id=' + dwDevKind + "&type=DevKindInfo"
                    });
                });
                $(".setDevkindBtn").click(function () {
                    var dwDevKind = $(this).parents("tr").children().first().data("id");
                    $.lhdialog({
                        title: '修复设置',
                        width: '660px',
                        height: '450px',
                        lock: true,
                        data: Dlg_Callback,
                        content: 'url:Dlg/setDevDemage.aspx?op=set&dwSID=' + dwDevKind
                    });
                });
                $(".DelbtnDevKind").click(function () {                    
                    var devKindID = $(this).parents("tr").children().first().children().first().val();                  
                    ConfirmBox("确定删除?", function () {
                        ShowWait();
                        TabReload($("#<%=formAdvOpts.ClientID%>").serialize() + "&delID=" + devKindID);
                }, '提示', 1, function () { });
                 });
                $(".ListTbl").UniTable({ ShowCheck: false, HeaderIndex: true });
            });
            function SelectAllCheck() {
                $("#ListTbl :checkbox").attr("checked", "checked");
                $("#ListTbl :checkbox").parent().parent().addClass("selected");
            }
        </script>
    </form>
</asp:Content>
