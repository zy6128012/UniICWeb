<%@ Page Language="C#" MasterPageFile="~/Templates/Main.master" AutoEventWireup="true" CodeFile="Main.aspx.cs" Inherits="_Default"%>

<asp:Content ID="Content1" ContentPlaceHolderID="Content" Runat="Server">
<div id="tabs">
   <!--//1超级管理员，2物管，4归口，8服务，16保卫，32没有审核权限 -->
    <ul>
       <%if (((uManMenu&32)==0)&&((((uManMenu & 2) > 0) || ((uManMenu & 4) > 0) || ((uManMenu & 8) > 0))))
         {%>
        <li><a href="YardResvCheckList.aspx">审核管理</a></li> 
        <%} %>

        <%if (((((uManMenu & 32) > 0)||((uManMenu & 1) > 0) || ((uManMenu & 2) > 0) || ((uManMenu & 16) > 0))))
         {%>
         <li><a href="ReserveList.aspx">占用日历</a></li>
         <%} %>

          <%if (((((uManMenu & 1) > 0) || ((uManMenu & 32) > 0) || ((uManMenu & 2) > 0) || ((uManMenu & 16) > 0))))
         {%>
           <li><a href="DeviceSiteList.aspx">资源维护</a></li>
        <%} %>
          <%if (((((uManMenu & 1) > 0) || ((uManMenu & 32) > 0) || ((uManMenu & 2) > 0) || ((uManMenu & 16) > 0))))
         {%>
        <li><a href="ReserveYard.aspx">预约管理</a></li>
        <%} %>
        <%if((uManMenu&1)>0 )
          {%>
        <li><a href="FeedBack.aspx">用户评价</a></li>
         <li><a href="DisciList.aspx">违约与处罚</a></li>
        <li><a href="ICINTRONotice.aspx">通知与空间介绍</a></li>
         <%} %>
    </ul>
</div>
    <script type="text/javascript">
        $(function () {
        });
    </script>
     <style media="screen" type="text/css">
        /* Styles for Example #1 */
        #example1 {
            margin: 0;
            padding: 0;
            width: 200px;
            list-style-type: none;
            line-height: 120%;
        }
        #example1 .closed {
            background-image: url(img/ha-down.gif);
        }
        #example1 .closed, #example1 .opened {
            padding-right: 10px;
            background-position: 98% 50%;
            background-repeat: no-repeat;
        }
        #example1 .header {
            background-color: #7B7B7B;
        }
        #example1 .opened {
            background-image: url(img/ha-up.gif);
        }
        #example1 a {
            display: block;
            font-weight: bold;
            text-decoration: none;
        }
        #example1 a.hover {
            border-top: 1px solid #5F5F5F;
            border-bottom: 1px solid #7B7B7B;
            background-color: #7B7B7B;
            color: #FFFFFF;
        }
        #example1 ul {

            margin: 0;
            padding: 0;
            overflow: hidden;
        }
        #example1 li {
            margin: 0;
            padding: 0;
            list-style-type: none;
            background-color: #848484;
            color: #FFFFFF;
        }
        #example1 li a {
            padding: 2px 10px 2px 4px;
            border-top: 1px solid #9A9A9A;
            border-left: 1px solid #9A9A9A;
            border-right: 1px solid #696969;
            border-bottom: 1px solid #757575;
            background-color: #848484;
            color: #FFFFFF;
        }
        #example1 li.active a, #example1 li li.active a {
            border-top: 1px solid #5F5F5F;
            border-bottom: 1px solid #7B7B7B;
            border-left: 1px solid #757575;
            border-right: 1px solid #9A9A9A;
            background-color: #404040;
            color: #FFFFFF;
        }
        #example1 li.active li a, #example1 li li a {
            padding: 2px 4px 2px 8px;
            border-top: 1px solid #696969;
            border-left: 1px solid #696969;
            border-right: 1px solid #8A8A8A;
            border-bottom: 1px solid #7B7B7B;
            background-color: #757575;
            color: #FFFFFF;
        }
    </style>
</asp:Content>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
