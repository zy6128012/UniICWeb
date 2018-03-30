﻿using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using UniWebLib;

public partial class _Default : UniPage
{
    protected bool bSet = false;
    protected string m_Title = "";
    protected string m_szCtrlMode = "";
    protected string m_szLab = "";
    protected string m_szManager = "";
    protected string m_szRoom = "";
    protected string m_szDevKind = "";
    protected string m_szPorperty = "";
	protected void Page_Load(object sender, EventArgs e)
	{
        m_Title = "修改设备";
        UNIDEVICE newDev;
        uint? uMax=0;        
        uint uID= PRDevice.DEVICE_BASE|PRDevice.MSREQ_DEVICE_SET;
        if (GetMaxValue(ref uMax, uID, "dwDevSN"))
        {

        }
        if (IsPostBack)
        {
            GetHTTPObj(out newDev);
            newDev.dwProperty = CharListToUint(Request["dwProperty"]);

            string szOpen = Request["chkopen"];
            if (newDev.dwProperty == null)
            {
               // newDev.dwProperty = 0;
            }
            if (szOpen != null && szOpen == "1")
            {
               // newDev.dwProperty = (uint)newDev.dwProperty | (uint)UNIDEVICE.DWPROPERTY.DEVPROP_NORESV;
            }
            else
            {
                if ((((uint)newDev.dwProperty) & (uint)UNIDEVICE.DWPROPERTY.DEVPROP_NORESV) > 0)
                {
                   // newDev.dwProperty = (uint)newDev.dwProperty - (uint)UNIDEVICE.DWPROPERTY.DEVPROP_NORESV;
                }
            }

          //  newDev.dwProperty =(CharListToUint(Request["dwProperty2"])|(uint)newDev.dwProperty);
            newDev.dwPurchaseDate = DateToUint(Request["dwPurchaseDate"]);            
            UNIGROUP newUseGroup;
            if (NewGroup(newDev.szDevName.ToString() + "使用组", (uint)UNIGROUP.DWKIND.GROUPKIND_DEV, out newUseGroup))
            {
                newDev.dwUseGroupID = newUseGroup.dwGroupID;
            }
            if (m_Request.Device.Set(newDev, out newDev) != REQUESTCODE.EXECUTE_SUCCESS)
            {
                MessageBox(m_Request.szErrMessage, "修改设备失败", MSGBOX.ERROR, MSGBOX_ACTION.NONE);
            }
            else
            {
                MessageBox("修改设备成功", "提示", MSGBOX.SUCCESS, MSGBOX_ACTION.OK);                             
                return;
            }
        }                    
        m_szPorperty = GetInputHtmlFromXml(0, CONSTHTML.checkBox, "dwProperty", "UNIDEVICE_Property", true);
        m_szPorperty+=GetInputItemHtml(CONSTHTML.checkBox, "dwProperty", "不对外开放", "524288");
        
        if (Request["op"] == "set")
        {
            bSet = true;

            DEVREQ vrDevReq = new DEVREQ();
            vrDevReq.dwDevID = Parse(Request["id"]);
            UNIDEVICE[] vtDev;
            if (m_Request.Device.Get(vrDevReq, out vtDev) != REQUESTCODE.EXECUTE_SUCCESS)
            {
                MessageBox(m_Request.szErrMessage, "获取失败", MSGBOX.ERROR, MSGBOX_ACTION.CANCEL);
            }
            else
            {
                if (vtDev.Length == 0)
                {
                    MessageBox("获取失败", "获取失败", MSGBOX.ERROR, MSGBOX_ACTION.CANCEL);
                }
                else
                {
                    PutJSObj(vtDev[0]);
                    ViewState["dwProperty"] = vtDev[0].dwProperty;
                    //ViewState["chkopen"] = vtDev[0].dwProperty;
                }
            }
        }
        else
        {
         

        }                      
	}
    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreLoad(e);
        if (ViewState["dwProperty"] != null && ViewState["dwProperty"].ToString() != "")
        {
            PutMemberValue("dwProperty", ViewState["dwProperty"].ToString());
        }
        if (ViewState["chkopen"] != null && ViewState["chkopen"].ToString() != "")
        {
            uint uOpen = Parse(ViewState["chkopen"].ToString());
            if ((uOpen & (uint)UNIDEVICE.DWPROPERTY.DEVPROP_NORESV) > 0)
            {
                PutMemberValue("chkopen", "1");
            }
        }
    }
}
