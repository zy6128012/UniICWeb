<%@ Page Language="C#" MasterPageFile="~/Templates/Sub.master" AutoEventWireup="true" CodeFile="seatlab.aspx.cs" Inherits="Sub_Room" %>

<%@ Register Src="~/Modules/PageCtrl.ascx" TagPrefix="uc1" TagName="PageCtrl" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Content" runat="Server">
    <form id="formAdvOpts" runat="server">
        <h2>区域所在<%=ConfigConst.GCLabName %></h2>
        <input type="hidden" id="AllOp" name="AllOp" />
       
        <div class="toolbar">
           <div class="tb_info">
                <div class="UniTab" id="tabl">
                    <a href="syskindSeat.aspx" id="syskindSeat"><%=ConfigConst.GCSysKindSeat%>管理</a>
                    <a href="SeatRoom.aspx" id="SeatRoom"><%=ConfigConst.GCSysKindSeat%>所在区域</a>
                    <%if(ConfigConst.GCICLabRoom==1) {%>
                     <a href="seatLab.aspx" id="seatLab">区域所在<%=ConfigConst.GCLabName %></a>
                    <%} %>
                    <a href="SeatKind.aspx" id="SeatKind"><%=ConfigConst.GCSysKindSeat%><%=ConfigConst.GCKindName %></a>                    
                    <%if (ConfigConst.GCKindAndClass == 0)
                      {%>
                    <a href="SeatClass.aspx" id="PCClass"><%=ConfigConst.GCSysKindSeat%><%=ConfigConst.GCClassName %></a>
                    <%} %>
                     <a href="resvruleSeat.aspx?kind=64" id="resvrule">预约规则</a>
                </div>
                 </div>
            <div class="FixBtn">
                <a id="btnNewRoom">新建<%=ConfigConst.GCLabName %></a>
             
            </div>
            <div class="tb_btn">
                <!--<div class="AdvOpts" page="RoomAdvOpts.aspx">
                    <div class="AdvLab">高级选项</div>
                </div>-->
            </div>
        </div>  
         
        <div class="content">
            <table class="ListTbl">
                <thead>
                    <tr>
                        <th name="szLabSN"><%=ConfigConst.GCLabName %>编号</th>           
                        <th name="szLabName"><%=ConfigConst.GCLabName %>名称</th>
                    <th>空闲数</th>     
                          <th>总数</th>     
                        <th name="szMemo">备注</th>                                                
                        <th width="25px"></th>
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
                var tabl = $(".UniTab").UniTab();
                $(".opt").css({ width: "120px" }).change(function (userChanged) {
                    if (TabReload && userChanged) {
                        TabReload($(this).parents("form").serialize());
                    }
                });

                function fAllOp(op) {
                }

                $(".class2").html('<div class="OPTDBtn">\
                            <a  class="setRoomBtn" href="#" title="修改"><img src="../../../themes/iconpage/edit.png"/></a>\
                            <a href="#" class="delRoomBtn" title="删除"><img src="../../../themes/iconpage/del.png""/></a>\</div>');
                $(".OPTDBtn").UIAPanel({
                    theme: "defaultbg.png", borderWidth: 0, minWidth: "25", maxWidth: "150", minHeight: "25", maxHeight: "25", speed: 50
                });              
                $(".OPTDBtnSet").UIAPanel({
                    theme: "none.png", borderWidth: 10, minWidth: "80", maxWidth: "150", minHeight: "25", maxHeight: "25", speed: 50
                });
                $("#btnNewRoom").click(function () {
                    $.lhdialog({
                        title: '新建',
                        width: '720px',
                        height: '300px',
                        lock: true,
                        data: Dlg_Callback,
                        content: 'url:Dlg/newlab.aspx?op=new&dwLabClass=8'
                    });
                });
                $(".setPostion").click(function () {
                    var dwRoomID = $(this).parents("tr").children().first().data("id");
                    window.open("../../../mobileclient/test.aspx?op=getPostion&szlabid="+dwRoomID);
                });
                
                $(".InfoRoomBtn").click(function () {                  
                    var dwRoomID = $(this).parents("tr").children().first().data("id");
                    $.lhdialog({
                        title: '介绍',
                        width: '720px',
                        height: '550px',
                        lock: true,
                        data: Dlg_Callback,
                        content: 'url:../../ueditor/default.aspx?id=' + dwRoomID + "&type=RoomInfo"
                    });
                });
                $(".setRoomBtn").click(function () {
                    var dwRoomID = $(this).parents("tr").children().first().data("id");
                    $.lhdialog({
                        title: '修改',
                        width: '720px',
                        height: '300px',
                        lock: true,
                        data: Dlg_Callback,
                        content: 'url:Dlg/setlab.aspx?op=set&dwLabClass=8&dwLabID=' + dwRoomID
                    });
                });
                $(".manGroupList").click(function () {
                    var dwRoomID = $(this).parents("tr").children().first().next().attr("ManGroupID");
                    $.lhdialog({
                        title: '管理员名单',
                        width: '720px',
                        height: '450px',
                        lock: true,
                        data: Dlg_Callback,
                        content: 'url:Dlg/ManGroupList.aspx?op=set&dwID=' + dwRoomID
                    });
                });
                $(".delRoomBtn").click(function () {
                    var dwRoomID = $(this).parents("tr").children().first().data("id");
                    ConfirmBox("确定删除?", function () {
                        ShowWait();
                        TabReload($("#<%=formAdvOpts.ClientID%>").serialize() + "&delID=" + dwRoomID);
                }, '提示', 1, function () { });
                  });
                $(".ListTbl").UniTable({ ShowCheck: false, HeaderIndex: true});
            });
            function SelectAllCheck() {
                $("#ListTbl :checkbox").attr("checked", "checked");
                $("#ListTbl :checkbox").parent().parent().addClass("selected");
            }
        </script>
    </form>
</asp:Content>
