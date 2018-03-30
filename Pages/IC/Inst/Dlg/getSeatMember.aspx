<%@ Page Language="C#" MasterPageFile="~/Templates/Dlg.master" AutoEventWireup="true" CodeFile="getSeatMember.aspx.cs" Inherits="_Default" %>
<%@ Register Src="~/Modules/PageCtrl.ascx" TagPrefix="uc1" TagName="PageCtrl" %> 
<asp:Content ID="Content1" ContentPlaceHolderID="Content" runat="Server">
    <form id="formAdvOpts" runat="server" enctype="multipart/form-data">
        <div class="formtitle"><%=m_Title %></div>        
        <input type="hidden" name="id" id="id" />
        <input type="hidden" name="myop" id="myop" />
        <input type="hidden" name="isImport" id="isImport" runat="server" />
        <div class="ListTbl">
            <div>
              
            </div>
             <div id="addDiv">
            <table width="550" style="text-align:center;margin:0px auto">
                <tr>
                    <th colspan="4" style="text-align:center;"> 
                     
                    <input type="button" id="btnaddCancel" value="�ر�" /></th>
                </tr>
             <tr>                 
             </tr>
            </table>               
                </div>

               <div class="content" style="margin-top:10px">
            <table class="ListTbl">
                <thead>
                    <tr>
                        <th>��λ����</th>
                       <th>����</th>
                         <th>״̬</th>
                          
                    </tr>          
                </thead>
                <tbody id="Tbody1">
                    <%=m_szOut %>
                </tbody>
            </table>
        </div>
            <div style="margin:10px auto;text-align:center">
                <button type="button" id="Cancel">�ر�</button>
            </div>
        </div>
    </form>
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="Server">
    <style type="text/css">
        #addDiv table th
        {       
            height:30px;   
            text-align:right;
        }      
           #addDiv table td input
        {       
             margin-left:10px;
             height:18px;
             width:140px;
        }
             .ui-datepicker select.ui-datepicker-year { width: 43%;}
            .tb_infoInLine td input {
            width:120px;
            }
            .ui-autocomplete{
       z-index: 11111;
}
    </style>
  <script language="javascript" type="text/javascript" src="<%=MyVPath %>themes/js/MainJScript.js"></script>
    <script language="javascript" type="text/javascript">
        $(function () {
            $("#dwStartDate,#dwEndDate").datepicker();
            $("#btnAdd").click(function () {
                $("#addDiv").dialog("open");
            });
            AutoUserByLogonname($("#szPid"), 2, $("#dwAccno"), $("#Handphone"), null, $("#email"));
            $("#szPid").on("autocompleteselect", function (event, ui) {
                setTimeout(function () {
                    $("#szPid").val(ui.item.szLogonName);
                    $("#szTrueName").val(ui.item.szTrueName);
                }, 100);
            });

            $("#btnAddOK").button().click(function () {
                var GroupID = $("#id").val();
                var MemberID = $("#dwAccno").val();
                var name = $("#szTrueName").val();
                var vBeginDate = $("#dwStartDate").val();
                var vEndDate = $("#dwEndDate").val();
                $.ajax({
                    type: 'get',
                    url: '../../data/addgroupmember.aspx?type=accno',
                    data: { 'GroupID': GroupID, 'MemberID': MemberID, 'KindID': 2, 'Name': name, 'dwStartDate': vBeginDate, 'dwEndDate': vEndDate },
                    dataType: "text",
                    success: function (data) {
                        var message2 = data;
                        if (message2 == 'succ') {
                            $("#dwAccno").val("");
                            ConfirmBox2('���ӳɹ�', function () { $("#<%=formAdvOpts.ClientID%>").submit(); });
                        }
                        else {
                            ConfirmBox2('����ʧ��' + message2, function () { });
                        }
                    },
                    error: function (data) {
                        ConfirmBox2('ʧ��', function () { });
                    }
                });
            });
            $("#btnaddCancel,#delList").button()
           .click(function () {
               $("#addDiv").dialog("close");
           });
            $("#addDiv").dialog({
                autoOpen: false,
                height: 220,
                width: 700,
                modal: true
            });
            $("#btnSearch,#btnAdd,#btnAddOK").button();
            var vImportVal = $("#<%=isImport.ClientID%>").val();
            if (vImportVal != "1") {
                $("#importTable").hide();
            }
            $("#btnImportBtn").button().click(function () {
                $("#myop").val("import");
                $("#<%=formAdvOpts.ClientID%>").submit();
            });
            $("#btnViewBtn").button().click(function () {
                $("#myop").val("view");
                $("#<%=formAdvOpts.ClientID%>").submit();
            });
            $("#btnImPort").button().click(function () {
                $("#importTable").show();
            }
                );
            $("#Cancel").button().click(Dlg_Cancel);
            $(".OPTD").html('<div class="OPTDBtn">\
<a class="delBtn" title="ɾ��"><img src="../../../../themes/iconpage/del.png""/></a>\</div>');
            $(".OPTDBtn").UIAPanel({
                theme: "none.png", borderWidth: 0, minWidth: "25", maxWidth: "75", minHeight: "25", maxHeight: "25", speed: 50
            });
          
            $(".delBtn").click(function () {
                var MeberID = $(this).parents("tr").children().first().attr("data-accno");;
                ConfirmBox("ȷ��ɾ��?", function () {
                    var GroupID = $("#id").val();
                    $.get(
             "../../data/DelGroupMember.aspx",
             { GroupID: GroupID, MemberID: MeberID, KindID: 2 },
             function (data) {
                 if (data == "success") {
                     $("#<%=formAdvOpts.ClientID%>").submit();
                 }
                 else {
                     MessageBox(data, "", 2);
                 }
             }
        );});

            });
      
            $("#btnAdd").button()
            $("#btnAdd").click(function () {
                    $("#addDiv").dialog("open");                                    
                });

    });
    </script>
</asp:Content>
