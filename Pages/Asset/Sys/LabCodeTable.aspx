<%@ Page Language="C#" MasterPageFile="~/Templates/Sub.master" AutoEventWireup="true" CodeFile="LabCodeTable.aspx.cs" Inherits="Sub_Lab" %>

<%@ Register Src="~/Modules/PageCtrl.ascx" TagPrefix="uc1" TagName="PageCtrl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Content" runat="Server">
    <form id="formAdvOpts" runat="server">
        <input type="hidden" id="dwCodeType" name="dwCodeType" />
        <h2><%=szTitleName%>管理</h2>
        <div class="toolbar">
               <div class="tb_info">
               <div class="UniTab" id="tabl">
                     <a href="room.aspx" id="room">实验室列表</a>
                    <a href="LabCodeTable.aspx?dwCodeType=1" id="LabCodeTable1">实验室类型管理</a>
                    <a href="LabCodeTable.aspx?dwCodeType=2" id="LabCodeTable2">实验室经费来源管理</a>
                    <a href="LabCodeTable.aspx?dwCodeType=3" id="LabCodeTable3">实验室建设水平管理</a>

                </div>
            </div>

            <div class="FixBtn"><a id="btnNew">新建<%=szTitleName%></a></div>
           
        </div>
        <div class="content">
            <table class="ListTbl">
                <thead>
                    <tr>
                        <th name="szExtValue">编码</th>
                        <th name="szCodeName">名称</th>
                        <th>备注</th>
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
            var tabl = $(".UniTab").UniTab();

            $(function () {
                $(".OPTD").html('<div class="OPTDBtn">\
                       <a class="setLabBtn" title="修改"><img src="../../../themes/iconpage/edit.png"/></a>\
                       <a class="delLabBtn"  href="#" title="删除"><img src="../../../themes/iconpage/del.png""/></a>\</div>');
            $(".OPTDBtn").UIAPanel({
                theme: "none.png", borderWidth: 0, minWidth: "25", maxWidth: "75", minHeight: "25", maxHeight: "25", speed: 50
            });
            $(".setLabBtn").click(function () {
                var szLabSN = $(this).parents("tr").children().first().text();
                var dwLabID = $(this).parents("tr").children().first().attr("data-id");
                var dwCodeType = $(this).parents("tr").children().first().attr("data-type");
                $.lhdialog({
                    title: '修改',
                    width: '660px',
                    height: '300px',
                    lock: true,
                    data: Dlg_Callback,
                    content: 'url:Dlg/NewCode.aspx?op=set&szCodeSN=' + dwLabID + '&dwCodeType=' + dwCodeType
                });
            });
           
            $(".delLabBtn").click(function () {
                var szLabSN = $(this).parents("tr").children().first().text();
                var dwLabID = $(this).parents("tr").children().first().attr("data-id");
                var dwCodeType = $(this).parents("tr").children().first().attr("data-type");
                ConfirmBox("确定删除?", function () {
                    ShowWait();
                    TabReload($("#<%=formAdvOpts.ClientID%>").serialize() + "&delID=" + dwLabID + '&dwCodeType=' + dwCodeType);
                }, '提示', 1, function () { });
            });
            $("#btnNew").click(function () {
                $.lhdialog({
                    title: '新建',
                    width: '660px',
                    height: '300px',
                    lock: true,
                    content: 'url:Dlg/NewCode.aspx?op=new&dwCodeType=' + $("#dwCodeType").val()
                });
            });
            $(".ListTbl").UniTable({HeaderIndex:false});
            var tabl = $(".UniTab").UniTab();

        });
        </script>
    </form>
</asp:Content>
