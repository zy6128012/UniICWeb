﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="calendar.aspx.cs" Inherits="ClientWeb_xcus_hdsf_third_calendar" %>

<%@ Register TagPrefix="Uni" TagName="calendar" Src="../net/calendar.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>预约状态表</title>
    <script src="<%=ResolveClientUrl("~/ClientWeb/") %>fm/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script  src="<%=ResolveClientUrl("~/ClientWeb/") %>fm/jquery-ui/jquery-ui-1.10.3.custom.min.js"></script>
    <link href="<%=ResolveClientUrl("~/ClientWeb/") %>fm/jquery-ui/bootstrap/jquery-ui-1.10.3.custom.css"   rel='stylesheet' />
    <script  src="<%=ResolveClientUrl("~/ClientWeb/") %>fm/jquery-ui/bootstrap/js/bootstrap.js"></script>
    <link href="<%=ResolveClientUrl("~/ClientWeb/") %>fm/jquery-ui/bootstrap/css/bootstrap.css"   rel='stylesheet' />
    <script src="<%=ResolveClientUrl("~/ClientWeb/") %>fm/uni.lib.js" type="text/javascript"></script>
    <link href="<%=ResolveClientUrl("~/ClientWeb/") %>fm/uni.css" rel='stylesheet' />
    <script src="<%=ResolveClientUrl("~/ClientWeb/") %>pro/pro.lib.js" type="text/javascript"></script>
    <script src="<%=ResolveClientUrl("~/ClientWeb/") %>md/unicalendar/unicalendar.js" type="text/javascript"></script>
    <link href="<%=ResolveClientUrl("~/ClientWeb/") %>md/unicalendar/unicalendar.sch.css" rel='stylesheet' />
</head>
<body>
    <div class="cld">
        <Uni:calendar runat="server" Mode="d" />
        <div style="height:120px;"></div>
    </div>
</body>
</html>
