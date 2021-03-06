<%@ Page Language="C#" MasterPageFile="~/Templates/Sub.master" AutoEventWireup="true" CodeFile="Reserverec.aspx.cs" Inherits="Sub_Lab" %>

<%@ Register Src="~/Modules/PageCtrl.ascx" TagPrefix="uc1" TagName="PageCtrl" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Content" runat="Server">
    <form id="formAdvOpts" runat="server">
        <h2>预约记录</h2>
        <div class="toolbar">
            
        <div class="tb_info">
            <div class="UniTab" id="tabl">
                <a href="reserve.aspx" id="devList">预约与审核</a>
                <a href="reserveRec.aspx" id="devUseRec">预约记录</a>
            </div>
    
    </div>
         
        </div>
             <div  class="tb_infoInLine"  style="margin:5px 0px">
            <table style="width:99%">
               <tr>
                   <th>申请开始日期</th>
                   <td>
                    <input type="text" name="dwStartDate" id="dwStartDate" runat="server" />   
                   </td>
                   <th>申请结束日期</th>
                   <td><input type="text" name="dwEndDate" id="dwEndDate" runat="server"  /></td>
                  <th><input type="submit" id="btn" value="查询" /></th>
               </tr>
           </table>
        </div>
        <div class="content" style="margin-top:10px">
            <table class="ListTbl">
                <thead>
                    <tr>
                        <th>实验名称</th>
                        <th>申请人姓名</th>
                        <th><%=ConfigConst.GCTutorName %>姓名</th>
                        <th><%=ConfigConst.GCDevName %></th>
                        <th>所属<%=ConfigConst.GCLabName %></th>
                        <th name="dwOccurTime">提交时间</th>
                        <th>申请时间</th>
                    </tr>
                </thead>
                <tbody id="ListTbl">
                    <%=m_szOut %>
                </tbody>
            </table>
         <!--   <uc1:PageCtrl runat="server" ID="PageCtrl" />-->
        </div>
        <script type="text/javascript">

            $(function () {
                var tabl = $(".UniTab").UniTab();
                $("#btn").button();
                $("#<%=dwStartDate.ClientID%>,#<%=dwEndDate.ClientID%>").datepicker();
                $(".OPTD1").html('<div class="OPTDBtn">\
                       <a class="setLabBtn" title="审核"><img src="../../../themes/iconpage/edit.png"/></a></div>');
                $(".OPTD512").html('<div class="OPTDBtn">\
                       <a class="setLabBtn" title="调整结束时间"><img src="../../../themes/icon_s/18.png"/></a></div>');
                $(".OPTD524288").html('<div class="OPTDBtn">\
                       <a class="setLabBtn" title="结算"><img src="../../../themes/icon_s/19.png"/></a></div>');
                $(".OPTD1048576").html('<div class="OPTDBtn">\
                 <a class="btnPrit" title="打印结算单 "><img src="../../../themes/icon_s/11.png"/></a></div>');
                $(".OPTDBtn").UIAPanel({
                    theme: "none.png", borderWidth: 0, minWidth: "25", maxWidth: "50", minHeight: "25", maxHeight: "25", speed: 50
                });
                $(".OPTD1").click(function () {
                    var dwResvID = $(this).parents("tr").children().first().attr("data-id");
                    $.lhdialog({
                        title: '审核',
                        width: '700px',
                        height: '650px',
                        lock: true,
                        data: Dlg_Callback,
                        content: 'url:Dlg/checkbg.aspx?op=set&id=' + dwResvID
                    });
                });
                $(".OPTD1024").click(function () {
                    var dwResvID = $(this).parents("tr").children().first().attr("data-id");
                    $.lhdialog({
                        title: '预收费',
                        width: '600px',
                        height: '350px',
                        lock: true,
                        data: Dlg_Callback,
                        content: 'url:Dlg/checkbill.aspx?op=set&id=' + dwResvID
                    });
                });
                $(".OPTD524288").click(function () {
                    var dwResvID = $(this).parents("tr").children().first().attr("data-id");
                    $.lhdialog({
                        title: '结算',
                        width: '700px',
                        height: '680px',
                        lock: true,
                        data: Dlg_Callback,
                        content: 'url:Dlg/checkPayBill.aspx?op=set&id=' + dwResvID
                    });
                });
                $(".btnRuZhang").click(function () {
                    var dwResvID = $(this).parents("tr").children().first().attr("data-id");
                    $.lhdialog({
                        title: '入账',
                        width: '650px',
                        height: '450px',
                        lock: true,
                        data: Dlg_Callback,
                        content: 'url:Dlg/BillRecevie.aspx?op=set&id=' + dwResvID
                    });
                });
                $(".btnPrit").click(function () {
                    var dwResvID = $(this).parents("tr").children().first().attr("data-id");
                    $.lhdialog({
                        title: '打印',
                        width: '700px',
                        height: '600px',
                        lock: true,
                        data: Dlg_Callback,
                        content: 'url:Dlg/printBill.aspx?op=set&id=' + dwResvID
                    });
                });
                $(".OPTD512").click(function () {
                    var dwResvID = $(this).parents("tr").children().first().attr("data-id");
                    $.lhdialog({
                        title: '调整结束时间',
                        width: '600px',
                        height: '350px',
                        lock: true,
                        data: Dlg_Callback,
                        content: 'url:Dlg/changendtime.aspx?op=set&id=' + dwResvID
                    });
                });
                $(".InfoLabBtn").click(function () {
                    var szLabSN = $(this).parents("tr").children().first().text();
                    var dwLabID = $(this).parents("tr").children().first().attr("data-id");
                    $.lhdialog({
                        title: '介绍',
                        width: '760px',
                        height: '650px',
                        lock: true,
                        data: Dlg_Callback,
                        content: 'url:../../ueditor/default.aspx?id=' + dwLabID + "&type=LabInfo"
                    });
                });
                $(".delLabBtn").click(function () {
                    var szLabSN = $(this).parents("tr").children().first().text();
                    var dwLabID = $(this).parents("tr").children().first().attr("data-id");
                    ConfirmBox("确定删除?", function () {
                        ShowWait();
                        TabReload($("#<%=formAdvOpts.ClientID%>").serialize() + "&delID=" + dwLabID);
                }, '提示', 1, function () { });
                });
                $("input[name='dwCheckStat']").click(function () {
                   // pForm.data("UniTab_tab1", "reserve.aspx?dwCheckStat=" + $("input[name='dwCheckStat']").val());
                    TabReload($("#<%=formAdvOpts.ClientID%>").serialize());
                  });
            $("#btnNewLab").click(function () {
                $.lhdialog({
                    title: '新建',
                    width: '660px',
                    height: '400px',
                    lock: true,
                    data: Dlg_Callback,
                    content: 'url:Dlg/NewLab.aspx?op=new'
                });
            });
            //$(".ListTbl").UniTable();

        });
        </script>
          <style>
            #tbSearch
            {
                border-width: 1px;                
                border-color: #d1c1c1;                
                cursor: hand;
            }
                #tbSearch td
                {
                    font-family: "Trebuchet MS",Monospace,Serif;
                    font-size: 12px;               
                    padding-top: 2px;
                    padding-bottom: 2px;
                    padding-left: 15px;
                    padding-right: 15px;
                    border-style: solid;
                    border-width: 1px;                    
                }
            td input
            {
                margin-left:20px;
            }

        </style>
    </form>
</asp:Content>
